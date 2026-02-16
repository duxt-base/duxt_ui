import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import '../../theme/tw_merge.dart';

/// Skeleton variants matching common UI patterns
enum DSkeletonVariant { text, circular, rectangular }

/// DuxtUI Skeleton component - Loading placeholder
class DSkeleton extends StatelessComponent {
  final DSkeletonVariant variant;
  final String? width;
  final String? height;
  final bool animate;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSkeleton({
    super.key,
    this.variant = DSkeletonVariant.text,
    this.width,
    this.height,
    this.animate = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  /// Creates a text line skeleton
  const DSkeleton.text({
    super.key,
    this.width,
    this.animate = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  })  : variant = DSkeletonVariant.text,
        height = null;

  /// Creates a circular skeleton (for avatars)
  const DSkeleton.circular({
    super.key,
    String? size,
    this.animate = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  })  : variant = DSkeletonVariant.circular,
        width = size ?? '2.5rem',
        height = size ?? '2.5rem';

  /// Creates a rectangular skeleton (for images/cards)
  const DSkeleton.rectangular({
    super.key,
    this.width,
    this.height,
    this.animate = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  }) : variant = DSkeletonVariant.rectangular;

  String get _baseClasses {
    return cx([
      'bg-gray-200 dark:bg-zinc-700',
      animate ? 'animate-pulse' : null,
    ]);
  }

  String get _shapeClasses {
    switch (variant) {
      case DSkeletonVariant.text:
        return 'h-4 rounded';
      case DSkeletonVariant.circular:
        return 'rounded-full';
      case DSkeletonVariant.rectangular:
        return 'rounded-lg';
    }
  }

  @override
  Component build(BuildContext context) {
    // Build inline style map
    final styleMap = <String, String>{};
    if (width != null) styleMap['width'] = width!;
    if (height != null) styleMap['height'] = height!;

    final styleStr = styleMap.entries.map((e) => '${e.key}: ${e.value}').join('; ');

    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(cx([_baseClasses, _shapeClasses]), className),
      style: styleStr.isNotEmpty ? styleStr : null,
      children: [],
    );
  }
}

/// Skeleton group for multiple lines
class DSkeletonGroup extends StatelessComponent {
  final int lines;
  final String? spacing;
  final bool animate;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSkeletonGroup({
    super.key,
    this.lines = 3,
    this.spacing,
    this.animate = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('space-y-${spacing ?? "3"}', className),
      children: [
        for (int i = 0; i < lines; i++)
          DSkeleton.text(
            animate: animate,
            // Make last line shorter for natural look
            width: i == lines - 1 ? '75%' : null,
          ),
      ],
    );
  }
}

/// Skeleton card for card placeholders
class DSkeletonCard extends StatelessComponent {
  final bool showImage;
  final bool showAvatar;
  final int textLines;
  final bool animate;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSkeletonCard({
    super.key,
    this.showImage = true,
    this.showAvatar = false,
    this.textLines = 3,
    this.animate = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('bg-white dark:bg-zinc-900 rounded-lg border border-gray-200 dark:border-gray-800 overflow-hidden', className),
      children: [
        // Image placeholder
        if (showImage)
          DSkeleton.rectangular(
            width: '100%',
            height: '12rem',
            animate: animate,
            className: 'rounded-none',
          ),
        // Content
        Div(
          className: 'p-4 space-y-4',
          children: [
            // Avatar and title row
            if (showAvatar)
              Div(
                className: 'flex items-center gap-3',
                children: [
                  DSkeleton.circular(animate: animate),
                  Div(
                    className: 'flex-1 space-y-2',
                    children: [
                      DSkeleton.text(width: '50%', animate: animate),
                      DSkeleton.text(width: '30%', animate: animate),
                    ],
                  ),
                ],
              ),
            // Text lines
            DSkeletonGroup(lines: textLines, animate: animate),
          ],
        ),
      ],
    );
  }
}
