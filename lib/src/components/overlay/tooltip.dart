import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Tooltip placement options
enum DTooltipPlacement {
  top,
  topStart,
  topEnd,
  bottom,
  bottomStart,
  bottomEnd,
  left,
  right,
}

/// DuxtUI Tooltip component - hover hint
/// Uses CSS group-hover for reliable static site support
class DTooltip extends StatelessComponent {
  final Component child;
  final String text;
  final DTooltipPlacement placement;
  final int delayMs;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DTooltip({
    super.key,
    required this.child,
    required this.text,
    this.placement = DTooltipPlacement.top,
    this.delayMs = 0,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _positionClasses {
    switch (placement) {
      case DTooltipPlacement.top:
        return 'bottom-full left-1/2 -translate-x-1/2 mb-2';
      case DTooltipPlacement.topStart:
        return 'bottom-full left-0 mb-2';
      case DTooltipPlacement.topEnd:
        return 'bottom-full right-0 mb-2';
      case DTooltipPlacement.bottom:
        return 'top-full left-1/2 -translate-x-1/2 mt-2';
      case DTooltipPlacement.bottomStart:
        return 'top-full left-0 mt-2';
      case DTooltipPlacement.bottomEnd:
        return 'top-full right-0 mt-2';
      case DTooltipPlacement.left:
        return 'right-full top-1/2 -translate-y-1/2 mr-2';
      case DTooltipPlacement.right:
        return 'left-full top-1/2 -translate-y-1/2 ml-2';
    }
  }

  String get _arrowClasses {
    switch (placement) {
      case DTooltipPlacement.top:
      case DTooltipPlacement.topStart:
      case DTooltipPlacement.topEnd:
        return 'top-full left-1/2 -translate-x-1/2 border-t-zinc-900 dark:border-t-zinc-100 border-t-4 border-x-4 border-x-transparent border-b-0';
      case DTooltipPlacement.bottom:
      case DTooltipPlacement.bottomStart:
      case DTooltipPlacement.bottomEnd:
        return 'bottom-full left-1/2 -translate-x-1/2 border-b-zinc-900 dark:border-b-zinc-100 border-b-4 border-x-4 border-x-transparent border-t-0';
      case DTooltipPlacement.left:
        return 'left-full top-1/2 -translate-y-1/2 border-l-zinc-900 dark:border-l-zinc-100 border-l-4 border-y-4 border-y-transparent border-r-0';
      case DTooltipPlacement.right:
        return 'right-full top-1/2 -translate-y-1/2 border-r-zinc-900 dark:border-r-zinc-100 border-r-4 border-y-4 border-y-transparent border-l-0';
    }
  }

  @override
  Component build(BuildContext context) {
    final delayStyle = delayMs > 0 ? 'transition-delay: ${delayMs}ms;' : '';

    return Div(
      id: id,
      className: twMerge('relative inline-block group', className),
      attributes: attributes,
      events: events,
      children: [
        // Child element
        child,
        // Tooltip - uses CSS group-hover for reliable display
        Div(
          className:
              'absolute z-50 $_positionClasses px-2 py-1 text-xs font-medium bg-zinc-900 dark:bg-zinc-100 text-white dark:text-zinc-900 rounded whitespace-nowrap pointer-events-none opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-opacity duration-150',
          style: delayStyle.isNotEmpty ? 'transition-delay: ${delayMs}ms' : null,
          children: [
            Text(text),
            // Arrow
            Div(
              className: 'absolute w-0 h-0 $_arrowClasses',
              children: [],
            ),
          ],
        ),
      ],
    );
  }
}

/// Tooltip with custom content instead of just text
class DTooltipCustom extends StatelessComponent {
  final Component child;
  final Component content;
  final DTooltipPlacement placement;
  final int delayMs;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DTooltipCustom({
    super.key,
    required this.child,
    required this.content,
    this.placement = DTooltipPlacement.top,
    this.delayMs = 0,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _positionClasses {
    switch (placement) {
      case DTooltipPlacement.top:
        return 'bottom-full left-1/2 -translate-x-1/2 mb-2';
      case DTooltipPlacement.topStart:
        return 'bottom-full left-0 mb-2';
      case DTooltipPlacement.topEnd:
        return 'bottom-full right-0 mb-2';
      case DTooltipPlacement.bottom:
        return 'top-full left-1/2 -translate-x-1/2 mt-2';
      case DTooltipPlacement.bottomStart:
        return 'top-full left-0 mt-2';
      case DTooltipPlacement.bottomEnd:
        return 'top-full right-0 mt-2';
      case DTooltipPlacement.left:
        return 'right-full top-1/2 -translate-y-1/2 mr-2';
      case DTooltipPlacement.right:
        return 'left-full top-1/2 -translate-y-1/2 ml-2';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('relative inline-block group', className),
      attributes: attributes,
      events: events,
      children: [
        // Child element
        child,
        // Tooltip
        Div(
          className:
              'absolute z-50 $_positionClasses bg-zinc-900 dark:bg-zinc-100 text-white dark:text-zinc-900 rounded p-2 pointer-events-none opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-opacity duration-150',
          style: delayMs > 0 ? 'transition-delay: ${delayMs}ms' : null,
          children: [content],
        ),
      ],
    );
  }
}
