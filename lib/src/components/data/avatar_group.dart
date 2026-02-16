import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';
import '../avatar.dart';

// Re-export DAvatar for convenience (hide DAvatarGroup to avoid conflict)
export '../avatar.dart' show DAvatar, DAvatarSize;

/// DuxtUI Avatar Group component (enhanced version)
/// Displays a stack of overlapping avatars with optional overflow indicator
/// This is an enhanced version with more customization options
class DAvatarGroupEnhanced extends StatelessComponent {
  /// List of avatars to display
  final List<DAvatar> avatars;

  /// Maximum number of avatars to show before truncating
  final int max;

  /// Size of avatars in the group
  final DAvatarSize size;

  /// Spacing between avatars (negative for overlap)
  final String spacing;

  /// Ring color around avatars
  final String ringColor;

  /// Ring width
  final String ringWidth;

  /// Whether to reverse the stacking order (last avatar on top)
  final bool reverse;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DAvatarGroupEnhanced({
    super.key,
    required this.avatars,
    this.max = 4,
    this.size = DAvatarSize.md,
    this.spacing = '-space-x-2',
    this.ringColor = 'ring-white dark:ring-gray-900',
    this.ringWidth = 'ring-2',
    this.reverse = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DAvatarSize.xs:
        return 'h-6 w-6 text-[10px]';
      case DAvatarSize.sm:
        return 'h-8 w-8 text-xs';
      case DAvatarSize.md:
        return 'h-10 w-10 text-sm';
      case DAvatarSize.lg:
        return 'h-12 w-12 text-base';
      case DAvatarSize.xl:
        return 'h-16 w-16 text-lg';
      default:
        return 'h-10 w-10 text-sm';
    }
  }

  @override
  Component build(BuildContext context) {
    final displayAvatars = avatars.take(max).toList();
    final remaining = avatars.length - max;

    final avatarWidgets = <Component>[];

    for (var i = 0; i < displayAvatars.length; i++) {
      final avatar = displayAvatars[reverse ? displayAvatars.length - 1 - i : i];
      avatarWidgets.add(
        Div(
          className: 'rounded-full $ringWidth $ringColor',
          children: [avatar],
        ),
      );
    }

    // Add overflow indicator if there are more avatars
    if (remaining > 0) {
      avatarWidgets.add(
        Div(
          className:
              '$_sizeClasses rounded-full ${DBgColors.muted} flex items-center justify-center font-medium ${DTextColors.muted} $ringWidth $ringColor',
          children: [Text('+$remaining')],
        ),
      );
    }

    return Div(
      id: id,
      className: twMerge('inline-flex items-center $spacing', className),
      attributes: attributes,
      events: events,
      children: avatarWidgets,
    );
  }
}

/// Avatar Stack - Alternative layout with vertical stacking
class DAvatarStack extends StatelessComponent {
  /// List of avatars to display
  final List<DAvatar> avatars;

  /// Maximum number of avatars to show
  final int max;

  /// Size of avatars
  final DAvatarSize size;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DAvatarStack({
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
      case DAvatarSize.xs:
        return 'h-6 w-6 text-[10px]';
      case DAvatarSize.sm:
        return 'h-8 w-8 text-xs';
      case DAvatarSize.md:
        return 'h-10 w-10 text-sm';
      case DAvatarSize.lg:
        return 'h-12 w-12 text-base';
      case DAvatarSize.xl:
        return 'h-16 w-16 text-lg';
      default:
        return 'h-10 w-10 text-sm';
    }
  }

  @override
  Component build(BuildContext context) {
    final displayAvatars = avatars.take(max).toList();
    final remaining = avatars.length - max;

    return Div(
      id: id,
      className: twMerge('inline-flex flex-col -space-y-2', className),
      attributes: attributes,
      events: events,
      children: [
        for (final avatar in displayAvatars)
          Div(
            className: 'rounded-full ring-2 ring-white dark:ring-gray-900',
            children: [avatar],
          ),
        if (remaining > 0)
          Div(
            className:
                '$_sizeClasses rounded-full ${DBgColors.muted} flex items-center justify-center font-medium ${DTextColors.muted} ring-2 ring-white dark:ring-gray-900',
            children: [Text('+$remaining')],
          ),
      ],
    );
  }
}
