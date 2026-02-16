import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Radio group sizes
enum DRadioGroupSize { xs, sm, md, lg, xl }

/// Radio group colors
enum DRadioGroupColor { primary, gray, success, warning, error }

/// Radio group orientation
enum DRadioGroupOrientation { horizontal, vertical }

/// Radio option item
class DRadioOption<T> {
  final T value;
  final String label;
  final String? description;
  final bool disabled;

  const DRadioOption({
    required this.value,
    required this.label,
    this.description,
    this.disabled = false,
  });
}

/// DuxtUI Radio Group component
class DRadioGroup<T> extends StatelessComponent {
  final String? label;
  final List<DRadioOption<T>> options;
  final T? value;
  final String name;
  final bool disabled;
  final bool required;
  final DRadioGroupSize size;
  final DRadioGroupColor color;
  final DRadioGroupOrientation orientation;
  final String? error;
  final String? hint;
  final ValueChanged<T>? onChange;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DRadioGroup({
    super.key,
    this.label,
    required this.options,
    required this.name,
    this.value,
    this.disabled = false,
    this.required = false,
    this.size = DRadioGroupSize.md,
    this.color = DRadioGroupColor.primary,
    this.orientation = DRadioGroupOrientation.vertical,
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
      case DRadioGroupSize.xs:
        return 'h-3 w-3';
      case DRadioGroupSize.sm:
        return 'h-3.5 w-3.5';
      case DRadioGroupSize.md:
        return 'h-4 w-4';
      case DRadioGroupSize.lg:
        return 'h-5 w-5';
      case DRadioGroupSize.xl:
        return 'h-6 w-6';
    }
  }

  String get _labelSizeClasses {
    switch (size) {
      case DRadioGroupSize.xs:
        return 'text-xs';
      case DRadioGroupSize.sm:
        return 'text-xs';
      case DRadioGroupSize.md:
        return 'text-sm';
      case DRadioGroupSize.lg:
        return 'text-base';
      case DRadioGroupSize.xl:
        return 'text-lg';
    }
  }

  String get _colorClasses {
    final baseColor = switch (color) {
      DRadioGroupColor.primary => 'cyan',
      DRadioGroupColor.gray => 'gray',
      DRadioGroupColor.success => 'green',
      DRadioGroupColor.warning => 'yellow',
      DRadioGroupColor.error => 'red',
    };
    return 'text-$baseColor-600 focus:ring-$baseColor-500/20';
  }

  String get _orientationClasses {
    switch (orientation) {
      case DRadioGroupOrientation.horizontal:
        return 'flex flex-row flex-wrap gap-4';
      case DRadioGroupOrientation.vertical:
        return 'flex flex-col gap-2';
    }
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final borderColor =
        hasError ? 'border-red-500' : 'border-gray-300 dark:border-gray-600';

    return Div(
      id: id,
      className: twMerge('space-y-2', className),
      attributes: attributes,
      events: events,
      children: [
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
            Div(className: 'flex items-start gap-2', children: [
              Div(className: 'flex items-center h-5', children: [
                Input(
                  type: 'radio',
                  name: name,
                  disabled: disabled || option.disabled,
                  className:
                      '$_sizeClasses $_colorClasses rounded-full border-2 $borderColor bg-white dark:bg-zinc-900 cursor-pointer focus:ring-2 focus:ring-offset-0 ${disabled || option.disabled ? "opacity-50 cursor-not-allowed" : ""}',
                  attributes: {
                    'value': option.value.toString(),
                    if (value == option.value) 'checked': 'true',
                  },
                  events: {
                    'change': (_) {
                      if (onChange != null && !option.disabled) {
                        onChange!(option.value);
                      }
                    },
                  },
                ),
              ]),
              if (option.label.isNotEmpty || option.description != null)
                Div(className: 'flex flex-col', children: [
                  Span(
                    className:
                        '$_labelSizeClasses font-medium ${disabled || option.disabled ? "text-gray-400" : "text-gray-700 dark:text-gray-200"} cursor-pointer',
                    children: [Text(option.label)],
                  ),
                  if (option.description != null)
                    P(
                      className: 'text-xs text-gray-500 dark:text-gray-400',
                      children: [Text(option.description!)],
                    ),
                ]),
            ]),
        ],
      ),
      if (hasError)
        P(className: 'text-sm text-red-600', children: [Text(error!)])
      else if (hint != null)
        P(className: 'text-sm text-gray-500', children: [Text(hint!)]),
    ]);
  }
}
