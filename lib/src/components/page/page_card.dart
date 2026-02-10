import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI PageCard component - Card with title and description
///
/// A card component for page layouts with hover effects.
class DPageCard extends StatelessComponent {
  /// Card title
  final String? title;

  /// Card description
  final String? description;

  /// Optional icon component
  final Component? icon;

  /// Optional link href (makes entire card clickable)
  final String? to;

  /// Card content
  final List<Component> children;

  /// Additional CSS classes
  final String? classes;

  /// Whether to show hover ring effect
  final bool hoverRing;

  /// Optional badge/tag component
  final Component? badge;

  /// Optional footer content
  final Component? footer;

  const DPageCard({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.to,
    this.children = const [],
    this.classes,
    this.hoverRing = true,
    this.badge,
    this.footer,
  });

  @override
  Component build(BuildContext context) {
    final hoverClasses = hoverRing
        ? 'hover:ring-primary-500 dark:hover:ring-primary-400'
        : 'hover:shadow-lg';

    final cardContent = [
      // Icon and badge row
      if (icon != null || badge != null)
        Div(
          className: 'flex items-start justify-between mb-4',
          children: [
            if (icon != null)
              Div(
                className:
                    'flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-lg bg-primary-50 dark:bg-primary-900/30 text-primary-500 dark:text-primary-400',
                children: [icon!],
              )
            else
              Div(children: []),
            if (badge != null) badge!,
          ],
        ),
      // Title
      if (title != null)
        H3(
          className:
              'text-lg font-semibold text-gray-900 dark:text-white group-hover:text-primary-500 dark:group-hover:text-primary-400 transition-colors',
          children: [Text(title!)],
        ),
      // Description
      if (description != null)
        P(
          className: 'mt-2 text-sm text-gray-600 dark:text-gray-400',
          children: [Text(description!)],
        ),
      // Custom content
      if (children.isNotEmpty) Div(className: 'mt-4', children: children),
      // Footer
      if (footer != null)
        Div(
          className: 'mt-4 pt-4 border-t border-gray-100 dark:border-gray-800',
          children: [footer!],
        ),
    ];

    final cardClasses =
        'group relative bg-white dark:bg-zinc-900 rounded-xl p-6 ring-1 ring-gray-200 dark:ring-gray-800 $hoverClasses transition-all ${classes ?? ""}';

    // If there's a link, wrap in anchor
    if (to != null) {
      return A(
        href: to!,
        className: 'block $cardClasses',
        children: [
          // Link overlay for accessibility
          Span(
            className: 'absolute inset-0 z-10',
            attributes: {'aria-hidden': 'true'},
            children: [],
          ),
          ...cardContent,
        ],
      );
    }

    return Div(
      className: cardClasses,
      children: cardContent,
    );
  }
}
