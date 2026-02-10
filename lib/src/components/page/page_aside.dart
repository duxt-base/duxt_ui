import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI PageAside component - Sticky sidebar navigation
///
/// A sticky sidebar for navigation, typically used for docs navigation or TOC.
class DPageAside extends StatelessComponent {
  /// The sidebar content
  final List<Component> children;

  /// Additional CSS classes
  final String? classes;

  /// Top offset for sticky positioning (default: 16 = 4rem)
  final String topOffset;

  /// Whether to hide on mobile/tablet
  final bool hiddenOnMobile;

  /// Optional title for the aside
  final String? title;

  const DPageAside({
    super.key,
    this.children = const [],
    this.classes,
    this.topOffset = '16',
    this.hiddenOnMobile = true,
    this.title,
  });

  @override
  Component build(BuildContext context) {
    return Aside(
      className: '${hiddenOnMobile ? "hidden lg:block" : ""} ${classes ?? ""}',
      children: [
        Div(
          className: 'sticky top-$topOffset',
          children: [
            // Navigation container
            Nav(
              className: 'space-y-1',
              children: [
                // Optional title
                if (title != null)
                  H4(
                    className:
                        'text-sm font-semibold text-gray-900 dark:text-white mb-4',
                    children: [Text(title!)],
                  ),
                // Content
                ...children,
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// DuxtUI PageAsideLink component - Link item for page aside
class DPageAsideLink extends StatelessComponent {
  /// Link text
  final String label;

  /// Link href
  final String href;

  /// Whether this link is active
  final bool active;

  /// Nesting level (0 = root, 1 = nested, etc.)
  final int level;

  /// Additional CSS classes
  final String? classes;

  const DPageAsideLink({
    super.key,
    required this.label,
    required this.href,
    this.active = false,
    this.level = 0,
    this.classes,
  });

  @override
  Component build(BuildContext context) {
    final paddingLeft = level > 0 ? 'pl-${level * 3}' : '';
    final activeClasses = active
        ? 'text-primary-500 dark:text-primary-400 font-medium border-l-2 border-primary-500'
        : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white border-l-2 border-transparent hover:border-gray-300';

    return A(
      href: href,
      className:
          'block py-1.5 pl-3 pr-2 text-sm $paddingLeft $activeClasses transition-colors ${classes ?? ""}',
      children: [Text(label)],
    );
  }
}

/// DuxtUI PageAsideGroup component - Group of links with optional title
class DPageAsideGroup extends StatelessComponent {
  /// Group title
  final String? title;

  /// Group links
  final List<Component> children;

  /// Whether the group is collapsible
  final bool collapsible;

  /// Whether the group is initially expanded (when collapsible)
  final bool defaultExpanded;

  /// Additional CSS classes
  final String? classes;

  const DPageAsideGroup({
    super.key,
    this.title,
    this.children = const [],
    this.collapsible = false,
    this.defaultExpanded = true,
    this.classes,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'mb-6 ${classes ?? ""}',
      children: [
        if (title != null)
          H5(
            className:
                'text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-3',
            children: [Text(title!)],
          ),
        Div(
          className: 'space-y-1',
          children: children,
        ),
      ],
    );
  }
}
