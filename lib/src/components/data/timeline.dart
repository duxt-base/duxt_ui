import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show events;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';

/// Timeline item status
enum DTimelineStatus { pending, current, completed }

/// Timeline orientation
enum DTimelineOrientation { vertical, horizontal }

/// Timeline item data
class DTimelineItem {
  /// Unique identifier
  final String? id;

  /// Title text
  final String title;

  /// Description text (optional)
  final String? description;

  /// Icon class (optional)
  final String? icon;

  /// Timestamp or date (optional)
  final String? time;

  /// Item status
  final DTimelineStatus status;

  /// Custom color (overrides status color)
  final DColor? color;

  /// Custom content widget (optional)
  final Component? content;

  const DTimelineItem({
    this.id,
    required this.title,
    this.description,
    this.icon,
    this.time,
    this.status = DTimelineStatus.pending,
    this.color,
    this.content,
  });
}

/// DuxtUI Timeline component
class DTimeline extends StatelessComponent {
  /// List of timeline items
  final List<DTimelineItem> items;

  /// Timeline orientation
  final DTimelineOrientation orientation;

  /// Default color for items
  final DColor color;

  /// Size of the timeline dots/icons
  final DSize size;

  /// Whether to show connecting lines
  final bool showConnectors;

  /// Whether items are clickable
  final void Function(DTimelineItem item, int index)? onItemClick;

  const DTimeline({
    super.key,
    required this.items,
    this.orientation = DTimelineOrientation.vertical,
    this.color = DColor.primary,
    this.size = DSize.md,
    this.showConnectors = true,
    this.onItemClick,
  });

  String get _dotSize {
    switch (size) {
      case DSize.xs:
        return 'size-2';
      case DSize.sm:
        return 'size-2.5';
      case DSize.md:
        return 'size-3';
      case DSize.lg:
        return 'size-4';
      case DSize.xl:
        return 'size-5';
    }
  }

  String get _iconContainerSize {
    switch (size) {
      case DSize.xs:
        return 'size-5';
      case DSize.sm:
        return 'size-6';
      case DSize.md:
        return 'size-8';
      case DSize.lg:
        return 'size-10';
      case DSize.xl:
        return 'size-12';
    }
  }

  String get _iconSize {
    switch (size) {
      case DSize.xs:
        return 'size-2.5';
      case DSize.sm:
        return 'size-3';
      case DSize.md:
        return 'size-4';
      case DSize.lg:
        return 'size-5';
      case DSize.xl:
        return 'size-6';
    }
  }

  String _getDotColor(DTimelineItem item) {
    final itemColor = item.color ?? color;
    final baseColor = defaultColorMapping[itemColor] ?? 'green';

    switch (item.status) {
      case DTimelineStatus.completed:
        return 'bg-$baseColor-500';
      case DTimelineStatus.current:
        return 'bg-$baseColor-500 ring-4 ring-$baseColor-100 dark:ring-$baseColor-900';
      case DTimelineStatus.pending:
        return 'bg-gray-300 dark:bg-zinc-600';
    }
  }

  String _getIconContainerColor(DTimelineItem item) {
    final itemColor = item.color ?? color;
    final baseColor = defaultColorMapping[itemColor] ?? 'green';

    switch (item.status) {
      case DTimelineStatus.completed:
        return 'bg-$baseColor-500 text-white';
      case DTimelineStatus.current:
        return 'bg-$baseColor-100 text-$baseColor-600 dark:bg-$baseColor-900 dark:text-$baseColor-400 ring-4 ring-$baseColor-50 dark:ring-$baseColor-950';
      case DTimelineStatus.pending:
        return 'bg-gray-100 text-gray-500 dark:bg-zinc-800 dark:text-gray-400';
    }
  }

  String get _connectorColor => 'bg-gray-200 dark:bg-zinc-700';

  @override
  Component build(BuildContext context) {
    if (orientation == DTimelineOrientation.horizontal) {
      return _buildHorizontal(context);
    }
    return _buildVertical(context);
  }

  Component _buildVertical(BuildContext context) {
    return Div(
      className: 'relative',
      children: [
        for (var i = 0; i < items.length; i++) _buildVerticalItem(items[i], i),
      ],
    );
  }

  Component _buildVerticalItem(DTimelineItem item, int index) {
    final isLast = index == items.length - 1;
    final hasIcon = item.icon != null;

    final itemContent = Div(
      className: cx([
        'relative flex gap-4 pb-8',
        if (isLast) 'pb-0',
      ]),
      children: [
        // Left side: dot/icon and connector
        Div(
          className: 'flex flex-col items-center',
          children: [
            // Dot or icon
            if (hasIcon)
              Div(
                className: cx([
                  'rounded-full flex items-center justify-center shrink-0',
                  _iconContainerSize,
                  _getIconContainerColor(item),
                ]),
                children: [I(className: '${item.icon} $_iconSize', children: [])],
              )
            else
              Div(
                className: cx([
                  'rounded-full shrink-0 mt-1',
                  _dotSize,
                  _getDotColor(item),
                ]),
                children: [],
              ),
            // Connector line
            if (showConnectors && !isLast)
              Div(
                className: cx([
                  'w-0.5 flex-1 min-h-4 mt-2',
                  _connectorColor,
                ]),
                children: [],
              ),
          ],
        ),
        // Right side: content
        Div(
          className: 'flex-1 min-w-0 pt-0.5',
          children: [
            // Header with title and time
            Div(
              className: 'flex items-start justify-between gap-2',
              children: [
                Span(
                  className: cx([
                    'font-medium',
                    item.status == DTimelineStatus.pending
                        ? DTextColors.muted
                        : DTextColors.defaultText,
                  ]),
                  children: [Text(item.title)],
                ),
                if (item.time != null)
                  Span(
                    className: 'text-sm ${DTextColors.muted} shrink-0',
                    children: [Text(item.time!)],
                  ),
              ],
            ),
            // Description
            if (item.description != null)
              P(
                className: 'mt-1 text-sm ${DTextColors.muted}',
                children: [Text(item.description!)],
              ),
            // Custom content
            if (item.content != null) Div(className: 'mt-2', children: [item.content!]),
          ],
        ),
      ],
    );

    if (onItemClick != null) {
      return Button(
        type: 'button',
        className:
            'w-full text-left hover:bg-gray-50 dark:hover:bg-gray-800/50 -mx-2 px-2 rounded-lg transition-colors',
        events: events(onClick: () => onItemClick!(item, index)),
        children: [itemContent],
      );
    }

    return itemContent;
  }

  Component _buildHorizontal(BuildContext context) {
    return Div(
      className: 'relative',
      children: [
        // Items
        Div(
          className: 'flex',
          children: [
            for (var i = 0; i < items.length; i++)
              _buildHorizontalItem(items[i], i),
          ],
        ),
      ],
    );
  }

  Component _buildHorizontalItem(DTimelineItem item, int index) {
    final isLast = index == items.length - 1;
    final hasIcon = item.icon != null;

    return Div(
      className: cx([
        'flex flex-col items-center flex-1',
        if (!isLast) 'relative',
      ]),
      children: [
        // Dot or icon
        if (hasIcon)
          Div(
            className: cx([
              'rounded-full flex items-center justify-center shrink-0 relative z-10',
              _iconContainerSize,
              _getIconContainerColor(item),
            ]),
            children: [I(className: '${item.icon} $_iconSize', children: [])],
          )
        else
          Div(
            className: cx([
              'rounded-full shrink-0 relative z-10',
              _dotSize,
              _getDotColor(item),
            ]),
            children: [],
          ),
        // Connector line (positioned between dots)
        if (showConnectors && !isLast)
          Div(
            className: cx([
              'absolute top-3 left-1/2 w-full h-0.5',
              _connectorColor,
            ]),
            children: [],
          ),
        // Content below
        Div(
          className: 'mt-3 text-center',
          children: [
            Span(
              className: cx([
                'font-medium text-sm',
                item.status == DTimelineStatus.pending
                    ? DTextColors.muted
                    : DTextColors.defaultText,
              ]),
              children: [Text(item.title)],
            ),
            if (item.time != null)
              P(
                className: 'mt-0.5 text-xs ${DTextColors.muted}',
                children: [Text(item.time!)],
              ),
          ],
        ),
      ],
    );
  }
}

/// Simple timeline with just text items
class DTimelineSimple extends StatelessComponent {
  /// List of text items
  final List<String> items;

  /// Index of the current/active item
  final int? activeIndex;

  /// Timeline color
  final DColor color;

  const DTimelineSimple({
    super.key,
    required this.items,
    this.activeIndex,
    this.color = DColor.primary,
  });

  @override
  Component build(BuildContext context) {
    final baseColor = defaultColorMapping[color] ?? 'green';

    return Ul(
      className: 'relative',
      children: [
        for (var i = 0; i < items.length; i++)
          Li(
            className: cx([
              'relative flex gap-3 pb-6',
              if (i == items.length - 1) 'pb-0',
            ]),
            children: [
              // Dot
              Div(
                className: cx([
                  'size-2.5 rounded-full mt-1.5 shrink-0',
                  if (activeIndex != null && i <= activeIndex!)
                    'bg-$baseColor-500'
                  else
                    'bg-gray-300 dark:bg-zinc-600',
                ]),
                children: [],
              ),
              // Line
              if (i < items.length - 1)
                Div(
                  className: cx([
                    'absolute left-1 top-4 w-0.5 h-full -translate-x-1/2',
                    if (activeIndex != null && i < activeIndex!)
                      'bg-$baseColor-500'
                    else
                      'bg-gray-200 dark:bg-zinc-700',
                  ]),
                  children: [],
                ),
              // Text
              Span(
                className: cx([
                  'text-sm',
                  if (activeIndex != null && i == activeIndex!)
                    'font-medium ${DTextColors.defaultText}'
                  else if (activeIndex != null && i < activeIndex!)
                    DTextColors.defaultText
                  else
                    DTextColors.muted,
                ]),
                children: [Text(items[i])],
              ),
            ],
          ),
      ],
    );
  }
}
