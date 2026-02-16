import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../theme/tw_merge.dart';

/// Button variants
enum DButtonVariant { solid, outline, soft, subtle, ghost, link }

/// Button sizes
enum DButtonSize { xs, sm, md, lg, xl }

/// Button colors
enum DButtonColor { primary, secondary, success, info, warning, error, neutral }

/// DuxtUI Button component
class DButton extends StatelessComponent {
  final String? label;
  final Component? leadingIcon;
  final Component? trailingIcon;
  final DButtonVariant variant;
  final DButtonSize size;
  final DButtonColor color;
  final bool disabled;
  final bool loading;
  final bool block;
  final bool square;
  final VoidCallback? onClick;
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DButton({
    super.key,
    this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = DButtonVariant.solid,
    this.size = DButtonSize.md,
    this.color = DButtonColor.primary,
    this.disabled = false,
    this.loading = false,
    this.block = false,
    this.square = false,
    this.onClick,
    this.children = const [],
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  // Backward compatibility
  Component? get icon => leadingIcon;

  String get _baseClasses =>
      'rounded-md font-medium inline-flex items-center justify-center disabled:cursor-not-allowed aria-disabled:cursor-not-allowed disabled:opacity-75 aria-disabled:opacity-75 transition-colors focus:outline-none focus-visible:outline-2 focus-visible:outline-offset-2';

  String get _sizeClasses {
    if (square) {
      switch (size) {
        case DButtonSize.xs:
          return 'p-1 text-xs';
        case DButtonSize.sm:
          return 'p-1.5 text-xs';
        case DButtonSize.md:
          return 'p-1.5 text-sm';
        case DButtonSize.lg:
          return 'p-2 text-sm';
        case DButtonSize.xl:
          return 'p-2 text-base';
      }
    }
    switch (size) {
      case DButtonSize.xs:
        return 'px-2 py-1 text-xs gap-1';
      case DButtonSize.sm:
        return 'px-2.5 py-1.5 text-xs gap-1.5';
      case DButtonSize.md:
        return 'px-2.5 py-1.5 text-sm gap-1.5';
      case DButtonSize.lg:
        return 'px-3 py-2 text-sm gap-2';
      case DButtonSize.xl:
        return 'px-3 py-2 text-base gap-2';
    }
  }

  String get _iconSizeClasses {
    switch (size) {
      case DButtonSize.xs:
      case DButtonSize.sm:
        return 'size-4';
      case DButtonSize.md:
      case DButtonSize.lg:
        return 'size-5';
      case DButtonSize.xl:
        return 'size-6';
    }
  }

  String get _colorClasses {
    switch (variant) {
      case DButtonVariant.solid:
        return _solidClasses;
      case DButtonVariant.outline:
        return _outlineClasses;
      case DButtonVariant.soft:
        return _softClasses;
      case DButtonVariant.subtle:
        return _subtleClasses;
      case DButtonVariant.ghost:
        return _ghostClasses;
      case DButtonVariant.link:
        return _linkClasses;
    }
  }

  String get _solidClasses {
    switch (color) {
      case DButtonColor.primary:
        return 'bg-cyan-500 text-white hover:bg-cyan-600 focus-visible:outline-cyan-500 dark:bg-cyan-400 dark:text-gray-900 dark:hover:bg-cyan-500';
      case DButtonColor.secondary:
        return 'bg-blue-500 text-white hover:bg-blue-600 focus-visible:outline-blue-500 dark:bg-blue-400 dark:text-gray-900 dark:hover:bg-blue-500';
      case DButtonColor.success:
        return 'bg-cyan-500 text-white hover:bg-cyan-600 focus-visible:outline-cyan-500';
      case DButtonColor.info:
        return 'bg-blue-500 text-white hover:bg-blue-600 focus-visible:outline-blue-500';
      case DButtonColor.warning:
        return 'bg-yellow-500 text-white hover:bg-yellow-600 focus-visible:outline-yellow-500';
      case DButtonColor.error:
        return 'bg-red-500 text-white hover:bg-red-600 focus-visible:outline-red-500';
      case DButtonColor.neutral:
        return 'bg-gray-900 text-white hover:bg-gray-800 focus-visible:outline-gray-900 dark:bg-white dark:text-gray-900 dark:hover:bg-gray-100';
    }
  }

  String get _outlineClasses {
    switch (color) {
      case DButtonColor.primary:
        return 'ring ring-inset ring-cyan-500/50 text-cyan-500 hover:bg-cyan-500/10 focus-visible:outline-cyan-500 dark:ring-cyan-400/50 dark:text-cyan-400';
      case DButtonColor.secondary:
        return 'ring ring-inset ring-blue-500/50 text-blue-500 hover:bg-blue-500/10 focus-visible:outline-blue-500';
      case DButtonColor.success:
        return 'ring ring-inset ring-cyan-500/50 text-cyan-500 hover:bg-cyan-500/10 focus-visible:outline-cyan-500';
      case DButtonColor.info:
        return 'ring ring-inset ring-blue-500/50 text-blue-500 hover:bg-blue-500/10 focus-visible:outline-blue-500';
      case DButtonColor.warning:
        return 'ring ring-inset ring-yellow-500/50 text-yellow-500 hover:bg-yellow-500/10 focus-visible:outline-yellow-500';
      case DButtonColor.error:
        return 'ring ring-inset ring-red-500/50 text-red-500 hover:bg-red-500/10 focus-visible:outline-red-500';
      case DButtonColor.neutral:
        return 'ring ring-inset ring-gray-300 text-gray-700 hover:bg-gray-100 focus-visible:outline-gray-500 dark:ring-gray-700 dark:text-gray-200 dark:hover:bg-gray-800';
    }
  }

  String get _softClasses {
    switch (color) {
      case DButtonColor.primary:
        return 'bg-cyan-500/10 text-cyan-500 hover:bg-cyan-500/20 focus-visible:outline-cyan-500 dark:bg-cyan-400/10 dark:text-cyan-400';
      case DButtonColor.secondary:
        return 'bg-blue-500/10 text-blue-500 hover:bg-blue-500/20 focus-visible:outline-blue-500';
      case DButtonColor.success:
        return 'bg-cyan-500/10 text-cyan-500 hover:bg-cyan-500/20 focus-visible:outline-cyan-500';
      case DButtonColor.info:
        return 'bg-blue-500/10 text-blue-500 hover:bg-blue-500/20 focus-visible:outline-blue-500';
      case DButtonColor.warning:
        return 'bg-yellow-500/10 text-yellow-500 hover:bg-yellow-500/20 focus-visible:outline-yellow-500';
      case DButtonColor.error:
        return 'bg-red-500/10 text-red-500 hover:bg-red-500/20 focus-visible:outline-red-500';
      case DButtonColor.neutral:
        return 'bg-gray-100 text-gray-700 hover:bg-gray-200 focus-visible:outline-gray-500 dark:bg-zinc-800 dark:text-gray-200 dark:hover:bg-gray-700';
    }
  }

  String get _subtleClasses {
    switch (color) {
      case DButtonColor.primary:
        return 'bg-cyan-500/10 text-cyan-500 ring ring-inset ring-cyan-500/25 hover:bg-cyan-500/20 focus-visible:outline-cyan-500';
      case DButtonColor.secondary:
        return 'bg-blue-500/10 text-blue-500 ring ring-inset ring-blue-500/25 hover:bg-blue-500/20 focus-visible:outline-blue-500';
      case DButtonColor.success:
        return 'bg-cyan-500/10 text-cyan-500 ring ring-inset ring-cyan-500/25 hover:bg-cyan-500/20 focus-visible:outline-cyan-500';
      case DButtonColor.info:
        return 'bg-blue-500/10 text-blue-500 ring ring-inset ring-blue-500/25 hover:bg-blue-500/20 focus-visible:outline-blue-500';
      case DButtonColor.warning:
        return 'bg-yellow-500/10 text-yellow-500 ring ring-inset ring-yellow-500/25 hover:bg-yellow-500/20 focus-visible:outline-yellow-500';
      case DButtonColor.error:
        return 'bg-red-500/10 text-red-500 ring ring-inset ring-red-500/25 hover:bg-red-500/20 focus-visible:outline-red-500';
      case DButtonColor.neutral:
        return 'bg-gray-100 text-gray-700 ring ring-inset ring-gray-300 hover:bg-gray-200 focus-visible:outline-gray-500 dark:bg-zinc-800 dark:text-gray-200 dark:ring-gray-700';
    }
  }

  String get _ghostClasses {
    switch (color) {
      case DButtonColor.primary:
        return 'text-cyan-500 hover:bg-cyan-500/10 focus-visible:outline-cyan-500';
      case DButtonColor.secondary:
        return 'text-blue-500 hover:bg-blue-500/10 focus-visible:outline-blue-500';
      case DButtonColor.success:
        return 'text-cyan-500 hover:bg-cyan-500/10 focus-visible:outline-cyan-500';
      case DButtonColor.info:
        return 'text-blue-500 hover:bg-blue-500/10 focus-visible:outline-blue-500';
      case DButtonColor.warning:
        return 'text-yellow-500 hover:bg-yellow-500/10 focus-visible:outline-yellow-500';
      case DButtonColor.error:
        return 'text-red-500 hover:bg-red-500/10 focus-visible:outline-red-500';
      case DButtonColor.neutral:
        return 'text-gray-700 hover:bg-gray-100 focus-visible:outline-gray-500 dark:text-gray-200 dark:hover:bg-gray-800';
    }
  }

  String get _linkClasses {
    switch (color) {
      case DButtonColor.primary:
        return 'text-cyan-500 hover:underline focus-visible:outline-cyan-500';
      case DButtonColor.secondary:
        return 'text-blue-500 hover:underline focus-visible:outline-blue-500';
      case DButtonColor.success:
        return 'text-cyan-500 hover:underline focus-visible:outline-cyan-500';
      case DButtonColor.info:
        return 'text-blue-500 hover:underline focus-visible:outline-blue-500';
      case DButtonColor.warning:
        return 'text-yellow-500 hover:underline focus-visible:outline-yellow-500';
      case DButtonColor.error:
        return 'text-red-500 hover:underline focus-visible:outline-red-500';
      case DButtonColor.neutral:
        return 'text-gray-700 hover:underline focus-visible:outline-gray-500 dark:text-gray-200';
    }
  }

  @override
  Component build(BuildContext context) {
    final blockClasses = block ? 'w-full justify-center' : '';

    return Button(
      type: 'button',
      disabled: disabled || loading,
      onClick: disabled || loading ? null : onClick,
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(
          '$_baseClasses $_sizeClasses $_colorClasses $blockClasses', className),
      children: [
        if (loading)
          Span(
              className:
                  'animate-spin $_iconSizeClasses border-2 border-current border-t-transparent rounded-full',
              children: [])
        else if (leadingIcon != null)
          Span(className: 'shrink-0 $_iconSizeClasses', children: [leadingIcon!]),
        if (label != null) Span(className: 'truncate', children: [Text(label!)]),
        ...children,
        if (trailingIcon != null)
          Span(className: 'shrink-0 $_iconSizeClasses', children: [trailingIcon!]),
      ],
    );
  }
}

/// Button group for grouping buttons together
class DButtonGroup extends StatelessComponent {
  final List<Component> children;
  final DButtonSize size;
  final String orientation; // 'horizontal' | 'vertical'
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DButtonGroup({
    super.key,
    required this.children,
    this.size = DButtonSize.md,
    this.orientation = 'horizontal',
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final isVertical = orientation == 'vertical';
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(
          'inline-flex ${isVertical ? "flex-col" : ""} -space-${isVertical ? "y" : "x"}-px',
          className),
      children: children,
    );
  }
}
