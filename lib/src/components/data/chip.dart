import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' as dom;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';

/// Chip variants
enum DChipVariant { solid, soft, outline, subtle }

/// DuxtUI Chip component - Small indicator badge
/// Similar to Badge but designed for inline indicators with optional actions
class DChip extends StatelessComponent {
  /// The label text to display
  final String label;

  /// Chip variant
  final DChipVariant variant;

  /// Chip color
  final DColor color;

  /// Chip size
  final DSize size;

  /// Leading icon (optional)
  final String? leadingIcon;

  /// Trailing icon (optional, typically for close/remove action)
  final String? trailingIcon;

  /// Callback when chip is clicked
  final void Function()? onClick;

  /// Callback when trailing icon is clicked (e.g., for remove action)
  final void Function()? onTrailingClick;

  /// Whether the chip is disabled
  final bool disabled;

  /// Whether to show a dot indicator
  final bool showDot;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DChip({
    super.key,
    required this.label,
    this.variant = DChipVariant.soft,
    this.color = DColor.primary,
    this.size = DSize.sm,
    this.leadingIcon,
    this.trailingIcon,
    this.onClick,
    this.onTrailingClick,
    this.disabled = false,
    this.showDot = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    // Using badge size classes as reference
    return badgeSizeClasses[size] ?? badgeSizeClasses[DSize.sm]!;
  }

  String get _colorClasses {
    final baseColor = defaultColorMapping[color] ?? 'green';

    switch (variant) {
      case DChipVariant.solid:
        return 'bg-$baseColor-500 text-white';
      case DChipVariant.soft:
        return 'bg-$baseColor-50 text-$baseColor-700 dark:bg-$baseColor-950 dark:text-$baseColor-300';
      case DChipVariant.outline:
        return 'bg-transparent text-$baseColor-500 ring-1 ring-inset ring-$baseColor-500 dark:text-$baseColor-400 dark:ring-$baseColor-400';
      case DChipVariant.subtle:
        return 'bg-$baseColor-50 text-$baseColor-500 dark:bg-$baseColor-950 dark:text-$baseColor-400';
    }
  }

  String get _dotColor {
    final baseColor = defaultColorMapping[color] ?? 'green';
    switch (variant) {
      case DChipVariant.solid:
        return 'bg-white';
      case DChipVariant.soft:
      case DChipVariant.outline:
      case DChipVariant.subtle:
        return 'bg-$baseColor-500 dark:bg-$baseColor-400';
    }
  }

  String get _iconSize {
    switch (size) {
      case DSize.xs:
        return 'size-2.5';
      case DSize.sm:
        return 'size-3';
      case DSize.md:
        return 'size-3.5';
      case DSize.lg:
        return 'size-4';
      case DSize.xl:
        return 'size-5';
    }
  }

  String get _dotSize {
    switch (size) {
      case DSize.xs:
        return 'size-1';
      case DSize.sm:
        return 'size-1.5';
      case DSize.md:
        return 'size-1.5';
      case DSize.lg:
        return 'size-2';
      case DSize.xl:
        return 'size-2';
    }
  }

  @override
  Component build(BuildContext context) {
    final baseClasses = cx([
      'inline-flex items-center font-medium',
      _sizeClasses,
      _colorClasses,
      if (onClick != null && !disabled)
        'cursor-pointer hover:opacity-80 transition-opacity',
      if (disabled) 'opacity-50 cursor-not-allowed',
    ]);

    final children = <Component>[
      // Dot indicator
      if (showDot) Span(className: '$_dotSize rounded-full $_dotColor', children: []),

      // Leading icon
      if (leadingIcon != null)
        I(className: '$leadingIcon $_iconSize shrink-0', children: []),

      // Label text
      Span(children: [Text(label)]),

      // Trailing icon (with optional click handler)
      if (trailingIcon != null)
        Button(
          type: 'button',
          className: cx([
            '$trailingIcon $_iconSize shrink-0',
            if (onTrailingClick != null && !disabled)
              'cursor-pointer hover:opacity-70 transition-opacity',
          ]),
          events: onTrailingClick != null && !disabled
              ? {'click': (event) {
                  event.stopPropagation();
                  onTrailingClick!();
                }}
              : null,
          children: [],
        ),
    ];

    if (onClick != null && !disabled) {
      return Button(
        type: 'button',
        id: id,
        className: twMerge(baseClasses, className),
        attributes: attributes,
        events: this.events ?? dom.events(onClick: () => onClick!()),
        children: children,
      );
    }

    return Span(id: id, className: twMerge(baseClasses, className), attributes: attributes, events: this.events, children: children);
  }
}

/// Chip Group - Display multiple chips in a row
class DChipGroup extends StatelessComponent {
  /// List of chips to display
  final List<DChip> chips;

  /// Gap between chips
  final String gap;

  /// Whether chips should wrap
  final bool wrap;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DChipGroup({
    super.key,
    required this.chips,
    this.gap = 'gap-1.5',
    this.wrap = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge(cx([
        'inline-flex items-center',
        gap,
        if (wrap) 'flex-wrap',
      ]), className),
      attributes: attributes,
      events: events,
      children: chips,
    );
  }
}
