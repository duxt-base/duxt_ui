import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Scroll orientation
enum DScrollOrientation { vertical, horizontal, both }

/// Scrollbar visibility
enum DScrollbarVisibility { auto, always, hover, never }

/// DuxtUI ScrollArea component - Custom scrollbar styling
///
/// Provides a scrollable container with customized scrollbar appearance.
/// Supports both vertical and horizontal scrolling with thin scrollbars.
class DScrollArea extends StatelessComponent {
  /// Content to be scrolled
  final List<Component> children;

  /// Scroll orientation
  final DScrollOrientation orientation;

  /// Maximum height (for vertical scroll)
  final String? maxHeight;

  /// Maximum width (for horizontal scroll)
  final String? maxWidth;

  /// Scrollbar visibility behavior
  final DScrollbarVisibility scrollbarVisibility;

  /// Custom CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DScrollArea({
    super.key,
    required this.children,
    this.orientation = DScrollOrientation.vertical,
    this.maxHeight,
    this.maxWidth,
    this.scrollbarVisibility = DScrollbarVisibility.auto,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _overflowClasses {
    switch (orientation) {
      case DScrollOrientation.vertical:
        return 'overflow-y-auto overflow-x-hidden';
      case DScrollOrientation.horizontal:
        return 'overflow-x-auto overflow-y-hidden';
      case DScrollOrientation.both:
        return 'overflow-auto';
    }
  }

  String get _scrollbarClasses {
    switch (scrollbarVisibility) {
      case DScrollbarVisibility.auto:
        return 'scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600 scrollbar-track-transparent';
      case DScrollbarVisibility.always:
        return 'scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-gray-600 scrollbar-track-gray-100 dark:scrollbar-track-gray-800';
      case DScrollbarVisibility.hover:
        return 'scrollbar-thin scrollbar-thumb-transparent hover:scrollbar-thumb-gray-300 dark:hover:scrollbar-thumb-gray-600 scrollbar-track-transparent';
      case DScrollbarVisibility.never:
        return 'scrollbar-none';
    }
  }

  @override
  Component build(BuildContext context) {
    final styles = <String, String>{};
    if (maxHeight != null) {
      styles['max-height'] = maxHeight!;
    }
    if (maxWidth != null) {
      styles['max-width'] = maxWidth!;
    }

    return Div(
      id: id,
      className: twMerge([
        _overflowClasses,
        _scrollbarClasses,
        'scroll-smooth',
      ].join(' '), className),
      attributes: attributes,
      events: events,
      style: styles.isNotEmpty ? styles.entries.map((e) => '${e.key}: ${e.value}').join('; ') : null,
      children: [
        // Style tag for scrollbar CSS (works with Tailwind scrollbar plugin)
        StyleElement(
          children: [
            Text('''
              .scrollbar-thin::-webkit-scrollbar {
                width: 8px;
                height: 8px;
              }
              .scrollbar-thin::-webkit-scrollbar-track {
                background: transparent;
              }
              .scrollbar-thin::-webkit-scrollbar-thumb {
                background: #d1d5db;
                border-radius: 4px;
              }
              .scrollbar-thin::-webkit-scrollbar-thumb:hover {
                background: #9ca3af;
              }
              .dark .scrollbar-thin::-webkit-scrollbar-thumb {
                background: #4b5563;
              }
              .dark .scrollbar-thin::-webkit-scrollbar-thumb:hover {
                background: #6b7280;
              }
              .scrollbar-none::-webkit-scrollbar {
                display: none;
              }
              .scrollbar-none {
                -ms-overflow-style: none;
                scrollbar-width: none;
              }
            '''),
          ],
        ),
        ...children,
      ],
    );
  }
}
