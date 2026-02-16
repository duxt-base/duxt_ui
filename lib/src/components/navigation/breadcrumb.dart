import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Breadcrumb separator style
enum DBreadcrumbSeparator { slash, chevron, arrow, dot }

/// DuxtUI Breadcrumb component
class DBreadcrumb extends StatelessComponent {
  final List<DBreadcrumbItem> items;
  final DBreadcrumbSeparator separator;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBreadcrumb({
    super.key,
    required this.items,
    this.separator = DBreadcrumbSeparator.chevron,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _separatorChar {
    switch (separator) {
      case DBreadcrumbSeparator.slash:
        return '/';
      case DBreadcrumbSeparator.chevron:
        return '\u203A'; // Unicode single right-pointing angle quotation mark
      case DBreadcrumbSeparator.arrow:
        return '\u2192'; // Unicode rightwards arrow
      case DBreadcrumbSeparator.dot:
        return '\u2022'; // Unicode bullet
    }
  }

  @override
  Component build(BuildContext context) {
    final List<Component> breadcrumbItems = [];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      breadcrumbItems.add(
        Li(
          className: 'flex items-center',
          children: [
            if (isLast)
              Span(
                className: 'text-sm font-medium text-gray-500 dark:text-gray-400',
                children: [
                  if (item.icon != null) item.icon!,
                  Text(item.label),
                ],
              )
            else
              A(
                href: item.href ?? '#',
                className:
                    'text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors',
                children: [
                  if (item.icon != null) item.icon!,
                  Text(item.label),
                ],
              ),
            if (!isLast)
              Span(
                className: 'mx-2 text-gray-400 dark:text-gray-600 select-none',
                children: [Text(_separatorChar)],
              ),
          ],
        ),
      );
    }

    final baseAttributes = {'aria-label': 'Breadcrumb'};
    final mergedAttributes = {...baseAttributes, ...?attributes};

    return Nav(
      id: id,
      attributes: mergedAttributes,
      events: events,
      className: twMerge('', className),
      children: [
        Ol(
          className: 'flex items-center gap-2 text-sm',
          children: breadcrumbItems,
        ),
      ],
    );
  }
}

/// Breadcrumb item data
class DBreadcrumbItem extends StatelessComponent {
  final String label;
  final String? href;
  final Component? icon;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBreadcrumbItem({
    super.key,
    required this.label,
    this.href,
    this.icon,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    // This is mainly used as a data holder, but can render standalone
    if (href != null) {
      return A(
        href: href!,
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge(
            'text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors',
            className),
        children: [
          if (icon != null) icon!,
          Text(label),
        ],
      );
    }
    return Span(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('text-sm font-medium text-gray-500 dark:text-gray-400', className),
      children: [
        if (icon != null) icon!,
        Text(label),
      ],
    );
  }
}
