import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import 'checkbox.dart';

/// Checkbox group orientation
enum DCheckboxGroupOrientation { horizontal, vertical }

/// Checkbox option item
class DCheckboxOption<T> {
  final T value;
  final String label;
  final String? description;
  final bool disabled;

  const DCheckboxOption({
    required this.value,
    required this.label,
    this.description,
    this.disabled = false,
  });
}

/// DuxtUI Checkbox Group component
class DCheckboxGroup<T> extends StatelessComponent {
  final String? label;
  final List<DCheckboxOption<T>> options;
  final List<T> value;
  final String? name;
  final bool disabled;
  final bool required;
  final DCheckboxSize size;
  final DCheckboxColor color;
  final DCheckboxGroupOrientation orientation;
  final String? error;
  final String? hint;
  final ValueChanged<List<T>>? onChange;

  const DCheckboxGroup({
    super.key,
    this.label,
    required this.options,
    this.value = const [],
    this.name,
    this.disabled = false,
    this.required = false,
    this.size = DCheckboxSize.md,
    this.color = DCheckboxColor.primary,
    this.orientation = DCheckboxGroupOrientation.vertical,
    this.error,
    this.hint,
    this.onChange,
  });

  String get _orientationClasses {
    switch (orientation) {
      case DCheckboxGroupOrientation.horizontal:
        return 'flex flex-row flex-wrap gap-4';
      case DCheckboxGroupOrientation.vertical:
        return 'flex flex-col gap-2';
    }
  }

  bool _isChecked(T optionValue) {
    return value.contains(optionValue);
  }

  void _handleChange(T optionValue, bool checked) {
    if (onChange == null) return;

    final newValue = List<T>.from(value);
    if (checked) {
      if (!newValue.contains(optionValue)) {
        newValue.add(optionValue);
      }
    } else {
      newValue.remove(optionValue);
    }
    onChange!(newValue);
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return Div(className: 'space-y-2', children: [
      if (label != null)
        Span(
            className:
                'block text-sm font-medium text-gray-700 dark:text-gray-200',
            children: [
              Text(label!),
              if (required)
                Span(className: 'text-red-500 ml-1', children: [Text('*')]),
            ]),
      Fieldset(
        className: _orientationClasses,
        children: [
          for (final option in options)
            DCheckbox(
              label: option.label,
              description: option.description,
              name: name != null ? '${name}[]' : null,
              checked: _isChecked(option.value),
              disabled: disabled || option.disabled,
              size: size,
              color: color,
              onChange: (checked) => _handleChange(option.value, checked),
            ),
        ],
      ),
      if (hasError)
        P(className: 'text-sm text-red-600', children: [Text(error!)])
      else if (hint != null)
        P(className: 'text-sm text-gray-500', children: [Text(hint!)]),
    ]);
  }
}
