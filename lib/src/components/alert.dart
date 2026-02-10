import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// Alert variants
enum DAlertVariant { solid, outline, soft, subtle }

/// Alert colors
enum DAlertColor { primary, secondary, success, info, warning, error, neutral }

/// DuxtUI Alert component
class DAlert extends StatelessComponent {
  final String? title;
  final String? description;
  final DAlertVariant variant;
  final DAlertColor color;
  final Component? icon;
  final Component? avatar;
  final VoidCallback? onClose;
  final List<Component> actions;
  final List<Component> children;

  const DAlert({
    super.key,
    this.title,
    this.description,
    this.variant = DAlertVariant.soft,
    this.color = DAlertColor.primary,
    this.icon,
    this.avatar,
    this.onClose,
    this.actions = const [],
    this.children = const [],
  });

  String get _baseClasses => 'relative overflow-hidden rounded-lg p-4';

  String get _variantClasses {
    switch (variant) {
      case DAlertVariant.solid:
        return _solidClasses;
      case DAlertVariant.outline:
        return _outlineClasses;
      case DAlertVariant.soft:
        return _softClasses;
      case DAlertVariant.subtle:
        return _subtleClasses;
    }
  }

  String get _solidClasses {
    switch (color) {
      case DAlertColor.primary:
        return 'bg-cyan-500 text-white';
      case DAlertColor.secondary:
        return 'bg-blue-500 text-white';
      case DAlertColor.success:
        return 'bg-cyan-500 text-white';
      case DAlertColor.info:
        return 'bg-blue-500 text-white';
      case DAlertColor.warning:
        return 'bg-yellow-500 text-white';
      case DAlertColor.error:
        return 'bg-red-500 text-white';
      case DAlertColor.neutral:
        return 'bg-gray-900 text-white dark:bg-white dark:text-gray-900';
    }
  }

  String get _outlineClasses {
    switch (color) {
      case DAlertColor.primary:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-cyan-500 text-cyan-500';
      case DAlertColor.secondary:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-blue-500 text-blue-500';
      case DAlertColor.success:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-cyan-500 text-cyan-500';
      case DAlertColor.info:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-blue-500 text-blue-500';
      case DAlertColor.warning:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-yellow-500 text-yellow-600';
      case DAlertColor.error:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-red-500 text-red-500';
      case DAlertColor.neutral:
        return 'bg-white dark:bg-zinc-900 ring ring-inset ring-gray-300 dark:ring-gray-700 text-gray-700 dark:text-gray-200';
    }
  }

  String get _softClasses {
    switch (color) {
      case DAlertColor.primary:
        return 'bg-cyan-50 text-cyan-700 dark:bg-cyan-950 dark:text-cyan-300';
      case DAlertColor.secondary:
        return 'bg-blue-50 text-blue-700 dark:bg-blue-950 dark:text-blue-300';
      case DAlertColor.success:
        return 'bg-cyan-50 text-cyan-700 dark:bg-cyan-950 dark:text-cyan-300';
      case DAlertColor.info:
        return 'bg-blue-50 text-blue-700 dark:bg-blue-950 dark:text-blue-300';
      case DAlertColor.warning:
        return 'bg-yellow-50 text-yellow-700 dark:bg-yellow-950 dark:text-yellow-300';
      case DAlertColor.error:
        return 'bg-red-50 text-red-700 dark:bg-red-950 dark:text-red-300';
      case DAlertColor.neutral:
        return 'bg-gray-100 text-gray-700 dark:bg-zinc-800 dark:text-gray-200';
    }
  }

  String get _subtleClasses {
    switch (color) {
      case DAlertColor.primary:
        return 'bg-cyan-50 ring ring-inset ring-cyan-200 text-cyan-700 dark:bg-cyan-950 dark:ring-cyan-800 dark:text-cyan-300';
      case DAlertColor.secondary:
        return 'bg-blue-50 ring ring-inset ring-blue-200 text-blue-700 dark:bg-blue-950 dark:ring-blue-800 dark:text-blue-300';
      case DAlertColor.success:
        return 'bg-cyan-50 ring ring-inset ring-cyan-200 text-cyan-700 dark:bg-cyan-950 dark:ring-cyan-800 dark:text-cyan-300';
      case DAlertColor.info:
        return 'bg-blue-50 ring ring-inset ring-blue-200 text-blue-700 dark:bg-blue-950 dark:ring-blue-800 dark:text-blue-300';
      case DAlertColor.warning:
        return 'bg-yellow-50 ring ring-inset ring-yellow-200 text-yellow-700 dark:bg-yellow-950 dark:ring-yellow-800 dark:text-yellow-300';
      case DAlertColor.error:
        return 'bg-red-50 ring ring-inset ring-red-200 text-red-700 dark:bg-red-950 dark:ring-red-800 dark:text-red-300';
      case DAlertColor.neutral:
        return 'bg-gray-100 ring ring-inset ring-gray-300 text-gray-700 dark:bg-zinc-800 dark:ring-gray-700 dark:text-gray-200';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: '$_baseClasses $_variantClasses',
      children: [
        Div(className: 'flex gap-3', children: [
          if (icon != null) Div(className: 'shrink-0 size-5', children: [icon!]),
          if (avatar != null) Div(className: 'shrink-0', children: [avatar!]),
          Div(className: 'flex-1 min-w-0', children: [
            if (title != null)
              H3(className: 'text-sm font-medium', children: [Text(title!)]),
            if (description != null)
              P(
                  className: 'text-sm mt-1 opacity-90',
                  children: [Text(description!)]),
            ...children,
            if (actions.isNotEmpty)
              Div(className: 'flex items-center gap-2 mt-3', children: actions),
          ]),
          if (onClose != null)
            Button(
              type: 'button',
              onClick: onClose,
              className:
                  'shrink-0 -my-1 -mx-1 p-1 rounded-md hover:bg-black/5 dark:hover:bg-white/5 transition-colors',
              children: [
                Span(
                    className: 'size-5 flex items-center justify-center',
                    children: [Text('\u00d7')]),
              ],
            ),
        ]),
      ],
    );
  }
}
