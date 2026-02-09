import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

/// Switch sizes
enum DSwitchSize { xs, sm, md, lg, xl }

/// Switch colors
enum DSwitchColor { primary, gray, success, warning, error }

/// DuxtUI Switch component
class DSwitch extends StatelessComponent {
  final String? label;
  final String? description;
  final String? name;
  final bool checked;
  final bool disabled;
  final bool required;
  final DSwitchSize size;
  final DSwitchColor color;
  final String? onLabel;
  final String? offLabel;
  final Component? onIcon;
  final Component? offIcon;
  final String? error;
  final String? hint;
  final ValueChanged<bool>? onChange;

  const DSwitch({
    super.key,
    this.label,
    this.description,
    this.name,
    this.checked = false,
    this.disabled = false,
    this.required = false,
    this.size = DSwitchSize.md,
    this.color = DSwitchColor.primary,
    this.onLabel,
    this.offLabel,
    this.onIcon,
    this.offIcon,
    this.error,
    this.hint,
    this.onChange,
  });

  String get _trackSizeClasses {
    switch (size) {
      case DSwitchSize.xs:
        return 'h-4 w-7';
      case DSwitchSize.sm:
        return 'h-5 w-9';
      case DSwitchSize.md:
        return 'h-6 w-11';
      case DSwitchSize.lg:
        return 'h-7 w-14';
      case DSwitchSize.xl:
        return 'h-8 w-16';
    }
  }

  String get _thumbSizeClasses {
    switch (size) {
      case DSwitchSize.xs:
        return 'h-3 w-3';
      case DSwitchSize.sm:
        return 'h-4 w-4';
      case DSwitchSize.md:
        return 'h-5 w-5';
      case DSwitchSize.lg:
        return 'h-6 w-6';
      case DSwitchSize.xl:
        return 'h-7 w-7';
    }
  }

  String get _thumbTranslateClasses {
    final translateOn = switch (size) {
      DSwitchSize.xs => 'translate-x-3',
      DSwitchSize.sm => 'translate-x-4',
      DSwitchSize.md => 'translate-x-5',
      DSwitchSize.lg => 'translate-x-7',
      DSwitchSize.xl => 'translate-x-8',
    };
    return checked ? translateOn : 'translate-x-0.5';
  }

  String get _labelSizeClasses {
    switch (size) {
      case DSwitchSize.xs:
        return 'text-xs';
      case DSwitchSize.sm:
        return 'text-xs';
      case DSwitchSize.md:
        return 'text-sm';
      case DSwitchSize.lg:
        return 'text-base';
      case DSwitchSize.xl:
        return 'text-lg';
    }
  }

  String get _trackColorClasses {
    final baseColor = switch (color) {
      DSwitchColor.primary => 'cyan',
      DSwitchColor.gray => 'gray',
      DSwitchColor.success => 'green',
      DSwitchColor.warning => 'yellow',
      DSwitchColor.error => 'red',
    };
    return checked ? 'bg-$baseColor-600' : 'bg-gray-200 dark:bg-zinc-700';
  }

  String get _focusRingClasses {
    final baseColor = switch (color) {
      DSwitchColor.primary => 'cyan',
      DSwitchColor.gray => 'gray',
      DSwitchColor.success => 'green',
      DSwitchColor.warning => 'yellow',
      DSwitchColor.error => 'red',
    };
    return 'focus:ring-$baseColor-500/20';
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return div(classes: 'space-y-1', [
      div(classes: 'flex items-start gap-3', [
        // Hidden input for form submission
        input(
          type: InputType.checkbox,
          name: name,
          id: name != null ? 'switch-$name' : null,
          disabled: disabled,
          classes: 'sr-only peer',
          attributes: {
            if (checked) 'checked': 'true',
            if (required) 'required': 'true',
          },
        ),
        // Switch track
        button(
          type: ButtonType.button,
          disabled: disabled,
          onClick: disabled
              ? null
              : () {
                  if (onChange != null) {
                    onChange!(!checked);
                  }
                },
          classes:
              'relative inline-flex $_trackSizeClasses shrink-0 cursor-pointer rounded-full border-2 border-transparent $_trackColorClasses transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 $_focusRingClasses ${disabled ? "opacity-50 cursor-not-allowed" : ""}',
          attributes: {
            'role': 'switch',
            'aria-checked': checked.toString(),
          },
          [
            // Switch thumb
            span(
              classes:
                  'pointer-events-none inline-block $_thumbSizeClasses $_thumbTranslateClasses transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out',
              [
                // Icon inside thumb
                if (checked && onIcon != null)
                  span(
                    classes:
                        'absolute inset-0 flex items-center justify-center',
                    [onIcon!],
                  )
                else if (!checked && offIcon != null)
                  span(
                    classes:
                        'absolute inset-0 flex items-center justify-center',
                    [offIcon!],
                  ),
              ],
            ),
          ],
        ),
        // Label and description
        if (label != null ||
            description != null ||
            onLabel != null ||
            offLabel != null)
          div(
            classes: 'flex flex-col cursor-pointer',
            events: {
              'click': (_) {
                if (!disabled && onChange != null) {
                  onChange!(!checked);
                }
              },
            },
            [
              if (label != null)
                span(
                  classes:
                      '$_labelSizeClasses font-medium ${disabled ? "text-gray-400" : "text-gray-700 dark:text-gray-200"}',
                  [
                    Component.text(label!),
                    if (required)
                      span(classes: 'text-red-500 ml-1', [Component.text('*')]),
                  ],
                )
              else if (onLabel != null || offLabel != null)
                span(
                  classes:
                      '$_labelSizeClasses font-medium ${disabled ? "text-gray-400" : "text-gray-700 dark:text-gray-200"}',
                  [
                    Component.text(checked ? (onLabel ?? '') : (offLabel ?? ''))
                  ],
                ),
              if (description != null)
                p(
                  classes: 'text-xs text-gray-500 dark:text-gray-400',
                  [Component.text(description!)],
                ),
            ],
          ),
      ]),
      if (hasError)
        p(classes: 'text-sm text-red-600', [Component.text(error!)])
      else if (hint != null)
        p(classes: 'text-sm text-gray-500', [Component.text(hint!)]),
    ]);
  }
}
