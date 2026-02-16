import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../theme/tw_merge.dart';

/// Avatar sizes
enum DAvatarSize { xxxs, xxs, xs, sm, md, lg, xl, xxl, xxxl }

/// Avatar chip position
enum DAvatarChipPosition { topRight, bottomRight, topLeft, bottomLeft }

/// DuxtUI Avatar component
class DAvatar extends StatelessComponent {
  final String? src;
  final String? alt;
  final String? text;
  final Component? icon;
  final DAvatarSize size;
  final bool? chipColor;
  final String? chipText;
  final DAvatarChipPosition chipPosition;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DAvatar({
    super.key,
    this.src,
    this.alt,
    this.text,
    this.icon,
    this.size = DAvatarSize.md,
    this.chipColor,
    this.chipText,
    this.chipPosition = DAvatarChipPosition.topRight,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DAvatarSize.xxxs:
        return 'size-4 text-[8px]';
      case DAvatarSize.xxs:
        return 'size-5 text-[10px]';
      case DAvatarSize.xs:
        return 'size-6 text-xs';
      case DAvatarSize.sm:
        return 'size-8 text-sm';
      case DAvatarSize.md:
        return 'size-10 text-base';
      case DAvatarSize.lg:
        return 'size-12 text-lg';
      case DAvatarSize.xl:
        return 'size-14 text-xl';
      case DAvatarSize.xxl:
        return 'size-16 text-2xl';
      case DAvatarSize.xxxl:
        return 'size-20 text-3xl';
    }
  }

  String get _iconSizeClasses {
    switch (size) {
      case DAvatarSize.xxxs:
      case DAvatarSize.xxs:
        return 'size-2';
      case DAvatarSize.xs:
        return 'size-3';
      case DAvatarSize.sm:
        return 'size-4';
      case DAvatarSize.md:
        return 'size-5';
      case DAvatarSize.lg:
        return 'size-6';
      case DAvatarSize.xl:
      case DAvatarSize.xxl:
      case DAvatarSize.xxxl:
        return 'size-8';
    }
  }

  String get _chipPositionClasses {
    switch (chipPosition) {
      case DAvatarChipPosition.topRight:
        return 'top-0 right-0';
      case DAvatarChipPosition.bottomRight:
        return 'bottom-0 right-0';
      case DAvatarChipPosition.topLeft:
        return 'top-0 left-0';
      case DAvatarChipPosition.bottomLeft:
        return 'bottom-0 left-0';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('relative inline-flex', className),
      children: [
        // Avatar container
        Div(
          className:
              '$_sizeClasses rounded-full overflow-hidden bg-gray-100 dark:bg-zinc-800 flex items-center justify-center font-medium text-gray-600 dark:text-gray-300',
          children: [
            if (src != null)
              Img(
                src: src!,
                alt: alt ?? '',
                className: 'size-full object-cover',
              )
            else if (icon != null)
              Span(className: _iconSizeClasses, children: [icon!])
            else if (text != null)
              Text(text!
                  .substring(0, text!.length > 2 ? 2 : text!.length)
                  .toUpperCase())
            else
              // Default user icon placeholder
              Span(
                  className: '$_iconSizeClasses text-gray-400 dark:text-gray-500',
                  children: [Text('?')]),
          ],
        ),
        // Chip indicator
        if (chipColor != null || chipText != null)
          Div(
            className:
                'absolute $_chipPositionClasses transform translate-x-1/4 -translate-y-1/4',
            children: [
              if (chipText != null)
                Span(
                  className:
                      'flex items-center justify-center min-w-4 h-4 px-1 text-[10px] font-medium bg-cyan-500 text-white rounded-full ring-2 ring-white dark:ring-gray-900',
                  children: [Text(chipText!)],
                )
              else
                Span(
                  className:
                      'block size-2.5 bg-cyan-500 rounded-full ring-2 ring-white dark:ring-gray-900',
                  children: [],
                ),
            ],
          ),
      ],
    );
  }
}

/// DuxtUI Avatar Group
class DAvatarGroup extends StatelessComponent {
  final List<DAvatar> avatars;
  final int max;
  final DAvatarSize size;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DAvatarGroup({
    super.key,
    required this.avatars,
    this.max = 4,
    this.size = DAvatarSize.md,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DAvatarSize.xxxs:
        return 'size-4 text-[8px]';
      case DAvatarSize.xxs:
        return 'size-5 text-[10px]';
      case DAvatarSize.xs:
        return 'size-6 text-xs';
      case DAvatarSize.sm:
        return 'size-8 text-sm';
      case DAvatarSize.md:
        return 'size-10 text-base';
      case DAvatarSize.lg:
        return 'size-12 text-lg';
      case DAvatarSize.xl:
        return 'size-14 text-xl';
      case DAvatarSize.xxl:
        return 'size-16 text-2xl';
      case DAvatarSize.xxxl:
        return 'size-20 text-3xl';
    }
  }

  @override
  Component build(BuildContext context) {
    final visible = avatars.take(max).toList();
    final remaining = avatars.length - max;

    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('flex -space-x-2', className),
      children: [
        for (final avatar in visible)
          Div(
              className: 'ring-2 ring-white dark:ring-gray-900 rounded-full',
              children: [avatar]),
        if (remaining > 0)
          Div(
            className:
                '$_sizeClasses rounded-full bg-gray-100 dark:bg-zinc-800 flex items-center justify-center font-medium text-gray-600 dark:text-gray-300 ring-2 ring-white dark:ring-gray-900',
            children: [Text('+$remaining')],
          ),
      ],
    );
  }
}
