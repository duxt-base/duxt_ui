import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI PageHero component - Full-width hero section
///
/// A prominent hero section with optional gradient background.
class DPageHero extends StatelessComponent {
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

  /// Enable gradient background
  final bool gradient;

  /// Custom gradient classes (overrides default)
  final String? gradientClasses;

  /// Additional CSS classes
  final String? classes;

  /// Custom content slot (overrides title/description)
  final List<Component> children;

  const DPageHero({
    super.key,
    this.title,
    this.description,
    this.headline,
    this.align = DPageHeaderAlign.center,
    this.icon,
    this.links = const [],
    this.gradient = false,
    this.gradientClasses,
    this.classes,
    this.children = const [],
  });

  String get _alignClasses {
    switch (align) {
      case DPageHeaderAlign.left:
        return 'text-left items-start';
      case DPageHeaderAlign.center:
        return 'text-center items-center';
      case DPageHeaderAlign.right:
        return 'text-right items-end';
    }
  }

  @override
  Component build(BuildContext context) {
    final defaultGradient =
        'bg-gradient-to-b from-primary-50 to-white dark:from-gray-900 dark:to-gray-950';
    final bgClasses = gradient ? (gradientClasses ?? defaultGradient) : '';

    return Section(
      className: 'relative py-16 sm:py-24 lg:py-32 $bgClasses ${classes ?? ""}',
      children: [
        // Optional gradient overlay
        if (gradient)
          Div(
            className: 'absolute inset-0 overflow-hidden',
            children: [
              Div(
                className:
                    'absolute -top-40 -right-32 w-80 h-80 bg-primary-400/20 rounded-full blur-3xl',
                children: [],
              ),
              Div(
                className:
                    'absolute -bottom-40 -left-32 w-80 h-80 bg-primary-600/20 rounded-full blur-3xl',
                children: [],
              ),
            ],
          ),
        // Content container
        Div(
          className: 'relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8',
          children: [
            Div(
              className:
                  'flex flex-col $_alignClasses max-w-4xl ${align == DPageHeaderAlign.center ? "mx-auto" : ""}',
              children: [
                // Custom children (if provided)
                if (children.isNotEmpty)
                  ...children
                else ...[
                  // Icon (if provided)
                  if (icon != null) Div(className: 'mb-8', children: [icon!]),
                  // Headline/eyebrow
                  if (headline != null)
                    Span(
                      className:
                          'inline-flex items-center rounded-full bg-primary-50 dark:bg-primary-900/30 px-4 py-1.5 text-sm font-medium text-primary-600 dark:text-primary-400 ring-1 ring-inset ring-primary-500/20 mb-6',
                      children: [Text(headline!)],
                    ),
                  // Title
                  if (title != null)
                    H1(
                      className:
                          'text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 dark:text-white tracking-tight',
                      children: [Text(title!)],
                    ),
                  // Description
                  if (description != null)
                    P(
                      className:
                          'mt-6 text-lg sm:text-xl lg:text-2xl text-gray-600 dark:text-gray-300 max-w-3xl',
                      children: [Text(description!)],
                    ),
                  // Links/actions
                  if (links.isNotEmpty)
                    Div(
                      className:
                          'mt-10 flex flex-wrap gap-4 ${align == DPageHeaderAlign.center ? "justify-center" : ""}',
                      children: links,
                    ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Re-export align enum for convenience
enum DPageHeaderAlign { left, center, right }
