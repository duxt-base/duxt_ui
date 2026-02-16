import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/tw_merge.dart';

/// Form field sizes
enum DFormFieldSize { sm, md, lg }

/// Validation rule
class DValidationRule {
  final String message;
  final bool Function(dynamic value) validator;

  const DValidationRule({
    required this.message,
    required this.validator,
  });
}

/// Common validation rules
class DValidators {
  /// Required field validator
  static DValidationRule required([String? message]) {
    return DValidationRule(
      message: message ?? 'This field is required',
      validator: (value) {
        if (value == null) return false;
        if (value is String) return value.trim().isNotEmpty;
        if (value is List) return value.isNotEmpty;
        return true;
      },
    );
  }

  /// Email validator
  static DValidationRule email([String? message]) {
    return DValidationRule(
      message: message ?? 'Please enter a valid email address',
      validator: (value) {
        if (value == null || value is! String || value.isEmpty) return true;
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        return emailRegex.hasMatch(value);
      },
    );
  }

  /// Minimum length validator
  static DValidationRule minLength(int length, [String? message]) {
    return DValidationRule(
      message: message ?? 'Must be at least $length characters',
      validator: (value) {
        if (value == null || value is! String || value.isEmpty) return true;
        return value.length >= length;
      },
    );
  }

  /// Maximum length validator
  static DValidationRule maxLength(int length, [String? message]) {
    return DValidationRule(
      message: message ?? 'Must be no more than $length characters',
      validator: (value) {
        if (value == null || value is! String) return true;
        return value.length <= length;
      },
    );
  }

  /// Minimum value validator (for numbers)
  static DValidationRule min(num minValue, [String? message]) {
    return DValidationRule(
      message: message ?? 'Must be at least $minValue',
      validator: (value) {
        if (value == null) return true;
        final numValue = value is num ? value : num.tryParse(value.toString());
        if (numValue == null) return true;
        return numValue >= minValue;
      },
    );
  }

  /// Maximum value validator (for numbers)
  static DValidationRule max(num maxValue, [String? message]) {
    return DValidationRule(
      message: message ?? 'Must be no more than $maxValue',
      validator: (value) {
        if (value == null) return true;
        final numValue = value is num ? value : num.tryParse(value.toString());
        if (numValue == null) return true;
        return numValue <= maxValue;
      },
    );
  }

  /// Pattern validator (regex)
  static DValidationRule pattern(RegExp regex, [String? message]) {
    return DValidationRule(
      message: message ?? 'Invalid format',
      validator: (value) {
        if (value == null || value is! String || value.isEmpty) return true;
        return regex.hasMatch(value);
      },
    );
  }

  /// Custom validator
  static DValidationRule custom(
    bool Function(dynamic value) validator,
    String message,
  ) {
    return DValidationRule(
      message: message,
      validator: validator,
    );
  }
}

/// DuxtUI FormField component - Field wrapper with label, validation, and error display
class DFormField extends StatefulComponent {
  final String? name;
  final String? label;
  final String? hint;
  final String? error;
  final bool required;
  final bool disabled;
  final DFormFieldSize size;
  final List<DValidationRule> rules;
  final List<Component> children;
  final bool validateOnBlur;
  final bool validateOnChange;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DFormField({
    super.key,
    this.name,
    this.label,
    this.hint,
    this.error,
    this.required = false,
    this.disabled = false,
    this.size = DFormFieldSize.md,
    this.rules = const [],
    required this.children,
    this.validateOnBlur = true,
    this.validateOnChange = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  State<DFormField> createState() => _UFormFieldState();
}

class _UFormFieldState extends State<DFormField> {
  String? _error;
  bool _touched = false;

  String get _labelSizeClasses {
    switch (component.size) {
      case DFormFieldSize.sm:
        return 'text-xs';
      case DFormFieldSize.md:
        return 'text-sm';
      case DFormFieldSize.lg:
        return 'text-base';
    }
  }

  String get _hintSizeClasses {
    switch (component.size) {
      case DFormFieldSize.sm:
        return 'text-xs';
      case DFormFieldSize.md:
        return 'text-sm';
      case DFormFieldSize.lg:
        return 'text-sm';
    }
  }

  String? validate(dynamic value) {
    // Check required first
    if (component.required) {
      final requiredRule = DValidators.required();
      if (!requiredRule.validator(value)) {
        return requiredRule.message;
      }
    }

    // Check other rules
    for (final rule in component.rules) {
      if (!rule.validator(value)) {
        return rule.message;
      }
    }

    return null;
  }

  void _handleBlur(dynamic value) {
    if (!component.validateOnBlur) return;
    setState(() {
      _touched = true;
      _error = validate(value);
    });
  }

  void _handleChange(dynamic value) {
    if (!component.validateOnChange && !_touched) return;
    setState(() {
      _error = validate(value);
    });
  }

  @override
  Component build(BuildContext context) {
    final displayError = component.error ?? _error;
    final hasError = displayError != null && displayError.isNotEmpty;

    return Div(
      id: component.id,
      className: twMerge(cx([
        'space-y-1',
        component.disabled ? 'opacity-50' : null,
      ]), component.className),
      attributes: component.attributes,
      events: {
        'focusout': (event) {
          final target = event.target as dynamic;
          _handleBlur(target.value);
        },
        'input': (event) {
          final target = event.target as dynamic;
          _handleChange(target.value);
        },
        ...?component.events,
      },
      children: [
        // Label
        if (component.label != null)
          Label(
            className: cx([
              'block',
              'font-medium',
              _labelSizeClasses,
              hasError
                  ? 'text-red-700 dark:text-red-400'
                  : 'text-gray-700 dark:text-gray-200',
            ]),
            attributes: {
              if (component.name != null) 'for': component.name!,
            },
            children: [
              Text(component.label!),
              if (component.required)
                Span(className: 'text-red-500 ml-1', children: [Text('*')]),
            ],
          ),
        // Field content (input, select, etc.)
        Div(className: 'relative', children: component.children),
        // Error or hint message
        if (hasError)
          P(
            className: cx([
              _hintSizeClasses,
              'text-red-600',
              'dark:text-red-400',
              'mt-1',
            ]),
            children: [Text(displayError)],
          )
        else if (component.hint != null)
          P(
            className: cx([
              _hintSizeClasses,
              'text-gray-500',
              'dark:text-gray-400',
              'mt-1',
            ]),
            children: [Text(component.hint!)],
          ),
      ],
    );
  }
}

/// Form field group for grouping related fields (e.g., radio buttons)
class DFormFieldGroup extends StatelessComponent {
  final String? label;
  final String? hint;
  final String? error;
  final bool required;
  final List<Component> children;
  final bool inline;

  const DFormFieldGroup({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.required = false,
    required this.children,
    this.inline = false,
  });

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return Fieldset(
      className: 'space-y-2',
      children: [
        if (label != null)
          Legend(
            className: cx([
              'text-sm',
              'font-medium',
              hasError
                  ? 'text-red-700 dark:text-red-400'
                  : 'text-gray-700 dark:text-gray-200',
            ]),
            children: [
              Text(label!),
              if (required)
                Span(className: 'text-red-500 ml-1', children: [Text('*')]),
            ],
          ),
        Div(
          className: inline ? 'flex flex-wrap gap-4' : 'space-y-2',
          children: children,
        ),
        if (hasError)
          P(
              className: 'text-sm text-red-600 dark:text-red-400',
              children: [Text(error!)])
        else if (hint != null)
          P(
              className: 'text-sm text-gray-500 dark:text-gray-400',
              children: [Text(hint!)]),
      ],
    );
  }
}

/// Helper component for displaying field errors
class DFieldError extends StatelessComponent {
  final String? error;

  const DFieldError({super.key, this.error});

  @override
  Component build(BuildContext context) {
    if (error == null || error!.isEmpty) {
      return Span(children: []);
    }

    return P(
      className: 'text-sm text-red-600 dark:text-red-400 mt-1',
      children: [Text(error!)],
    );
  }
}

/// Helper component for displaying field hints
class DFieldHint extends StatelessComponent {
  final String hint;

  const DFieldHint({super.key, required this.hint});

  @override
  Component build(BuildContext context) {
    return P(
      className: 'text-sm text-gray-500 dark:text-gray-400 mt-1',
      children: [Text(hint)],
    );
  }
}
