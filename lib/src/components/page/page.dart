import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI Page component - Main page wrapper with optional aside
///
/// Provides a responsive grid layout with optional sidebar.
/// On large screens, uses a 10-column grid with aside and main areas.
class DPage extends StatelessComponent {
  /// The main content of the page
  final List<Component> children;

  /// Optional left sidebar content (sticky navigation)
  final Component? left;

  /// Optional right sidebar content
  final Component? right;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPage({
    super.key,
    this.children = const [],
    this.left,
    this.right,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final hasAside = left != null || right != null;

    if (!hasAside) {
      // No aside - simple wrapper
      return Div(
        id: id,
        className: twMerge('relative', className),
        attributes: attributes,
        events: events,
        children: children,
      );
    }

    // Grid layout with aside
    return Div(
      id: id,
      className: twMerge('grid lg:grid-cols-10 lg:gap-8', className),
      attributes: attributes,
      events: events,
      children: [
        // Left aside (if provided)
        if (left != null)
          Aside(
            className: 'hidden lg:block lg:col-span-2',
            children: [
              Div(
                className: 'sticky top-16',
                children: [left!],
              ),
            ],
          ),
        // Main content area
        Main(
          className: hasAside
              ? 'lg:col-span-${left != null && right != null ? "6" : "8"} min-w-0'
              : 'lg:col-span-10',
          children: children,
        ),
        // Right aside (if provided)
        if (right != null)
          Aside(
            className: 'hidden lg:block lg:col-span-2',
            children: [
              Div(
                className: 'sticky top-16',
                children: [right!],
              ),
            ],
          ),
      ],
    );
  }
}
