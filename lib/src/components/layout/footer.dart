import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Footer style variants
enum DFooterVariant { simple, columns, centered }

/// DuxtUI Footer component
class DFooter extends StatelessComponent {
  final List<Component> children;
  final Component? left;
  final Component? center;
  final Component? right;
  final DFooterVariant variant;
  final bool bordered;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DFooter({
    super.key,
    this.children = const [],
    this.left,
    this.center,
    this.right,
    this.variant = DFooterVariant.simple,
    this.bordered = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final borderClasses =
        bordered ? 'border-t border-gray-200 dark:border-gray-800' : '';
    final bgClasses = 'bg-white dark:bg-zinc-900';

    // If left/center/right slots are provided, use structured layout
    if (left != null || center != null || right != null) {
      return Footer(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('$bgClasses $borderClasses', className),
        children: [
          Div(
            className: 'mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8',
            children: [
              Div(
                className:
                    'flex flex-col md:flex-row items-center justify-between gap-4',
                children: [
                  // Left slot
                  if (left != null)
                    Div(className: 'flex items-center gap-4', children: [left!]),
                  // Center slot
                  if (center != null)
                    Div(className: 'flex items-center gap-4', children: [center!]),
                  // Right slot
                  if (right != null)
                    Div(className: 'flex items-center gap-4', children: [right!]),
                ],
              ),
            ],
          ),
        ],
      );
    }

    // Simple footer with children
    return Footer(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('$bgClasses $borderClasses', className),
      children: [
        Div(
          className: 'mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8',
          children: children,
        ),
      ],
    );
  }
}

/// DuxtUI Footer Links section
class DFooterLinks extends StatelessComponent {
  final String? title;
  final List<DFooterLink> links;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DFooterLinks({
    super.key,
    this.title,
    this.links = const [],
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: className ?? '',
      children: [
        if (title != null)
          H3(
            className: 'text-sm font-semibold text-gray-900 dark:text-white',
            children: [Text(title!)],
          ),
        Ul(
          className: 'mt-4 space-y-2',
          children: links.map((link) => Li(children: [link])).toList(),
        ),
      ],
    );
  }
}

/// DuxtUI Footer Link item
class DFooterLink extends StatelessComponent {
  final String label;
  final String href;
  final bool external;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DFooterLink({
    super.key,
    required this.label,
    required this.href,
    this.external = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final baseAttributes = external ? {'rel': 'noopener noreferrer'} : <String, String>{};
    final mergedAttributes = {...baseAttributes, ...?attributes};

    return A(
      href: href,
      id: id,
      target: external ? Target.blank : null,
      attributes: mergedAttributes.isNotEmpty ? mergedAttributes : null,
      events: events,
      className: twMerge(
          'text-sm text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors',
          className),
      children: [
        Text(label),
        if (external)
          Span(
            className: 'ml-1 inline-block',
            children: [Text('\u2197')], // Unicode arrow for external link
          ),
      ],
    );
  }
}

/// DuxtUI Copyright text
class DCopyright extends StatelessComponent {
  final String text;
  final int? year;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DCopyright({
    super.key,
    required this.text,
    this.year,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final displayYear = year ?? DateTime.now().year;
    return P(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('text-sm text-gray-500 dark:text-gray-400', className),
      children: [Text('\u00A9 $displayYear $text')],
    );
  }
}
