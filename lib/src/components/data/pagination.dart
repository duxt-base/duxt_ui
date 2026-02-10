import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show events;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';

/// Pagination variants
enum DPaginationVariant { solid, outline, soft, subtle, ghost }

/// DuxtUI Pagination component
class DPagination extends StatelessComponent {
  /// Current active page (1-indexed)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Callback when page changes
  final void Function(int page)? onPageChange;

  /// Number of page buttons to show on each side of current page
  final int siblingCount;

  /// Whether to show first/last page buttons
  final bool showFirstLast;

  /// Whether to show previous/next buttons
  final bool showPrevNext;

  /// Pagination variant
  final DPaginationVariant variant;

  /// Pagination color
  final DColor color;

  /// Pagination size
  final DSize size;

  /// Whether pagination is disabled
  final bool disabled;

  /// Custom previous button text/icon
  final String prevLabel;

  /// Custom next button text/icon
  final String nextLabel;

  /// Custom first button text/icon
  final String firstLabel;

  /// Custom last button text/icon
  final String lastLabel;

  const DPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChange,
    this.siblingCount = 1,
    this.showFirstLast = false,
    this.showPrevNext = true,
    this.variant = DPaginationVariant.outline,
    this.color = DColor.primary,
    this.size = DSize.sm,
    this.disabled = false,
    this.prevLabel = 'i-lucide-chevron-left',
    this.nextLabel = 'i-lucide-chevron-right',
    this.firstLabel = 'i-lucide-chevrons-left',
    this.lastLabel = 'i-lucide-chevrons-right',
  });

  String get _sizeClasses {
    switch (size) {
      case DSize.xs:
        return 'h-7 min-w-7 text-xs';
      case DSize.sm:
        return 'h-8 min-w-8 text-sm';
      case DSize.md:
        return 'h-9 min-w-9 text-sm';
      case DSize.lg:
        return 'h-10 min-w-10 text-base';
      case DSize.xl:
        return 'h-11 min-w-11 text-base';
    }
  }

  String get _iconSize {
    switch (size) {
      case DSize.xs:
        return 'size-3.5';
      case DSize.sm:
        return 'size-4';
      case DSize.md:
        return 'size-4';
      case DSize.lg:
        return 'size-5';
      case DSize.xl:
        return 'size-5';
    }
  }

  String _buttonClasses(bool isActive) {
    final baseColor = defaultColorMapping[color] ?? 'green';

    final baseClasses = cx([
      _sizeClasses,
      'inline-flex items-center justify-center rounded-md font-medium transition-colors',
      'focus:outline-none focus-visible:ring-2 focus-visible:ring-$baseColor-500 focus-visible:ring-offset-2',
      if (disabled) 'opacity-50 cursor-not-allowed',
    ]);

    if (isActive) {
      switch (variant) {
        case DPaginationVariant.solid:
          return '$baseClasses bg-$baseColor-500 text-white';
        case DPaginationVariant.outline:
          return '$baseClasses ring-1 ring-inset ring-$baseColor-500 text-$baseColor-500 bg-$baseColor-50 dark:bg-$baseColor-950';
        case DPaginationVariant.soft:
          return '$baseClasses bg-$baseColor-100 text-$baseColor-700 dark:bg-$baseColor-900 dark:text-$baseColor-300';
        case DPaginationVariant.subtle:
          return '$baseClasses bg-$baseColor-50 text-$baseColor-500 dark:bg-$baseColor-950 dark:text-$baseColor-400';
        case DPaginationVariant.ghost:
          return '$baseClasses text-$baseColor-500 bg-$baseColor-50 dark:bg-$baseColor-950';
      }
    }

    switch (variant) {
      case DPaginationVariant.solid:
        return '$baseClasses bg-transparent text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800';
      case DPaginationVariant.outline:
        return '$baseClasses ring-1 ring-inset ring-gray-200 dark:ring-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800';
      case DPaginationVariant.soft:
        return '$baseClasses bg-gray-100 text-gray-700 dark:bg-zinc-800 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700';
      case DPaginationVariant.subtle:
        return '$baseClasses text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800';
      case DPaginationVariant.ghost:
        return '$baseClasses text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800';
    }
  }

  String get _navButtonClasses {
    return _buttonClasses(false);
  }

  List<int?> get _pageNumbers {
    final pages = <int?>[];

    // Handle edge cases
    if (totalPages <= 0) return pages;
    if (totalPages == 1) return [1];
    if (totalPages == 2) return [1, 2];

    // Always show first page
    pages.add(1);

    // Calculate range around current page (only if totalPages > 2)
    final maxPage = totalPages - 1;
    final rangeStart = (currentPage - siblingCount).clamp(2, maxPage);
    final rangeEnd = (currentPage + siblingCount).clamp(2, maxPage);

    // Add ellipsis if needed before range
    if (rangeStart > 2) {
      pages.add(null); // null represents ellipsis
    }

    // Add pages in range
    for (var i = rangeStart; i <= rangeEnd; i++) {
      if (i > 1 && i < totalPages) {
        pages.add(i);
      }
    }

    // Add ellipsis if needed after range
    if (rangeEnd < totalPages - 1) {
      pages.add(null);
    }

    // Always show last page
    pages.add(totalPages);

    return pages;
  }

  void _handlePageChange(int page) {
    if (!disabled && onPageChange != null && page >= 1 && page <= totalPages) {
      onPageChange!(page);
    }
  }

  @override
  Component build(BuildContext context) {
    if (totalPages <= 0) {
      return Span(children: []);
    }

    final children = <Component>[];

    // First button
    if (showFirstLast) {
      children.add(
        Button(
          type: 'button',
          className: cx([
            _navButtonClasses,
            if (currentPage <= 1) 'opacity-50 cursor-not-allowed',
          ]),
          attributes: currentPage <= 1 ? {'disabled': 'true'} : null,
          events: events(onClick: () => _handlePageChange(1)),
          children: [I(className: '$firstLabel $_iconSize', children: [])],
        ),
      );
    }

    // Previous button
    if (showPrevNext) {
      children.add(
        Button(
          type: 'button',
          className: cx([
            _navButtonClasses,
            if (currentPage <= 1) 'opacity-50 cursor-not-allowed',
          ]),
          attributes: currentPage <= 1 ? {'disabled': 'true'} : null,
          events: events(onClick: () => _handlePageChange(currentPage - 1)),
          children: [I(className: '$prevLabel $_iconSize', children: [])],
        ),
      );
    }

    // Page numbers
    for (final page in _pageNumbers) {
      if (page == null) {
        // Ellipsis
        children.add(
          Span(
            className:
                '$_sizeClasses inline-flex items-center justify-center ${DTextColors.muted}',
            children: [Text('...')],
          ),
        );
      } else {
        final isActive = page == currentPage;
        children.add(
          Button(
            type: 'button',
            className: _buttonClasses(isActive),
            events: events(onClick: () => _handlePageChange(page)),
            children: [Text('$page')],
          ),
        );
      }
    }

    // Next button
    if (showPrevNext) {
      children.add(
        Button(
          type: 'button',
          className: cx([
            _navButtonClasses,
            if (currentPage >= totalPages) 'opacity-50 cursor-not-allowed',
          ]),
          attributes: currentPage >= totalPages ? {'disabled': 'true'} : null,
          events: events(onClick: () => _handlePageChange(currentPage + 1)),
          children: [I(className: '$nextLabel $_iconSize', children: [])],
        ),
      );
    }

    // Last button
    if (showFirstLast) {
      children.add(
        Button(
          type: 'button',
          className: cx([
            _navButtonClasses,
            if (currentPage >= totalPages) 'opacity-50 cursor-not-allowed',
          ]),
          attributes: currentPage >= totalPages ? {'disabled': 'true'} : null,
          events: events(onClick: () => _handlePageChange(totalPages)),
          children: [I(className: '$lastLabel $_iconSize', children: [])],
        ),
      );
    }

    return Nav(
      className: 'inline-flex items-center gap-1',
      children: [
        Ul(className: 'flex items-center gap-1', children: [
          for (final child in children) Li(children: [child]),
        ]),
      ],
    );
  }
}

/// Simple pagination with only prev/next buttons and page info
class DPaginationSimple extends StatelessComponent {
  /// Current page (1-indexed)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Callback when page changes
  final void Function(int page)? onPageChange;

  /// Size
  final DSize size;

  /// Whether pagination is disabled
  final bool disabled;

  const DPaginationSimple({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChange,
    this.size = DSize.sm,
    this.disabled = false,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'inline-flex items-center gap-2',
      children: [
        Button(
          type: 'button',
          className: cx([
            'px-3 py-1.5 text-sm rounded-md transition-colors',
            'bg-gray-100 dark:bg-zinc-800 text-gray-700 dark:text-gray-300',
            if (currentPage <= 1 || disabled) 'opacity-50 cursor-not-allowed',
            if (currentPage > 1 && !disabled)
              'hover:bg-gray-200 dark:hover:bg-gray-700',
          ]),
          attributes:
              currentPage <= 1 || disabled ? {'disabled': 'true'} : null,
          events: events(onClick: () {
            if (!disabled && onPageChange != null && currentPage > 1) {
              onPageChange!(currentPage - 1);
            }
          }),
          children: [Text('Previous')],
        ),
        Span(
          className: 'text-sm ${DTextColors.muted}',
          children: [Text('Page $currentPage of $totalPages')],
        ),
        Button(
          type: 'button',
          className: cx([
            'px-3 py-1.5 text-sm rounded-md transition-colors',
            'bg-gray-100 dark:bg-zinc-800 text-gray-700 dark:text-gray-300',
            if (currentPage >= totalPages || disabled)
              'opacity-50 cursor-not-allowed',
            if (currentPage < totalPages && !disabled)
              'hover:bg-gray-200 dark:hover:bg-gray-700',
          ]),
          attributes: currentPage >= totalPages || disabled
              ? {'disabled': 'true'}
              : null,
          events: events(onClick: () {
            if (!disabled && onPageChange != null && currentPage < totalPages) {
              onPageChange!(currentPage + 1);
            }
          }),
          children: [Text('Next')],
        ),
      ],
    );
  }
}
