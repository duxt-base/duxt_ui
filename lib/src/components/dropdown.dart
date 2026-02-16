import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import '../theme/tw_merge.dart';

/// Dropdown item configuration
class DDropdownItem {
  final String label;
  final String? icon;
  final bool disabled;
  final bool divider;
  final String? href;

  const DDropdownItem({
    required this.label,
    this.icon,
    this.disabled = false,
    this.divider = false,
    this.href,
  });

  const DDropdownItem.divider()
      : label = '',
        icon = null,
        disabled = false,
        divider = true,
        href = null;
}

/// Dropdown placement
enum DDropdownPlacement {
  bottomStart,
  bottomEnd,
  topStart,
  topEnd,
}

/// DuxtUI Dropdown component using native HTML details/summary
///
/// Uses native `<details>` and `<summary>` elements for accessibility
/// and interactivity without JavaScript. Falls back gracefully.
class DDropdown extends StatelessComponent {
  final Component trigger;
  final List<DDropdownItem> items;
  final DDropdownPlacement placement;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DDropdown({
    super.key,
    required this.trigger,
    required this.items,
    this.placement = DDropdownPlacement.bottomEnd,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _placementClasses {
    switch (placement) {
      case DDropdownPlacement.bottomStart:
        return 'top-full left-0 mt-2';
      case DDropdownPlacement.bottomEnd:
        return 'top-full right-0 mt-2';
      case DDropdownPlacement.topStart:
        return 'bottom-full left-0 mb-2';
      case DDropdownPlacement.topEnd:
        return 'bottom-full right-0 mb-2';
    }
  }

  @override
  Component build(BuildContext context) {
    return Details(
      id: id,
      events: events,
      className: twMerge('relative inline-block group', className),
      attributes: mergeAttributes({
        'data-dropdown': 'true',
      }, attributes),
      children: [
        // Trigger wrapped in summary - use pointer-events to let summary handle clicks
        Summary(
          className: 'list-none [&::-webkit-details-marker]:hidden cursor-pointer [&>*]:pointer-events-none',
          children: [trigger],
        ),
        // Menu
        Div(
          className:
              'absolute $_placementClasses w-48 bg-white dark:bg-zinc-800 rounded-lg shadow-lg border border-gray-200 dark:border-zinc-700 py-1 z-50',
          children: [
            for (final item in items)
              if (item.divider)
                Div(
                    className:
                        'border-t border-gray-100 dark:border-zinc-700 my-1',
                    children: [])
              else if (item.href != null)
                A(
                  href: item.href!,
                  className:
                      'block w-full px-4 py-2 text-left text-sm flex items-center gap-2 ${item.disabled ? "text-gray-400 dark:text-zinc-500 cursor-not-allowed pointer-events-none" : "text-gray-700 dark:text-zinc-200 hover:bg-gray-100 dark:hover:bg-zinc-700"}',
                  attributes: {'data-dropdown-item': 'true'},
                  children: [
                    if (item.icon != null)
                      Span(
                        className: 'iconify w-4 h-4',
                        attributes: {'data-icon': item.icon!},
                        children: [],
                      ),
                    Text(item.label),
                  ],
                )
              else
                Div(
                  className:
                      'w-full px-4 py-2 text-left text-sm flex items-center gap-2 ${item.disabled ? "text-gray-400 dark:text-zinc-500 cursor-not-allowed" : "text-gray-700 dark:text-zinc-200 hover:bg-gray-100 dark:hover:bg-zinc-700 cursor-pointer"}',
                  attributes: {'data-dropdown-item': 'true'},
                  children: [
                    if (item.icon != null)
                      Span(
                        className: 'iconify w-4 h-4',
                        attributes: {'data-icon': item.icon!},
                        children: [],
                      ),
                    Text(item.label),
                  ],
                ),
          ],
        ),
        // Global click-outside and item-click handler
        RawText('''<script>
if (!window._dropdownInit) {
  window._dropdownInit = true;
  document.addEventListener('click', function(e) {
    // Close on click outside
    document.querySelectorAll('details[data-dropdown][open]').forEach(function(d) {
      if (!d.contains(e.target)) d.removeAttribute('open');
    });
    // Close on item click
    var item = e.target.closest('[data-dropdown-item]');
    if (item) {
      var dropdown = item.closest('details[data-dropdown]');
      if (dropdown) dropdown.removeAttribute('open');
    }
  });
}
</script>'''),
      ],
    );
  }
}
