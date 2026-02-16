import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' as dom;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';
import '../avatar.dart';

/// User layout orientation
enum DUserOrientation { horizontal, vertical }

/// DuxtUI User component - Avatar with name and description
class DUser extends StatelessComponent {
  /// User's display name
  final String name;

  /// User's description (email, role, etc.)
  final String? description;

  /// Avatar image source
  final String? avatarSrc;

  /// Avatar initials (fallback when no image)
  final String? avatarInitials;

  /// Avatar background color
  final String? avatarColor;

  /// User component size
  final DSize size;

  /// Layout orientation
  final DUserOrientation orientation;

  /// Whether to reverse the layout (avatar on right)
  final bool reverse;

  /// Whether the user component is clickable
  final void Function()? onClick;

  /// Whether to show online/offline status
  final bool? online;

  /// Custom status text
  final String? status;

  /// Additional actions (e.g., buttons/icons)
  final List<Component>? actions;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DUser({
    super.key,
    required this.name,
    this.description,
    this.avatarSrc,
    this.avatarInitials,
    this.avatarColor,
    this.size = DSize.md,
    this.orientation = DUserOrientation.horizontal,
    this.reverse = false,
    this.onClick,
    this.online,
    this.status,
    this.actions,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  DAvatarSize get _avatarSize {
    switch (size) {
      case DSize.xs:
        return DAvatarSize.xs;
      case DSize.sm:
        return DAvatarSize.sm;
      case DSize.md:
        return DAvatarSize.md;
      case DSize.lg:
        return DAvatarSize.lg;
      case DSize.xl:
        return DAvatarSize.xl;
    }
  }

  String get _nameTextSize {
    switch (size) {
      case DSize.xs:
        return 'text-xs';
      case DSize.sm:
        return 'text-sm';
      case DSize.md:
        return 'text-sm';
      case DSize.lg:
        return 'text-base';
      case DSize.xl:
        return 'text-lg';
    }
  }

  String get _descriptionTextSize {
    switch (size) {
      case DSize.xs:
        return 'text-[10px]';
      case DSize.sm:
        return 'text-xs';
      case DSize.md:
        return 'text-xs';
      case DSize.lg:
        return 'text-sm';
      case DSize.xl:
        return 'text-base';
    }
  }

  String get _gap {
    switch (size) {
      case DSize.xs:
        return 'gap-1.5';
      case DSize.sm:
        return 'gap-2';
      case DSize.md:
        return 'gap-3';
      case DSize.lg:
        return 'gap-3';
      case DSize.xl:
        return 'gap-4';
    }
  }

  String get _statusDotSize {
    switch (size) {
      case DSize.xs:
        return 'size-1.5';
      case DSize.sm:
        return 'size-2';
      case DSize.md:
        return 'size-2.5';
      case DSize.lg:
        return 'size-3';
      case DSize.xl:
        return 'size-3.5';
    }
  }

  String get _initials {
    if (avatarInitials != null) return avatarInitials!;

    // Generate initials from name
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Component build(BuildContext context) {
    final avatar = _buildAvatar();
    final info = _buildInfo();

    final isVertical = orientation == DUserOrientation.vertical;

    final content = Div(
      id: id,
      className: twMerge(cx([
        'inline-flex items-center',
        _gap,
        if (isVertical) 'flex-col text-center',
        if (reverse && !isVertical) 'flex-row-reverse',
        if (onClick != null) 'cursor-pointer',
      ]), className),
      attributes: attributes,
      events: events,
      children: [
        avatar,
        info,
        if (actions != null && actions!.isNotEmpty)
          Div(
            className: 'flex items-center gap-1 ml-auto',
            children: actions!,
          ),
      ],
    );

    if (onClick != null) {
      return Button(
        type: 'button',
        className: 'hover:opacity-80 transition-opacity',
        events: dom.events(onClick: () => onClick!()),
        children: [content],
      );
    }

    return content;
  }

  Component _buildAvatar() {
    return Div(
      className: 'relative shrink-0',
      children: [
        DAvatar(
          src: avatarSrc,
          text: _initials,
          size: _avatarSize,
        ),
        // Online status indicator
        if (online != null)
          Div(
            className: cx([
              'absolute bottom-0 right-0 rounded-full ring-2 ring-white dark:ring-gray-900',
              _statusDotSize,
              online! ? 'bg-cyan-500' : 'bg-gray-400',
            ]),
            children: [],
          ),
      ],
    );
  }

  Component _buildInfo() {
    final isVertical = orientation == DUserOrientation.vertical;

    return Div(
      className: cx([
        'min-w-0',
        if (!isVertical) 'flex flex-col',
      ]),
      children: [
        // Name
        Span(
          className: cx([
            _nameTextSize,
            'font-medium truncate',
            DTextColors.defaultText,
          ]),
          children: [Text(name)],
        ),
        // Description or status
        if (description != null || status != null)
          Span(
            className: cx([
              _descriptionTextSize,
              'truncate',
              DTextColors.muted,
            ]),
            children: [Text(status ?? description ?? '')],
          ),
      ],
    );
  }
}

/// User card with additional content
class DUserCard extends StatelessComponent {
  /// User's display name
  final String name;

  /// User's description
  final String? description;

  /// Avatar image source
  final String? avatarSrc;

  /// Avatar initials
  final String? avatarInitials;

  /// Additional content below user info
  final Component? content;

  /// Card actions (buttons, links)
  final List<Component>? actions;

  /// Whether the card is clickable
  final void Function()? onClick;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DUserCard({
    super.key,
    required this.name,
    this.description,
    this.avatarSrc,
    this.avatarInitials,
    this.content,
    this.actions,
    this.onClick,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final cardContent = Div(
      id: id,
      className: twMerge(
          'p-4 rounded-lg border border-gray-200 dark:border-gray-700 ${DBgColors.defaultBg}',
          className),
      attributes: attributes,
      events: events,
      children: [
        DUser(
          name: name,
          description: description,
          avatarSrc: avatarSrc,
          avatarInitials: avatarInitials,
          size: DSize.lg,
        ),
        if (content != null) Div(className: 'mt-3', children: [content!]),
        if (actions != null && actions!.isNotEmpty)
          Div(
            className:
                'mt-4 pt-3 border-t border-gray-200 dark:border-gray-700 flex items-center gap-2',
            children: actions!,
          ),
      ],
    );

    if (onClick != null) {
      return Button(
        type: 'button',
        className: 'text-left w-full hover:shadow-md transition-shadow',
        events: dom.events(onClick: () => onClick!()),
        children: [cardContent],
      );
    }

    return cardContent;
  }
}

/// User list item (optimized for lists)
class DUserListItem extends StatelessComponent {
  /// User's display name
  final String name;

  /// User's description
  final String? description;

  /// Avatar image source
  final String? avatarSrc;

  /// Avatar initials
  final String? avatarInitials;

  /// Trailing content (e.g., badge, action)
  final Component? trailing;

  /// Whether the item is selected
  final bool selected;

  /// Click handler
  final void Function()? onClick;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DUserListItem({
    super.key,
    required this.name,
    this.description,
    this.avatarSrc,
    this.avatarInitials,
    this.trailing,
    this.selected = false,
    this.onClick,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final content = Div(
      id: id,
      className: twMerge(cx([
        'flex items-center justify-between gap-3 px-3 py-2 rounded-lg transition-colors',
        if (selected) 'bg-gray-100 dark:bg-zinc-800',
        if (onClick != null && !selected)
          'hover:bg-gray-50 dark:hover:bg-gray-800/50 cursor-pointer',
      ]), className),
      attributes: attributes,
      events: events,
      children: [
        DUser(
          name: name,
          description: description,
          avatarSrc: avatarSrc,
          avatarInitials: avatarInitials,
          size: DSize.sm,
        ),
        if (trailing != null) trailing!,
      ],
    );

    if (onClick != null) {
      return Button(
        type: 'button',
        className: 'w-full text-left',
        events: dom.events(onClick: () => onClick!()),
        children: [content],
      );
    }

    return content;
  }
}
