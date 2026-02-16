import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI DashboardGroup component
///
/// A layout wrapper that provides the main container for dashboard layouts.
/// Uses flexbox with min-h-screen to fill the viewport.
class DDashboardGroup extends StatelessComponent {
  /// Custom CSS classes to apply to the group container
  final String? className;

  /// Orientation of the dashboard layout
  final DDashboardOrientation orientation;

  /// Child components (typically sidebar + panel combinations)
  final List<Component> children;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DDashboardGroup({
    super.key,
    this.className,
    this.orientation = DDashboardOrientation.horizontal,
    this.children = const [],
    this.id,
    this.attributes,
    this.events,
  });

  String get _orientationClasses {
    switch (orientation) {
      case DDashboardOrientation.horizontal:
        return 'flex-row';
      case DDashboardOrientation.vertical:
        return 'flex-col';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('flex min-h-screen $_orientationClasses', className),
      attributes: attributes,
      events: events,
      children: children,
    );
  }
}

/// Dashboard orientation options
enum DDashboardOrientation { horizontal, vertical }
