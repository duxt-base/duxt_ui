import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/tw_merge.dart';

/// Form validation state
enum DFormState { initial, validating, valid, invalid }

/// Form validation result
class DFormValidationResult {
  final bool isValid;
  final Map<String, String?> errors;

  const DFormValidationResult({
    required this.isValid,
    this.errors = const {},
  });

  String? getError(String fieldName) => errors[fieldName];
}

/// Form submission callback with form data
typedef FormSubmitCallback = void Function(Map<String, dynamic> data);

/// Form validation callback
typedef FormValidateCallback = DFormValidationResult Function(Map<String, dynamic> data);

/// DuxtUI Form component - Form wrapper with validation support
class DForm extends StatefulComponent {
  final String? id;
  final String? name;
  final List<Component> children;
  final bool disabled;
  final bool validateOnSubmit;
  final bool validateOnBlur;
  final bool validateOnChange;
  final FormValidateCallback? onValidate;
  final FormSubmitCallback? onSubmit;
  final VoidCallback? onReset;
  final String? className;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DForm({
    super.key,
    this.id,
    this.name,
    required this.children,
    this.disabled = false,
    this.validateOnSubmit = true,
    this.validateOnBlur = false,
    this.validateOnChange = false,
    this.onValidate,
    this.onSubmit,
    this.onReset,
    this.className,
    this.attributes,
    this.events,
  });

  @override
  State<DForm> createState() => _UFormState();
}

class _UFormState extends State<DForm> {
  DFormState _state = DFormState.initial;
  Map<String, String?> _errors = {};

  void _handleSubmit(dynamic event) {
    event.preventDefault();

    if (component.disabled) return;

    final formElement = event.target as dynamic;
    final formData = _getFormData(formElement);

    if (component.validateOnSubmit && component.onValidate != null) {
      setState(() => _state = DFormState.validating);

      final result = component.onValidate!(formData);

      setState(() {
        _errors = result.errors;
        _state = result.isValid ? DFormState.valid : DFormState.invalid;
      });

      if (!result.isValid) return;
    }

    component.onSubmit?.call(formData);
  }

  void _handleReset() {
    setState(() {
      _state = DFormState.initial;
      _errors = {};
    });
    component.onReset?.call();
  }

  Map<String, dynamic> _getFormData(dynamic formElement) {
    final data = <String, dynamic>{};
    final elements = formElement.elements;
    final length = elements.length as int;

    for (var i = 0; i < length; i++) {
      final element = elements[i];
      final name = element.name as String?;
      if (name != null && name.isNotEmpty) {
        final tagName = (element.tagName as String).toLowerCase();

        if (tagName == 'input') {
          final type = element.type as String;
          if (type == 'checkbox') {
            data[name] = element.checked as bool;
          } else if (type == 'radio') {
            if (element.checked as bool) {
              data[name] = element.value as String;
            }
          } else if (type == 'file') {
            data[name] = element.files;
          } else if (type == 'number') {
            data[name] = double.tryParse(element.value as String) ?? 0;
          } else {
            data[name] = element.value as String;
          }
        } else if (tagName == 'textarea' || tagName == 'select') {
          data[name] = element.value as String;
        }
      }
    }

    return data;
  }

  @override
  Component build(BuildContext context) {
    return Form(
      id: component.id,
      className: twMerge(cx([
        'space-y-4',
        component.disabled ? 'opacity-50 pointer-events-none' : null,
      ]), component.className),
      attributes: mergeAttributes({
        if (component.name != null) 'name': component.name!,
        'novalidate': 'true', // Use custom validation
      }, component.attributes),
      events: {
        'submit': _handleSubmit,
        'reset': (_) => _handleReset(),
        ...?component.events,
      },
      children: [
        // Provide form context via wrapper
        _UFormContext(
          state: _state,
          errors: _errors,
          child: Div(children: [...component.children]),
        ),
      ],
    );
  }
}

/// Internal form context wrapper
class _UFormContext extends StatelessComponent {
  final DFormState state;
  final Map<String, String?> errors;
  final Component child;

  const _UFormContext({
    required this.state,
    required this.errors,
    required this.child,
  });

  @override
  Component build(BuildContext context) {
    return child;
  }
}

/// Form actions container for submit/reset buttons
class DFormActions extends StatelessComponent {
  final List<Component> children;
  final MainAxisAlignment alignment;

  const DFormActions({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.end,
  });

  String get _alignmentClasses {
    switch (alignment) {
      case MainAxisAlignment.start:
        return 'justify-start';
      case MainAxisAlignment.center:
        return 'justify-center';
      case MainAxisAlignment.end:
        return 'justify-end';
      case MainAxisAlignment.spaceBetween:
        return 'justify-between';
      case MainAxisAlignment.spaceAround:
        return 'justify-around';
      case MainAxisAlignment.spaceEvenly:
        return 'justify-evenly';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'flex items-center gap-3 pt-4 $_alignmentClasses',
      children: children,
    );
  }
}

/// Main axis alignment options
enum MainAxisAlignment {
  start,
  center,
  end,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

/// Form row for horizontal field layout
class DFormRow extends StatelessComponent {
  final List<Component> children;
  final int columns;

  const DFormRow({
    super.key,
    required this.children,
    this.columns = 2,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'grid grid-cols-$columns gap-4',
      children: children,
    );
  }
}

/// Form section with optional title
class DFormSection extends StatelessComponent {
  final String? title;
  final String? description;
  final List<Component> children;

  const DFormSection({
    super.key,
    this.title,
    this.description,
    required this.children,
  });

  @override
  Component build(BuildContext context) {
    return Div(className: 'space-y-4', children: [
      if (title != null || description != null)
        Div(className: 'border-b border-gray-200 dark:border-gray-700 pb-4', children: [
          if (title != null)
            H3(
              className: 'text-lg font-medium text-gray-900 dark:text-white',
              children: [Text(title!)],
            ),
          if (description != null)
            P(
              className: 'mt-1 text-sm text-gray-500 dark:text-gray-400',
              children: [Text(description!)],
            ),
        ]),
      ...children,
    ]);
  }
}
