import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI PageCTA component - Call-to-action section
///
/// A centered call-to-action section with title, description, and buttons.
class DPageCTA extends StatelessComponent {
  /// The main title
  final String? title;

  /// Description text
  final String? description;

  /// Call-to-action buttons/links
  final List<Component> links;

  /// Additional CSS classes
  final String? className;

  /// Enable gradient background
  final bool gradient;

  /// Custom gradient classes
  final String? gradientClasses;

  /// Enable card-style container
  final bool card;

  /// Card background classes
  final String? cardClasses;

  /// Optional icon component
  final Component? icon;

  /// Content alignment
  final DPageCTAAlign align;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPageCTA({
    super.key,
    this.title,
    this.description,
    this.links = const [],
    this.className,
    this.gradient = false,
    this.gradientClasses,
    this.card = false,
    this.cardClasses,
    this.icon,
    this.align = DPageCTAAlign.center,
    this.id,
    this.attributes,
    this.events,
  });

  String get _alignClasses {
    switch (align) {
      case DPageCTAAlign.left:
        return 'text-left items-start';
      case DPageCTAAlign.center:
        return 'text-center items-center';
      case DPageCTAAlign.right:
        return 'text-right items-end';
    }
  }

  @override
  Component build(BuildContext context) {
    final defaultGradient =
        'bg-gradient-to-r from-primary-500 to-primary-600 dark:from-primary-600 dark:to-primary-700';
    final bgClasses = gradient ? (gradientClasses ?? defaultGradient) : '';

    final defaultCard =
        'bg-gray-50 dark:bg-zinc-900 rounded-2xl ring-1 ring-gray-200 dark:ring-gray-800';
    final containerClasses = card ? (cardClasses ?? defaultCard) : '';

    final textColorClasses =
        gradient ? 'text-white' : 'text-gray-900 dark:text-white';
    final descColorClasses =
        gradient ? 'text-white/90' : 'text-gray-600 dark:text-gray-300';

    return Section(
      id: id,
      className: twMerge('py-12 sm:py-16 lg:py-20', className),
      attributes: attributes,
      events: events,
      children: [
        Div(
          className: 'max-w-7xl mx-auto px-4 sm:px-6 lg:px-8',
          children: [
            Div(
              className:
                  '$bgClasses $containerClasses ${card || gradient ? "p-8 sm:p-12 lg:p-16" : ""}',
              children: [
                Div(
                  className:
                      'flex flex-col $_alignClasses max-w-3xl ${align == DPageCTAAlign.center ? "mx-auto" : ""}',
                  children: [
                    // Icon
                    if (icon != null)
                      Div(
                        className:
                            'mb-6 ${gradient ? "text-white" : "text-primary-500"}',
                        children: [icon!],
                      ),
                    // Title
                    if (title != null)
                      H2(
                        className:
                            'text-2xl sm:text-3xl lg:text-4xl font-bold $textColorClasses tracking-tight',
                        children: [Text(title!)],
                      ),
                    // Description
                    if (description != null)
                      P(
                        className: 'mt-4 text-lg $descColorClasses',
                        children: [Text(description!)],
                      ),
                    // Links/buttons
                    if (links.isNotEmpty)
                      Div(
                        className:
                            'mt-8 flex flex-wrap gap-4 ${align == DPageCTAAlign.center ? "justify-center" : ""}',
                        children: links,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Alignment options for CTA content
enum DPageCTAAlign { left, center, right }
