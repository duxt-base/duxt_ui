import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Navigation menu orientation
enum DNavigationOrientation { horizontal, vertical }

/// Navigation item variant
enum DNavigationItemVariant { default_, active, disabled }

/// DuxtUI NavigationMenu component
class DNavigationMenu extends StatelessComponent {
  final List<DNavigationItem> items;
  final DNavigationOrientation orientation;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DNavigationMenu({
    super.key,
    required this.items,
    this.orientation = DNavigationOrientation.horizontal,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _orientationClasses {
    switch (orientation) {
      case DNavigationOrientation.horizontal:
        return 'flex items-center gap-1';
      case DNavigationOrientation.vertical:
        return 'flex flex-col gap-1';
    }
  }

  @override
  Component build(BuildContext context) {
    return Nav(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('', className),
      children: [
        Ul(
          className: _orientationClasses,
          children: items.map((item) => Li(children: [item])).toList(),
        ),
      ],
    );
  }
}

/// Navigation menu item
class DNavigationItem extends StatelessComponent {
  final String label;
  final String? href;
  final Component? icon;
  final Component? badge;
  final bool active;
  final bool disabled;
  final VoidCallback? onClick;
  final List<DNavigationItem>? children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DNavigationItem({
    super.key,
    required this.label,
    this.href,
    this.icon,
    this.badge,
    this.active = false,
    this.disabled = false,
    this.onClick,
    this.children,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final baseClasses =
        'flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md transition-colors';

    final stateClasses = disabled
        ? 'text-gray-400 dark:text-gray-600 cursor-not-allowed'
        : active
            ? 'text-gray-900 dark:text-white bg-gray-100 dark:bg-zinc-800'
            : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-gray-50 dark:hover:bg-gray-800/50';

    // If has children, render as dropdown trigger
    if (children != null && children!.isNotEmpty) {
      return Div(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('relative group', className),
        children: [
          Button(
            type: 'button',
            disabled: disabled,
            className: '$baseClasses $stateClasses',
            children: [
              if (icon != null) icon!,
              Text(label),
              if (badge != null) badge!,
              // Dropdown indicator
              Span(
                className: 'ml-1 transition-transform group-hover:rotate-180',
                children: [Text('\u25BC')], // Down arrow
              ),
            ],
          ),
          // Dropdown menu
          Div(
            className:
                'absolute left-0 top-full mt-1 min-w-48 py-1 bg-white dark:bg-zinc-900 rounded-lg shadow-lg ring-1 ring-gray-200 dark:ring-gray-800 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all z-50',
            children: children!,
          ),
        ],
      );
    }

    // Regular navigation item
    if (href != null && !disabled) {
      return A(
        href: href!,
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('$baseClasses $stateClasses', className),
        children: [
          if (icon != null) icon!,
          Text(label),
          if (badge != null) badge!,
        ],
      );
    }

    return Button(
      type: 'button',
      id: id,
      attributes: attributes,
      events: events,
      disabled: disabled,
      onClick: disabled ? null : onClick,
      className: twMerge('$baseClasses $stateClasses', className),
      children: [
        if (icon != null) icon!,
        Text(label),
        if (badge != null) badge!,
      ],
    );
  }
}

/// DuxtUI Vertical Navigation component
class DVerticalNavigation extends StatelessComponent {
  final List<DNavigationGroup> groups;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DVerticalNavigation({
    super.key,
    required this.groups,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Nav(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('space-y-4', className),
      children: groups,
    );
  }
}

/// Navigation group (for vertical navigation)
class DNavigationGroup extends StatelessComponent {
  final String? title;
  final List<DNavigationItem> items;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DNavigationGroup({
    super.key,
    this.title,
    required this.items,
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
      className: className ?? '',
      children: [
        if (title != null)
          H3(
            className:
                'px-3 mb-2 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider',
            children: [Text(title!)],
          ),
        Ul(
          className: 'space-y-1',
          children: items.map((item) => Li(children: [item])).toList(),
        ),
      ],
    );
  }
}
