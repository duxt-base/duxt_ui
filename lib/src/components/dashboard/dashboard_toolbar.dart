import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI DashboardToolbar component
///
/// A horizontal toolbar for dashboard panels.
/// Typically used for page-level actions, filters, or secondary navigation.
class DDashboardToolbar extends StatelessComponent {
  /// Custom CSS classes
  final String? className;

  /// Content for the left side
  final Component? leading;

  /// Content for the right side
  final Component? trailing;

  /// Whether to show a border at the bottom
  final bool bordered;

  /// Background variant
  final DToolbarBackground background;

  /// Height variant
  final DToolbarHeight height;

  /// Child components (rendered in the center)
  final List<Component> children;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DDashboardToolbar({
    super.key,
    this.className,
    this.leading,
    this.trailing,
    this.bordered = true,
    this.background = DToolbarBackground.white,
    this.height = DToolbarHeight.md,
    this.children = const [],
    this.id,
    this.attributes,
    this.events,
  });

  String get _heightClasses {
    switch (height) {
      case DToolbarHeight.sm:
        return 'h-10';
      case DToolbarHeight.md:
        return 'h-12';
      case DToolbarHeight.lg:
        return 'h-14';
    }
  }

  String get _backgroundClasses {
    switch (background) {
      case DToolbarBackground.white:
        return 'bg-white dark:bg-zinc-900';
      case DToolbarBackground.gray:
        return 'bg-gray-50 dark:bg-zinc-900';
      case DToolbarBackground.transparent:
        return 'bg-transparent';
    }
  }

  String get _borderClasses {
    return bordered ? 'border-b border-gray-200 dark:border-gray-800' : '';
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('$_heightClasses flex items-center gap-2 px-4 $_backgroundClasses $_borderClasses', className),
      attributes: attributes,
      events: events,
      children: [
        // Left section
        if (leading != null)
          Div(className: 'flex items-center gap-2', children: [leading!]),
        // Center section
        if (children.isNotEmpty)
          Div(className: 'flex-1 flex items-center gap-2', children: children),
        // Right section
        if (trailing != null)
          Div(className: 'flex items-center gap-2 ml-auto', children: [trailing!]),
      ],
    );
  }
}

/// Toolbar background variants
enum DToolbarBackground { white, gray, transparent }

/// Toolbar height variants
enum DToolbarHeight { sm, md, lg }

/// Toolbar separator
class DToolbarSeparator extends StatelessComponent {
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DToolbarSeparator({super.key, this.className, this.id, this.attributes, this.events});

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('w-px h-6 bg-gray-200 dark:bg-zinc-700', className),
      attributes: attributes,
      events: events,
      children: [],
    );
  }
}

/// Toolbar spacer (pushes items to opposite sides)
class DToolbarSpacer extends StatelessComponent {
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DToolbarSpacer({super.key, this.className, this.id, this.attributes, this.events});

  @override
  Component build(BuildContext context) {
    return Div(id: id, className: twMerge('flex-1', className), attributes: attributes, events: events, children: []);
  }
}
