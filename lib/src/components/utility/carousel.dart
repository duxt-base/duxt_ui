import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import 'icon.dart';

/// Carousel item data
class DCarouselItem {
  final String? image;
  final String? alt;
  final Component? content;

  const DCarouselItem({
    this.image,
    this.alt,
    this.content,
  });
}

/// DuxtUI Carousel component - CSS/JS carousel
///
/// A responsive carousel with prev/next navigation and dot indicators.
/// Uses inline JavaScript for navigation.
class DCarousel extends StatelessComponent {
  /// List of items to display
  final List<DCarouselItem> items;

  /// Whether to show navigation arrows
  final bool showArrows;

  /// Whether to show dot indicators
  final bool showDots;

  /// Initial slide index
  final int initialIndex;

  /// Custom CSS classes
  final String? classes;

  const DCarousel({
    super.key,
    required this.items,
    this.showArrows = true,
    this.showDots = true,
    this.initialIndex = 0,
    this.classes,
  });

  String get _carouselId => 'carousel_$hashCode';

  @override
  Component build(BuildContext context) {
    if (items.isEmpty) {
      return Div(className: 'relative', children: []);
    }

    return Div(
      id: _carouselId,
      className: 'relative overflow-hidden group ${classes ?? ""}',
      attributes: {'data-carousel': 'true', 'data-index': '$initialIndex'},
      children: [
        // Slides container
        Div(
          className: 'flex transition-transform duration-300 ease-in-out',
          attributes: {'data-slides': 'true'},
          style: 'transform: translateX(-${initialIndex * 100}%)',
          children: [
            for (var i = 0; i < items.length; i++)
              Div(
                className: 'w-full flex-shrink-0',
                children: [
                  if (items[i].image != null)
                    Img(
                      src: items[i].image!,
                      alt: items[i].alt ?? 'Slide ${i + 1}',
                      className: 'w-full h-full object-cover',
                    )
                  else if (items[i].content != null)
                    items[i].content!,
                ],
              ),
          ],
        ),

        // Previous button
        if (showArrows && items.length > 1)
          Button(
            type: 'button',
            className:
                'absolute left-2 top-1/2 -translate-y-1/2 p-2 rounded-full bg-white/80 dark:bg-zinc-800/80 shadow-lg opacity-0 group-hover:opacity-100 transition-opacity hover:bg-white dark:hover:bg-zinc-800',
            attributes: {'data-action': 'prev', 'aria-label': 'Previous slide'},
            children: [
              DIcon(name: DIconNames.chevronLeft, size: DIconSize.sm),
            ],
          ),

        // Next button
        if (showArrows && items.length > 1)
          Button(
            type: 'button',
            className:
                'absolute right-2 top-1/2 -translate-y-1/2 p-2 rounded-full bg-white/80 dark:bg-zinc-800/80 shadow-lg opacity-0 group-hover:opacity-100 transition-opacity hover:bg-white dark:hover:bg-zinc-800',
            attributes: {'data-action': 'next', 'aria-label': 'Next slide'},
            children: [
              DIcon(name: DIconNames.chevronRight, size: DIconSize.sm),
            ],
          ),

        // Dot indicators
        if (showDots && items.length > 1)
          Div(
            className: 'absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2',
            attributes: {'data-dots': 'true'},
            children: [
              for (var i = 0; i < items.length; i++)
                Button(
                  type: 'button',
                  className:
                      'w-2 h-2 rounded-full transition-colors ${i == initialIndex ? "bg-white" : "bg-white/50 hover:bg-white/75"}',
                  attributes: {
                    'data-goto': '$i',
                    'aria-label': 'Go to slide ${i + 1}'
                  },
                  children: [],
                ),
            ],
          ),

        // Carousel JavaScript
        RawText('''<script>
if (!window._carouselInit) {
  window._carouselInit = true;
  document.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-action], [data-goto]');
    if (!btn) return;
    var carousel = btn.closest('[data-carousel]');
    if (!carousel) return;
    var slides = carousel.querySelector('[data-slides]');
    var dots = carousel.querySelector('[data-dots]');
    var total = slides.children.length;
    var idx = parseInt(carousel.dataset.index) || 0;

    if (btn.dataset.action === 'prev') {
      idx = Math.max(0, idx - 1);
    } else if (btn.dataset.action === 'next') {
      idx = Math.min(total - 1, idx + 1);
    } else if (btn.dataset.goto !== undefined) {
      idx = parseInt(btn.dataset.goto);
    }

    carousel.dataset.index = idx;
    slides.style.transform = 'translateX(-' + (idx * 100) + '%)';

    if (dots) {
      dots.querySelectorAll('button').forEach(function(dot, i) {
        dot.className = dot.className.replace(/bg-white(\\/50)?/g, '');
        dot.classList.add(i === idx ? 'bg-white' : 'bg-white/50');
      });
    }
  });
}
</script>'''),
      ],
    );
  }
}
