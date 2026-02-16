import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import '../theme/tw_merge.dart';

/// Tab orientation
enum DTabsOrientation { horizontal, vertical }

/// Tab item data
class DTabItem {
  final String label;
  final String value;
  final Component? icon;
  final Component? content;
  final bool disabled;

  const DTabItem({
    required this.label,
    required this.value,
    this.icon,
    this.content,
    this.disabled = false,
  });
}

/// DuxtUI Tabs component with native JS interactivity
///
/// Uses browser-native JavaScript for tab switching without requiring @client.
/// Tab content is shown/hidden using CSS classes.
class DTabs extends StatelessComponent {
  final List<DTabItem> items;
  final String? defaultValue;
  final DTabsOrientation orientation;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DTabs({
    super.key,
    required this.items,
    this.defaultValue,
    this.orientation = DTabsOrientation.horizontal,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _tabsId => id ?? 'tabs_$hashCode';

  @override
  Component build(BuildContext context) {
    final isVertical = orientation == DTabsOrientation.vertical;
    final initialValue =
        defaultValue ?? (items.isNotEmpty ? items.first.value : '');

    // Generate JS for tab switching
    final tabScript = '''
      (function() {
        var tabsEl = document.getElementById('$_tabsId');
        if (!tabsEl) return;
        tabsEl.querySelectorAll('[data-tab-trigger]').forEach(function(btn) {
          btn.addEventListener('click', function() {
            var value = this.getAttribute('data-tab-trigger');
            // Update button states
            tabsEl.querySelectorAll('[data-tab-trigger]').forEach(function(b) {
              b.classList.remove('tab-active');
              b.setAttribute('aria-selected', 'false');
            });
            this.classList.add('tab-active');
            this.setAttribute('aria-selected', 'true');
            // Update panel visibility
            tabsEl.querySelectorAll('[data-tab-panel]').forEach(function(p) {
              if (p.getAttribute('data-tab-panel') === value) {
                p.classList.remove('hidden');
              } else {
                p.classList.add('hidden');
              }
            });
          });
        });
      })();
    ''';

    if (isVertical) {
      return Div(
        id: _tabsId,
        attributes: attributes,
        events: events,
        className: twMerge('flex gap-4', className),
        children: [
          // Tab list (vertical)
          Div(
            className: 'flex flex-col gap-1',
            attributes: {'role': 'tablist', 'aria-orientation': 'vertical'},
            children: [
              for (final item in items) _buildTab(item, isVertical, initialValue),
            ],
          ),
          // Tab panels
          Div(className: 'flex-1', children: [
            for (final item in items) _buildPanel(item, initialValue),
          ]),
          // Inline script for interactivity
          RawText('<script>$tabScript</script>'),
        ],
      );
    }

    return Div(
      id: _tabsId,
      attributes: attributes,
      events: events,
      className: className,
      children: [
        // Tab list (horizontal)
        Div(
          className: 'flex border-b border-gray-200 dark:border-gray-800 gap-1',
          attributes: {'role': 'tablist'},
          children: [
            for (final item in items) _buildTab(item, isVertical, initialValue),
          ],
        ),
        // Tab panels
        Div(className: 'mt-4', children: [
          for (final item in items) _buildPanel(item, initialValue),
        ]),
        // Inline script for interactivity
        RawText('<script>$tabScript</script>'),
      ],
    );
  }

  Component _buildTab(DTabItem item, bool isVertical, String activeValue) {
    final isActive = item.value == activeValue;

    final baseClasses =
        'flex items-center gap-1.5 px-3 py-2 text-sm font-medium transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-500 focus-visible:ring-offset-2';

    final activeClasses = isVertical
        ? 'bg-gray-100 text-gray-900 dark:bg-zinc-800 dark:text-white rounded-md'
        : 'border-b-2 border-cyan-500 text-cyan-600 dark:text-cyan-400 -mb-px';

    final inactiveClasses = isVertical
        ? 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-md hover:bg-gray-50 dark:hover:bg-gray-800/50'
        : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 border-b-2 border-transparent hover:border-gray-300 dark:hover:border-gray-700 -mb-px';

    final disabledClasses =
        item.disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer';

    return Button(
      type: 'button',
      disabled: item.disabled,
      className:
          '$baseClasses ${isActive ? activeClasses : inactiveClasses} $disabledClasses ${isActive ? "tab-active" : ""}',
      attributes: {
        'role': 'tab',
        'data-tab-trigger': item.value,
        'aria-selected': isActive.toString(),
        'aria-controls': 'panel_${item.value}',
      },
      children: [
        if (item.icon != null) Span(className: 'size-4', children: [item.icon!]),
        Text(item.label),
      ],
    );
  }

  Component _buildPanel(DTabItem item, String activeValue) {
    final isActive = item.value == activeValue;

    return Div(
      id: 'panel_${item.value}',
      className: isActive ? '' : 'hidden',
      attributes: {
        'role': 'tabpanel',
        'data-tab-panel': item.value,
        'aria-labelledby': item.value,
      },
      children: [if (item.content != null) item.content!],
    );
  }
}

/// Controlled tabs variant that allows external state management
class DControlledTabs extends StatelessComponent {
  final List<DTabItem> items;
  final String selected;
  final DTabsOrientation orientation;
  final bool unmountOnHide;
  final ValueChanged<String>? onSelect;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DControlledTabs({
    super.key,
    required this.items,
    required this.selected,
    this.orientation = DTabsOrientation.horizontal,
    this.unmountOnHide = true,
    this.onSelect,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final isVertical = orientation == DTabsOrientation.vertical;

    if (isVertical) {
      return Div(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('flex gap-4', className),
        children: [
          Div(
            className: 'flex flex-col gap-1',
            children: [
              for (final item in items) _buildTab(item, isVertical),
            ],
          ),
          Div(className: 'flex-1', children: [
            for (final item in items)
              if (!unmountOnHide || item.value == selected)
                Div(
                  className: item.value == selected ? '' : 'hidden',
                  children: [if (item.content != null) item.content!],
                ),
          ]),
        ],
      );
    }

    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: className,
      children: [
        Div(
          className: 'flex border-b border-gray-200 dark:border-gray-800 gap-1',
          children: [
            for (final item in items) _buildTab(item, isVertical),
          ],
        ),
        Div(className: 'mt-4', children: [
          for (final item in items)
            if (!unmountOnHide || item.value == selected)
              Div(
                className: item.value == selected ? '' : 'hidden',
                children: [if (item.content != null) item.content!],
              ),
        ]),
      ],
    );
  }

  Component _buildTab(DTabItem item, bool isVertical) {
    final isActive = item.value == selected;

    final baseClasses =
        'flex items-center gap-1.5 px-3 py-2 text-sm font-medium transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-500 focus-visible:ring-offset-2';

    final activeClasses = isVertical
        ? 'bg-gray-100 text-gray-900 dark:bg-zinc-800 dark:text-white rounded-md'
        : 'border-b-2 border-cyan-500 text-cyan-600 dark:text-cyan-400 -mb-px';

    final inactiveClasses = isVertical
        ? 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-md hover:bg-gray-50 dark:hover:bg-gray-800/50'
        : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 border-b-2 border-transparent hover:border-gray-300 dark:hover:border-gray-700 -mb-px';

    final stateClasses = isActive ? activeClasses : inactiveClasses;
    final disabledClasses =
        item.disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer';

    return Button(
      type: 'button',
      disabled: item.disabled,
      onClick: item.disabled ? null : () => onSelect?.call(item.value),
      className: '$baseClasses $stateClasses $disabledClasses',
      children: [
        if (item.icon != null) Span(className: 'size-4', children: [item.icon!]),
        Text(item.label),
      ],
    );
  }
}
