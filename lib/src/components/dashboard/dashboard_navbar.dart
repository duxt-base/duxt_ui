import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI DashboardNavbar component
///
/// A horizontal navigation bar for dashboard layouts.
/// Typically placed at the top of a dashboard panel.
class DDashboardNavbar extends StatelessComponent {
  /// Custom CSS classes to apply to the navbar
  final String? classes;

  /// Content for the left side of the navbar
  final Component? leading;

  /// Title text
  final String? title;

  /// Content for the center of the navbar
  final Component? center;

  /// Content for the right side of the navbar
  final Component? trailing;

  /// Whether to show a border at the bottom
  final bool bordered;

  /// Background variant
  final DNavbarBackground background;

  /// Child components (rendered in the center if center is not provided)
  final List<Component> children;

  const DDashboardNavbar({
    super.key,
    this.classes,
    this.leading,
    this.title,
    this.center,
    this.trailing,
    this.bordered = true,
    this.background = DNavbarBackground.white,
    this.children = const [],
  });

  String get _backgroundClasses {
    switch (background) {
      case DNavbarBackground.white:
        return 'bg-white dark:bg-zinc-900';
      case DNavbarBackground.gray:
        return 'bg-gray-50 dark:bg-zinc-900';
      case DNavbarBackground.transparent:
        return 'bg-transparent';
    }
  }

  String get _borderClasses {
    return bordered ? 'border-b border-gray-200 dark:border-gray-800' : '';
  }

  @override
  Component build(BuildContext context) {
    return Nav(
      className:
          'h-16 flex items-center justify-between px-4 $_backgroundClasses $_borderClasses ${classes ?? ""}',
      children: [
        // Left section
        Div(className: 'flex items-center gap-4', children: [
          if (leading != null) leading!,
          if (title != null)
            H1(
                className: 'text-lg font-semibold text-gray-900 dark:text-white',
                children: [Text(title!)]),
        ]),
        // Center section
        if (center != null)
          Div(className: 'flex-1 flex items-center justify-center', children: [center!])
        else if (children.isNotEmpty)
          Div(
              className: 'flex-1 flex items-center justify-center gap-4',
              children: children),
        // Right section
        if (trailing != null)
          Div(className: 'flex items-center gap-4', children: [trailing!]),
      ],
    );
  }
}

/// Navbar background variants
enum DNavbarBackground { white, gray, transparent }
