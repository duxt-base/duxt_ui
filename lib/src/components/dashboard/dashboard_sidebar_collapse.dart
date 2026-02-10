import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI DashboardSidebarCollapse component
///
/// A collapsible section within the sidebar that shows/hides nested items.
/// Useful for grouping related navigation items.
class DDashboardSidebarCollapse extends StatefulComponent {
  /// Custom CSS classes
  final String? classes;

  /// Section label
  final String label;

  /// Leading icon
  final Component? icon;

  /// Whether initially open
  final bool initialOpen;

  /// Whether the parent sidebar is collapsed (icons only mode)
  final bool sidebarCollapsed;

  /// Child navigation items
  final List<Component> children;

  const DDashboardSidebarCollapse({
    super.key,
    this.classes,
    required this.label,
    this.icon,
    this.initialOpen = false,
    this.sidebarCollapsed = false,
    this.children = const [],
  });

  @override
  State<DDashboardSidebarCollapse> createState() =>
      _UDashboardSidebarCollapseState();
}

class _UDashboardSidebarCollapseState extends State<DDashboardSidebarCollapse> {
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = component.initialOpen;
  }

  void _toggle() {
    setState(() => _open = !_open);
  }

  Component get _chevronIcon {
    return Svg(
      className: 'w-4 h-4 transition-transform ${_open ? "rotate-90" : ""}',
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      children: [
        RawText('<polyline points="9 18 15 12 9 6"/>'),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    // When sidebar is collapsed, show as dropdown or tooltip
    if (component.sidebarCollapsed) {
      return Div(className: 'relative group', children: [
        // Icon button
        Button(
          type: 'button',
          onClick: _toggle,
          className:
              'w-full flex items-center justify-center p-3 rounded-lg text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-white transition-colors',
          attributes: {'title': component.label},
          children: [
            if (component.icon != null) component.icon!,
          ],
        ),
        // Flyout menu on hover
        Div(
          className:
              'absolute left-full top-0 ml-2 w-48 py-2 bg-white dark:bg-zinc-900 rounded-lg shadow-lg border border-gray-200 dark:border-gray-700 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all z-50',
          children: [
            // Label
            Div(
              className:
                  'px-3 py-2 text-xs font-semibold text-gray-400 uppercase',
              children: [Text(component.label)],
            ),
            // Children
            ...component.children,
          ],
        ),
      ]);
    }

    // Normal expanded sidebar
    return Div(className: component.classes ?? '', children: [
      // Toggle button
      Button(
        type: 'button',
        onClick: _toggle,
        className:
            'w-full flex items-center gap-3 px-3 py-2 rounded-lg text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-white transition-colors',
        children: [
          if (component.icon != null) component.icon!,
          Span(
              className: 'flex-1 text-left text-sm font-medium',
              children: [Text(component.label)]),
          _chevronIcon,
        ],
      ),
      // Collapsible content
      if (_open)
        Div(
          className: 'pl-4 mt-1 space-y-1',
          children: component.children,
        ),
    ]);
  }
}
