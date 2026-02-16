import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI PageBody component - Main content section with optional TOC
///
/// Provides a flex layout with optional table of contents sidebar.
class DPageBody extends StatelessComponent {
  /// Prose content (main text content)
  final List<Component> prose;

  /// Optional table of contents or sidebar content
  final Component? toc;

  /// Additional CSS classes
  final String? className;

  /// Additional CSS classes for the prose section
  final String? proseClasses;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPageBody({
    super.key,
    this.prose = const [],
    this.toc,
    this.className,
    this.proseClasses,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('flex flex-col lg:flex-row lg:gap-8', className),
      attributes: attributes,
      events: events,
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
