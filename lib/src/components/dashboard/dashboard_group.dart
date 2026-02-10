import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI DashboardGroup component
///
/// A layout wrapper that provides the main container for dashboard layouts.
/// Uses flexbox with min-h-screen to fill the viewport.
class DDashboardGroup extends StatelessComponent {
  /// Custom CSS classes to apply to the group container
  final String? classes;

  /// Orientation of the dashboard layout
  final DDashboardOrientation orientation;

  /// Child components (typically sidebar + panel combinations)
  final List<Component> children;

  const DDashboardGroup({
    super.key,
    this.classes,
    this.orientation = DDashboardOrientation.horizontal,
    this.children = const [],
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
      className: 'flex min-h-screen $_orientationClasses ${classes ?? ""}',
      children: children,
    );
  }
}

/// Dashboard orientation options
enum DDashboardOrientation { horizontal, vertical }
