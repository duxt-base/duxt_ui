import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Alignment options for page header content
enum DPageHeaderAlign { left, center, right }

/// DuxtUI PageHeader component - Responsive page header
///
/// Displays a page header with title, description, and optional links/actions.
class DPageHeader extends StatelessComponent {
  /// The main title
  final String? title;

  /// Optional description text
  final String? description;

  /// Optional headline/eyebrow text above the title
  final String? headline;

  /// Content alignment
  final DPageHeaderAlign align;

  /// Optional icon component
  final Component? icon;

  /// Optional links/buttons section
  final List<Component> links;

  /// Additional CSS classes
  final String? className;

  /// Custom title component (overrides title string)
  final Component? titleSlot;

  /// Custom description component (overrides description string)
  final Component? descriptionSlot;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPageHeader({
    super.key,
    this.title,
    this.description,
    this.headline,
    this.align = DPageHeaderAlign.left,
    this.icon,
    this.links = const [],
    this.className,
    this.titleSlot,
    this.descriptionSlot,
    this.id,
    this.attributes,
    this.events,
  });

  String get _alignClasses {
    switch (align) {
      case DPageHeaderAlign.left:
        return 'text-left';
      case DPageHeaderAlign.center:
        return 'text-center';
      case DPageHeaderAlign.right:
        return 'text-right';
    }
  }

  String get _linksAlignClasses {
    switch (align) {
      case DPageHeaderAlign.left:
        return 'justify-start';
      case DPageHeaderAlign.center:
        return 'justify-center';
      case DPageHeaderAlign.right:
        return 'justify-end';
    }
  }

  @override
  Component build(BuildContext context) {
    return Header(
      id: id,
      className: twMerge('py-8 sm:py-16 lg:py-24 $_alignClasses', className),
      attributes: attributes,
      events: events,
      children: [
        Div(
          className:
              'max-w-4xl ${align == DPageHeaderAlign.center ? "mx-auto" : ""}',
          children: [
            // Icon (if provided)
            if (icon != null)
              Div(
                className:
                    'mb-6 ${align == DPageHeaderAlign.center ? "flex justify-center" : ""}',
                children: [icon!],
              ),
            // Headline/eyebrow
            if (headline != null)
              P(
                className:
                    'text-sm font-semibold text-primary-500 dark:text-primary-400 mb-2',
                children: [Text(headline!)],
              ),
            // Title
            if (titleSlot != null)
              titleSlot!
            else if (title != null)
              H1(
                className:
                    'text-3xl sm:text-4xl lg:text-5xl font-bold text-gray-900 dark:text-white tracking-tight',
                children: [Text(title!)],
              ),
            // Description
            if (descriptionSlot != null)
              Div(className: 'mt-4 sm:mt-6', children: [descriptionSlot!])
            else if (description != null)
              P(
                className:
                    'mt-4 sm:mt-6 text-lg sm:text-xl text-gray-600 dark:text-gray-300',
                children: [Text(description!)],
              ),
            // Links/actions
            if (links.isNotEmpty)
              Div(
                className:
                    'mt-8 sm:mt-10 flex flex-wrap gap-3 $_linksAlignClasses',
                children: links,
              ),
          ],
        ),
      ],
    );
  }
}
