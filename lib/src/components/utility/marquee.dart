import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Marquee direction
enum DMarqueeDirection { left, right }

/// DuxtUI Marquee component - Scrolling content animation
///
/// Creates a smooth scrolling animation for content.
/// Content is duplicated to create seamless infinite scroll effect.
class DMarquee extends StatelessComponent {
  /// Content to scroll
  final List<Component> children;

  /// Scroll direction
  final DMarqueeDirection direction;

  /// Animation duration in seconds
  final int duration;

  /// Whether to pause on hover
  final bool pauseOnHover;

  /// Gap between repeated content
  final String gap;

  /// Custom CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DMarquee({
    super.key,
    required this.children,
    this.direction = DMarqueeDirection.left,
    this.duration = 20,
    this.pauseOnHover = true,
    this.gap = 'gap-8',
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _animationName {
    return direction == DMarqueeDirection.left
        ? 'marquee-left'
        : 'marquee-right';
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('flex overflow-hidden', className),
      attributes: attributes,
      events: this.events,
      children: [
        // Style tag for keyframes animation
        StyleElement(
          children: [
            Text('''
              @keyframes marquee-left {
                from { transform: translateX(0); }
                to { transform: translateX(-50%); }
              }
              @keyframes marquee-right {
                from { transform: translateX(-50%); }
                to { transform: translateX(0); }
              }
              .animate-marquee {
                animation: $_animationName ${duration}s linear infinite;
              }
              .animate-marquee:hover {
                ${pauseOnHover ? 'animation-play-state: paused;' : ''}
              }
            '''),
          ],
        ),
        // Animated container with duplicated content
        Div(
          className:
              'flex shrink-0 $gap animate-marquee ${pauseOnHover ? "hover:pause" : ""}',
          style: 'animation: $_animationName ${duration}s linear infinite',
          children: [
            // First copy
            Div(className: 'flex shrink-0 $gap', children: children),
            // Second copy for seamless loop
            Div(className: 'flex shrink-0 $gap', children: children),
          ],
        ),
      ],
    );
  }
}

/// Helper component for marquee items
class DMarqueeItem extends StatelessComponent {
  final Component child;
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DMarqueeItem({
    super.key,
    required this.child,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('flex-shrink-0', className),
      attributes: attributes,
      events: events,
      children: [child],
    );
  }
}
