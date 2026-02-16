import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Checkbox sizes
enum DCheckboxSize { xs, sm, md, lg, xl }

/// Checkbox colors
enum DCheckboxColor { primary, gray, success, warning, error }

/// DuxtUI Checkbox component
class DCheckbox extends StatelessComponent {
  final String? label;
  final String? description;
  final String? name;
  final bool checked;
  final bool disabled;
  final bool required;
  final bool indeterminate;
  final DCheckboxSize size;
  final DCheckboxColor color;
  final String? error;
  final String? hint;
  final ValueChanged<bool>? onChange;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DCheckbox({
    super.key,
    this.label,
    this.description,
    this.name,
    this.checked = false,
    this.disabled = false,
    this.required = false,
    this.indeterminate = false,
    this.size = DCheckboxSize.md,
    this.color = DCheckboxColor.primary,
    this.error,
    this.hint,
    this.onChange,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DCheckboxSize.xs:
        return 'h-3 w-3';
      case DCheckboxSize.sm:
        return 'h-3.5 w-3.5';
      case DCheckboxSize.md:
        return 'h-4 w-4';
      case DCheckboxSize.lg:
        return 'h-5 w-5';
      case DCheckboxSize.xl:
        return 'h-6 w-6';
    }
  }

  String get _labelSizeClasses {
    switch (size) {
      case DCheckboxSize.xs:
        return 'text-xs';
      case DCheckboxSize.sm:
        return 'text-xs';
      case DCheckboxSize.md:
        return 'text-sm';
      case DCheckboxSize.lg:
        return 'text-base';
      case DCheckboxSize.xl:
        return 'text-lg';
    }
  }

  String get _colorClasses {
    final baseColor = switch (color) {
      DCheckboxColor.primary => 'cyan',
      DCheckboxColor.gray => 'gray',
      DCheckboxColor.success => 'green',
      DCheckboxColor.warning => 'yellow',
      DCheckboxColor.error => 'red',
    };
    return 'text-$baseColor-600 focus:ring-$baseColor-500/20';
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final borderColor =
        hasError ? 'border-red-500' : 'border-gray-300 dark:border-gray-600';

    return Div(className: 'space-y-1', children: [
      Div(className: 'flex items-start gap-2', children: [
        Div(className: 'flex items-center h-5', children: [
          Input(
            type: 'checkbox',
            name: name,
            id: id,
            disabled: disabled,
            className: twMerge(
                '$_sizeClasses $_colorClasses rounded border-2 $borderColor bg-white dark:bg-zinc-900 cursor-pointer focus:ring-2 focus:ring-offset-0 ${disabled ? "opacity-50 cursor-not-allowed" : ""}',
                className),
            attributes: mergeAttributes({
              if (checked) 'checked': 'true',
              if (indeterminate) 'indeterminate': 'true',
              if (required) 'required': 'true',
            }, attributes),
            events: {
              'change': (event) {
                if (onChange != null) {
                  // Toggle the current state
                  onChange!(!checked);
                }
              },
              ...?events,
            },
          ),
        ]),
        if (label != null || description != null)
          Div(className: 'flex flex-col', children: [
            if (label != null)
              Span(
                className:
                    '$_labelSizeClasses font-medium ${disabled ? "text-gray-400" : "text-gray-700 dark:text-gray-200"} cursor-pointer',
                children: [
                  Text(label!),
                  if (required)
                    Span(className: 'text-red-500 ml-1', children: [Text('*')]),
                ],
              ),
            if (description != null)
              P(
                className: 'text-xs text-gray-500 dark:text-gray-400',
                children: [Text(description!)],
              ),
          ]),
      ]),
      if (hasError)
        P(className: 'text-sm text-red-600', children: [Text(error!)])
      else if (hint != null)
        P(className: 'text-sm text-gray-500', children: [Text(hint!)]),
    ]);
  }
}
