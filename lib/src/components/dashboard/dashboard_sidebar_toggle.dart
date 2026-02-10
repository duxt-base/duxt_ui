import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI DashboardSidebarToggle component
///
/// A button to toggle the sidebar collapse state.
/// Can be placed in the navbar or sidebar header.
class DDashboardSidebarToggle extends StatelessComponent {
  /// Custom CSS classes
  final String? classes;

  /// Whether the sidebar is currently collapsed
  final bool collapsed;

  /// Callback when toggled
  final VoidCallback? onToggle;

  /// Custom icon when collapsed
  final Component? collapsedIcon;

  /// Custom icon when expanded
  final Component? expandedIcon;

  /// Button variant
  final DToggleVariant variant;

  /// Size of the toggle button
  final DToggleSize size;

  const DDashboardSidebarToggle({
    super.key,
    this.classes,
    this.collapsed = false,
    this.onToggle,
    this.collapsedIcon,
    this.expandedIcon,
    this.variant = DToggleVariant.ghost,
    this.size = DToggleSize.md,
  });

  String get _variantClasses {
    switch (variant) {
      case DToggleVariant.ghost:
        return 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800';
      case DToggleVariant.outline:
        return 'border border-gray-200 dark:border-gray-700 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800';
      case DToggleVariant.solid:
        return 'bg-gray-100 dark:bg-zinc-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700';
    }
  }

  String get _sizeClasses {
    switch (size) {
      case DToggleSize.sm:
        return 'p-1.5';
      case DToggleSize.md:
        return 'p-2';
      case DToggleSize.lg:
        return 'p-2.5';
    }
  }

  Component get _defaultCollapsedIcon {
    // Hamburger menu icon (bars)
    return Svg(
      className: 'w-5 h-5',
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      children: [
        RawText('<line x1="3" y1="12" x2="21" y2="12"/>'),
        RawText('<line x1="3" y1="6" x2="21" y2="6"/>'),
        RawText('<line x1="3" y1="18" x2="21" y2="18"/>'),
      ],
    );
  }

  Component get _defaultExpandedIcon {
    // Chevron left icon (collapse)
    return Svg(
      className: 'w-5 h-5',
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      children: [
        RawText('<polyline points="15 18 9 12 15 6"/>'),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    final icon = collapsed
        ? (collapsedIcon ?? _defaultCollapsedIcon)
        : (expandedIcon ?? _defaultExpandedIcon);

    return Button(
      type: 'button',
      onClick: onToggle,
      className: 'rounded-lg transition-colors $_variantClasses $_sizeClasses ${classes ?? ""}',
      attributes: {
        'aria-label': collapsed ? 'Expand sidebar' : 'Collapse sidebar',
      },
      children: [icon],
    );
  }
}

/// Toggle button variants
enum DToggleVariant { ghost, outline, solid }

/// Toggle button sizes
enum DToggleSize { sm, md, lg }
