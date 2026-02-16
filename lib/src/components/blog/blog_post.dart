import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' as dom;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Author information for blog posts
class DBlogAuthor {
  final String name;
  final String? avatar;
  final String? role;

  const DBlogAuthor({
    required this.name,
    this.avatar,
    this.role,
  });
}

/// Blog post orientation
enum DBlogPostOrientation { vertical, horizontal }

/// DuxtUI BlogPost component - Article card
///
/// Displays a blog post preview with image, title, excerpt, author, and date.
class DBlogPost extends StatelessComponent {
  /// The post title
  final String title;

  /// Post excerpt/description
  final String? excerpt;

  /// Featured image DRL
  final String? image;

  /// Image alt text
  final String? imageAlt;

  /// Author information
  final DBlogAuthor? author;

  /// Publication date string
  final String? date;

  /// Post category or tag
  final String? category;

  /// Category badge color
  final String? categoryColor;

  /// Reading time (e.g., "5 min read")
  final String? readingTime;

  /// Link DRL for the post
  final String? href;

  /// Layout orientation
  final DBlogPostOrientation orientation;

  /// Additional CSS classes
  final String? className;

  /// Click handler
  final VoidCallback? onClick;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DBlogPost({
    super.key,
    required this.title,
    this.excerpt,
    this.image,
    this.imageAlt,
    this.author,
    this.date,
    this.category,
    this.categoryColor,
    this.readingTime,
    this.href,
    this.orientation = DBlogPostOrientation.vertical,
    this.className,
    this.onClick,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final isHorizontal = orientation == DBlogPostOrientation.horizontal;

    final imageComponent = image != null
        ? Div(
            className: isHorizontal ? 'flex-shrink-0 w-48 md:w-64' : 'w-full',
            children: [
              Img(
                src: image!,
                alt: imageAlt ?? title,
                className:
                    'aspect-video w-full rounded-lg object-cover transition-transform duration-300 group-hover:scale-105',
              ),
            ],
          )
        : null;

    final categoryBadge = category != null
        ? Span(
            className:
                'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${categoryColor ?? "bg-primary-100 text-primary-700 dark:bg-primary-900 dark:text-primary-300"}',
            children: [Text(category!)],
          )
        : null;

    final titleComponent = H3(
      className:
          'text-lg font-semibold text-gray-900 dark:text-white group-hover:text-primary-500 dark:group-hover:text-primary-400 transition-colors line-clamp-2',
      children: [Text(title)],
    );

    final excerptComponent = excerpt != null
        ? P(
            className:
                'mt-2 text-sm text-gray-600 dark:text-gray-400 line-clamp-2',
            children: [Text(excerpt!)],
          )
        : null;

    final metaComponent = Div(
      className: 'mt-4 flex items-center gap-3',
      children: [
        if (author != null) ...[
          if (author!.avatar != null)
            Img(
              src: author!.avatar!,
              alt: author!.name,
              className: 'h-8 w-8 rounded-full object-cover',
            )
          else
            Div(
              className:
                  'h-8 w-8 rounded-full bg-gray-200 dark:bg-zinc-700 flex items-center justify-center text-sm font-medium text-gray-600 dark:text-gray-300',
              children: [
                Text(author!.name.isNotEmpty
                    ? author!.name[0].toUpperCase()
                    : '?')
              ],
            ),
          Div(children: [
            P(
              className: 'text-sm font-medium text-gray-900 dark:text-white',
              children: [Text(author!.name)],
            ),
            if (author!.role != null)
              P(
                className: 'text-xs text-gray-500 dark:text-gray-400',
                children: [Text(author!.role!)],
              ),
          ]),
        ],
        if (date != null || readingTime != null)
          Div(
            className:
                'flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400 ${author != null ? "ml-auto" : ""}',
            children: [
              if (date != null) Span(children: [Text(date!)]),
              if (date != null && readingTime != null)
                Span(
                    className: 'text-gray-300 dark:text-gray-600',
                    children: [Text('|')]),
              if (readingTime != null) Span(children: [Text(readingTime!)]),
            ],
          ),
      ],
    );

    final content = Div(
      className: isHorizontal ? 'flex-1 min-w-0' : '',
      children: [
        if (categoryBadge != null) Div(className: 'mb-2', children: [categoryBadge]),
        titleComponent,
        if (excerptComponent != null) excerptComponent,
        metaComponent,
      ],
    );

    final cardClasses = twMerge([
      'group',
      'flex',
      isHorizontal ? 'flex-row gap-6' : 'flex-col',
      'cursor-pointer',
    ].join(' '), className);

    final cardContent = [
      if (imageComponent != null) imageComponent,
      content,
    ];

    if (href != null) {
      return A(
        href: href!,
        id: id,
        className: cardClasses,
        attributes: attributes,
        events: this.events,
        children: cardContent,
      );
    }

    return Div(
      id: id,
      className: cardClasses,
      attributes: attributes,
      events: this.events ?? (onClick != null ? dom.events(onClick: onClick!) : null),
      children: cardContent,
    );
  }
}
