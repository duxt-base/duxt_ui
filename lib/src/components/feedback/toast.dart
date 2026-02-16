import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import '../../theme/tw_merge.dart';

/// Toast color variants
enum DToastColor { primary, secondary, success, info, warning, error }

/// Toast variant styles
enum DToastVariant { solid, outline, soft, subtle }

/// DuxtUI Toast component - Notification message
class DToast extends StatelessComponent {
  final String? title;
  final String? description;
  final DToastColor color;
  final DToastVariant variant;
  final Component? icon;
  final Component? action;
  final bool closable;
  final VoidCallback? onClose;
  final String? id;
  final String? className;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DToast({
    super.key,
    this.title,
    this.description,
    this.color = DToastColor.primary,
    this.variant = DToastVariant.solid,
    this.icon,
    this.action,
    this.closable = true,
    this.onClose,
    this.id,
    this.className,
    this.attributes,
    this.events,
  });

  String get _colorName {
    switch (color) {
      case DToastColor.primary:
        return 'green';
      case DToastColor.secondary:
        return 'blue';
      case DToastColor.success:
        return 'green';
      case DToastColor.info:
        return 'blue';
      case DToastColor.warning:
        return 'yellow';
      case DToastColor.error:
        return 'red';
    }
  }

  String get _variantClasses {
    final c = _colorName;
    switch (variant) {
      case DToastVariant.solid:
        return 'bg-$c-500 text-white';
      case DToastVariant.outline:
        return 'bg-white dark:bg-zinc-900 ring-1 ring-inset ring-$c-500 text-$c-600 dark:text-$c-400';
      case DToastVariant.soft:
        return 'bg-$c-50 dark:bg-$c-950 text-$c-700 dark:text-$c-300';
      case DToastVariant.subtle:
        return 'bg-$c-50 dark:bg-$c-950 ring-1 ring-inset ring-$c-200 dark:ring-$c-800 text-$c-700 dark:text-$c-300';
    }
  }

  String get _closeButtonClasses {
    switch (variant) {
      case DToastVariant.solid:
        return 'text-white/80 hover:text-white';
      case DToastVariant.outline:
      case DToastVariant.soft:
      case DToastVariant.subtle:
        return 'text-gray-400 hover:text-gray-600 dark:hover:text-gray-300';
    }
  }

  String get _defaultIcon {
    switch (color) {
      case DToastColor.success:
        return '\u2714'; // Check mark
      case DToastColor.error:
        return '\u2716'; // Cross mark
      case DToastColor.warning:
        return '\u26A0'; // Warning
      case DToastColor.info:
        return '\u2139'; // Info
      default:
        return '\u{1F514}'; // Bell
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(cx([
        'flex items-start gap-3',
        'p-4',
        'rounded-lg',
        'shadow-lg',
        'min-w-[300px] max-w-md',
        _variantClasses,
      ]), className),
      children: [
        // Icon
        if (icon != null)
          Div(className: 'flex-shrink-0 text-lg', children: [icon!])
        else
          Div(className: 'flex-shrink-0 text-lg', children: [Text(_defaultIcon)]),
        // Content
        Div(
          className: 'flex-1 min-w-0',
          children: [
            if (title != null)
              P(
                className: 'text-sm font-semibold',
                children: [Text(title!)],
              ),
            if (description != null)
              P(
                className: cx([
                  'text-sm',
                  title != null ? 'mt-1 opacity-90' : null,
                ]),
                children: [Text(description!)],
              ),
          ],
        ),
        // Action
        if (action != null) Div(className: 'flex-shrink-0', children: [action!]),
        // Close button
        if (closable && onClose != null)
          Button(
            type: 'button',
            onClick: onClose,
            className: cx([
              'flex-shrink-0',
              'p-1 -m-1',
              'rounded',
              'transition-colors',
              _closeButtonClasses,
            ]),
            children: [
              Span(className: 'text-lg leading-none', children: [Text('\u00D7')])
            ], // Times symbol
          ),
      ],
    );
  }
}

/// Toast data model for programmatic toasts
class ToastData {
  final String id;
  final String? title;
  final String? description;
  final DToastColor color;
  final DToastVariant variant;
  final int duration;
  final bool closable;

  const ToastData({
    required this.id,
    this.title,
    this.description,
    this.color = DToastColor.primary,
    this.variant = DToastVariant.solid,
    this.duration = 5000,
    this.closable = true,
  });

  /// Create a success toast
  factory ToastData.success({
    required String id,
    String? title,
    String? description,
    int duration = 5000,
  }) {
    return ToastData(
      id: id,
      title: title ?? 'Success',
      description: description,
      color: DToastColor.success,
      duration: duration,
    );
  }

  /// Create an error toast
  factory ToastData.error({
    required String id,
    String? title,
    String? description,
    int duration = 5000,
  }) {
    return ToastData(
      id: id,
      title: title ?? 'Error',
      description: description,
      color: DToastColor.error,
      duration: duration,
    );
  }

  /// Create a warning toast
  factory ToastData.warning({
    required String id,
    String? title,
    String? description,
    int duration = 5000,
  }) {
    return ToastData(
      id: id,
      title: title ?? 'Warning',
      description: description,
      color: DToastColor.warning,
      duration: duration,
    );
  }

  /// Create an info toast
  factory ToastData.info({
    required String id,
    String? title,
    String? description,
    int duration = 5000,
  }) {
    return ToastData(
      id: id,
      title: title ?? 'Info',
      description: description,
      color: DToastColor.info,
      duration: duration,
    );
  }
}
