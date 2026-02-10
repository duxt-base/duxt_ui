import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI PageColumns component - Multi-column layout
///
/// A flexible multi-column layout for content sections.
class DPageColumns extends StatelessComponent {
  /// Column content
  final List<Component> children;

  /// Number of columns
  final int columns;

  /// Gap between columns
  final String gap;

  /// Additional CSS classes
  final String? classes;

  /// Whether columns should stack on mobile
  final bool stackOnMobile;

  /// Reverse order on mobile
  final bool reverseOnMobile;

  const DPageColumns({
    super.key,
    this.children = const [],
    this.columns = 2,
    this.gap = '8',
    this.classes,
    this.stackOnMobile = true,
    this.reverseOnMobile = false,
  });

  String get _columnsClasses {
    if (stackOnMobile) {
      switch (columns) {
        case 1:
          return 'grid-cols-1';
        case 2:
          return 'grid-cols-1 lg:grid-cols-2';
        case 3:
          return 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3';
        case 4:
          return 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-4';
        default:
          return 'grid-cols-1 lg:grid-cols-$columns';
      }
    }
    return 'grid-cols-$columns';
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'grid $_columnsClasses gap-$gap ${reverseOnMobile ? "flex-col-reverse lg:flex-row" : ""} ${classes ?? ""}',
      children: children,
    );
  }
}

/// DuxtUI PageColumn component - Individual column in a multi-column layout
class DPageColumn extends StatelessComponent {
  /// Column content
  final List<Component> children;

  /// Column span (1-12 based on grid)
  final int? span;

  /// Additional CSS classes
  final String? classes;

  /// Whether content should be sticky
  final bool sticky;

  /// Top offset for sticky positioning
  final String stickyTop;

  const DPageColumn({
    super.key,
    this.children = const [],
    this.span,
    this.classes,
    this.sticky = false,
    this.stickyTop = '16',
  });

  @override
  Component build(BuildContext context) {
    final spanClasses = span != null ? 'lg:col-span-$span' : '';
    final stickyClasses = sticky ? 'lg:sticky lg:top-$stickyTop' : '';

    return Div(
      className: '$spanClasses $stickyClasses ${classes ?? ""}',
      children: children,
    );
  }
}
