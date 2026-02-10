import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI PageBody component - Main content section with optional TOC
///
/// Provides a flex layout with optional table of contents sidebar.
class DPageBody extends StatelessComponent {
  /// Prose content (main text content)
  final List<Component> prose;

  /// Optional table of contents or sidebar content
  final Component? toc;

  /// Additional CSS classes
  final String? classes;

  /// Additional CSS classes for the prose section
  final String? proseClasses;

  const DPageBody({
    super.key,
    this.prose = const [],
    this.toc,
    this.classes,
    this.proseClasses,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'flex flex-col lg:flex-row lg:gap-8 ${classes ?? ""}',
      children: [
        // Main prose content
        Div(
          className: 'flex-1 min-w-0 ${proseClasses ?? ""}',
          children: [
            Div(
              className: 'prose prose-gray dark:prose-invert max-w-none',
              children: prose,
            ),
          ],
        ),
        // Table of contents (if provided)
        if (toc != null)
          Div(
            className: 'hidden lg:block lg:w-48 xl:w-56 shrink-0',
            children: [
              Div(
                className: 'sticky top-16',
                children: [toc!],
              ),
            ],
          ),
      ],
    );
  }
}
