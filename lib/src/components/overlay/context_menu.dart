import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// Context menu item
class DContextMenuItem {
  final String label;
  final String? icon;
  final String? shortcut;
  final bool disabled;
  final bool divider;
  final VoidCallback? onClick;
  final List<DContextMenuItem>? submenu;

  const DContextMenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.disabled = false,
    this.divider = false,
    this.onClick,
    this.submenu,
  });

  const DContextMenuItem.divider()
      : label = '',
        icon = null,
        shortcut = null,
        disabled = false,
        divider = true,
        onClick = null,
        submenu = null;
}

/// DuxtUI Context Menu component - right-click menu
class DContextMenu extends StatefulComponent {
  final Component child;
  final List<DContextMenuItem> items;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  const DContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.onOpen,
    this.onClose,
  });

  @override
  State<DContextMenu> createState() => _UContextMenuState();
}

class _UContextMenuState extends State<DContextMenu> {
  bool _open = false;
  double _x = 0;
  double _y = 0;

  void _handleContextMenu(dynamic event) {
    // Prevent default browser context menu
    // Note: In Jaspr web, we would handle event.preventDefault() differently
    // For now, this is a placeholder

    setState(() {
      _open = true;
      // Get mouse position from event
      // Note: In Jaspr, we need to handle this differently
      // For now, we position relative to the element
      _x = 0;
      _y = 0;
      component.onOpen?.call();
    });
  }

  void _close() {
    if (_open) {
      setState(() {
        _open = false;
        component.onClose?.call();
      });
    }
  }

  void _handleItemClick(DContextMenuItem item) {
    if (!item.disabled && item.onClick != null) {
      _close();
      item.onClick!();
    }
  }

  Component _buildMenuItem(DContextMenuItem item) {
    if (item.divider) {
      return Div(
        className: 'border-t border-gray-200 dark:border-gray-700 my-1',
        children: [],
      );
    }

    final hasSubmenu = item.submenu != null && item.submenu!.isNotEmpty;

    return Div(
      className: 'relative group',
      children: [
        Button(
          type: 'button',
          disabled: item.disabled,
          onClick:
              item.disabled || hasSubmenu ? null : () => _handleItemClick(item),
          className:
              'w-full flex items-center justify-between px-3 py-2 text-sm ${item.disabled ? "text-gray-400 dark:text-gray-600 cursor-not-allowed" : "text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800"}',
          children: [
            Div(
              className: 'flex items-center gap-2',
              children: [
                if (item.icon != null)
                  Span(className: 'w-4 h-4', children: [Text(item.icon!)]),
                Span(children: [Text(item.label)]),
              ],
            ),
            if (item.shortcut != null)
              Span(
                className: 'ml-4 text-xs text-gray-400 dark:text-gray-500',
                children: [Text(item.shortcut!)],
              ),
            if (hasSubmenu)
              Span(
                className: 'ml-2 text-gray-400',
                children: [Text('\u203A')], // Right arrow
              ),
          ],
        ),
        // Submenu
        if (hasSubmenu)
          Div(
            className:
                'absolute left-full top-0 ml-1 hidden group-hover:block min-w-48 bg-white dark:bg-zinc-900 rounded-lg shadow-lg ring-1 ring-gray-200 dark:ring-gray-800 py-1',
            children: [
              for (final subItem in item.submenu!) _buildMenuItem(subItem),
            ],
          ),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'relative inline-block',
      children: [
        // Child with context menu event
        Div(
          events: {'contextmenu': _handleContextMenu},
          children: [component.child],
        ),
        // Context menu overlay
        if (_open) ...[
          // Invisible overlay to catch clicks outside
          Div(
            className: 'fixed inset-0 z-40',
            events: {'click': (_) => _close(), 'contextmenu': (_) => _close()},
            children: [],
          ),
          // Context menu
          Div(
            className:
                'absolute z-50 min-w-48 bg-white dark:bg-zinc-900 rounded-lg shadow-lg ring-1 ring-gray-200 dark:ring-gray-800 py-1',
            style: 'left: ${_x}px; top: ${_y}px',
            children: [
              for (final item in component.items) _buildMenuItem(item),
            ],
          ),
        ],
      ],
    );
  }
}

/// Controlled context menu that can be triggered programmatically
class DContextMenuControlled extends StatelessComponent {
  final bool open;
  final double x;
  final double y;
  final List<DContextMenuItem> items;
  final VoidCallback? onClose;

  const DContextMenuControlled({
    super.key,
    required this.open,
    required this.x,
    required this.y,
    required this.items,
    this.onClose,
  });

  Component _buildMenuItem(DContextMenuItem item, VoidCallback close) {
    if (item.divider) {
      return Div(
        className: 'border-t border-gray-200 dark:border-gray-700 my-1',
        children: [],
      );
    }

    return Button(
      type: 'button',
      disabled: item.disabled,
      onClick: item.disabled
          ? null
          : () {
              close();
              item.onClick?.call();
            },
      className:
          'w-full flex items-center justify-between px-3 py-2 text-sm ${item.disabled ? "text-gray-400 dark:text-gray-600 cursor-not-allowed" : "text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800"}',
      children: [
        Div(
          className: 'flex items-center gap-2',
          children: [
            if (item.icon != null)
              Span(className: 'w-4 h-4', children: [Text(item.icon!)]),
            Span(children: [Text(item.label)]),
          ],
        ),
        if (item.shortcut != null)
          Span(
            className: 'ml-4 text-xs text-gray-400 dark:text-gray-500',
            children: [Text(item.shortcut!)],
          ),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    if (!open) return Div(children: []);

    return Div(
      children: [
        // Invisible overlay to catch clicks outside
        Div(
          className: 'fixed inset-0 z-40',
          events: onClose != null
              ? {'click': (_) => onClose!(), 'contextmenu': (_) => onClose!()}
              : {},
          children: [],
        ),
        // Context menu
        Div(
          className:
              'fixed z-50 min-w-48 bg-white dark:bg-zinc-900 rounded-lg shadow-lg ring-1 ring-gray-200 dark:ring-gray-800 py-1',
          style: 'left: ${x}px; top: ${y}px',
          children: [
            for (final item in items)
              _buildMenuItem(item, () => onClose?.call()),
          ],
        ),
      ],
    );
  }
}
