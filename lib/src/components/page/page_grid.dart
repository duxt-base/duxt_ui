import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Grid column configurations
enum DPageGridColumns { one, two, three, four, five, six }

/// DuxtUI PageGrid component - Responsive grid layout
///
/// A responsive grid for displaying cards or other content.
class DPageGrid extends StatelessComponent {
  /// Grid items
  final List<Component> children;

  /// Number of columns on large screens
  final DPageGridColumns columns;

  /// Gap between items
  final String gap;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPageGrid({
    super.key,
    this.children = const [],
    this.columns = DPageGridColumns.three,
    this.gap = '6',
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _columnsClasses {
    switch (columns) {
      case DPageGridColumns.one:
        return 'grid-cols-1';
      case DPageGridColumns.two:
        return 'grid-cols-1 sm:grid-cols-2';
      case DPageGridColumns.three:
        return 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3';
      case DPageGridColumns.four:
        return 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-4';
      case DPageGridColumns.five:
        return 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5';
      case DPageGridColumns.six:
        return 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('grid $_columnsClasses gap-$gap', className),
      attributes: attributes,
      events: events,
      children: children,
    );
  }
}
