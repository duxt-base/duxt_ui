import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Header style variants
enum DHeaderVariant { solid, transparent, blur }

/// DuxtUI Header component - sticky header with backdrop blur
class DHeader extends StatelessComponent {
  final List<Component> children;
  final Component? left;
  final Component? center;
  final Component? right;
  final DHeaderVariant variant;
  final bool sticky;
  final bool bordered;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DHeader({
    super.key,
    this.children = const [],
    this.left,
    this.center,
    this.right,
    this.variant = DHeaderVariant.blur,
    this.sticky = true,
    this.bordered = true,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _variantClasses {
    switch (variant) {
      case DHeaderVariant.solid:
        return 'bg-white dark:bg-zinc-900';
      case DHeaderVariant.transparent:
        return 'bg-transparent';
      case DHeaderVariant.blur:
        return 'bg-white/80 dark:bg-zinc-900/80 backdrop-blur-lg backdrop-saturate-150';
    }
  }

  @override
  Component build(BuildContext context) {
    final stickyClasses = sticky ? 'sticky top-0 z-50' : '';
    final borderClasses =
        bordered ? 'border-b border-gray-200 dark:border-gray-800' : '';

    // If left/center/right slots are provided, use structured layout
    if (left != null || center != null || right != null) {
      return Header(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('$stickyClasses $_variantClasses $borderClasses', className),
        children: [
          Div(
            className: 'mx-auto max-w-7xl px-4 sm:px-6 lg:px-8',
            children: [
              Div(
                className: 'flex h-16 items-center justify-between',
                children: [
                  // Left slot
                  Div(
                    className: 'flex items-center gap-4',
                    children: [if (left != null) left!],
                  ),
                  // Center slot
                  if (center != null)
                    Div(
                      className: 'hidden md:flex flex-1 justify-center',
                      children: [center!],
                    ),
                  // Right slot
                  Div(
                    className: 'flex items-center gap-4',
                    children: [if (right != null) right!],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    // Simple header with children
    return Header(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('$stickyClasses $_variantClasses $borderClasses', className),
      children: [
        Div(
          className: 'mx-auto max-w-7xl px-4 sm:px-6 lg:px-8',
          children: [
            Div(
              className: 'flex h-16 items-center',
              children: children,
            ),
          ],
        ),
      ],
    );
  }
}

/// DuxtUI Page Header - header for page content (not sticky nav)
class DPageHeader extends StatelessComponent {
  final String? title;
  final String? description;
  final Component? actions;
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DPageHeader({
    super.key,
    this.title,
    this.description,
    this.actions,
    this.children = const [],
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
      className: twMerge('pb-5 border-b border-gray-200 dark:border-gray-800', className),
      children: [
        Div(
          className: 'sm:flex sm:items-center sm:justify-between',
          children: [
            Div(children: [
              if (title != null)
                H1(
                  className:
                      'text-2xl font-bold text-gray-900 dark:text-white sm:text-3xl',
                  children: [Text(title!)],
                ),
              if (description != null)
                P(
                  className: 'mt-2 text-sm text-gray-500 dark:text-gray-400',
                  children: [Text(description!)],
                ),
              ...children,
            ]),
            if (actions != null)
              Div(
                className: 'mt-4 sm:mt-0 sm:ml-4',
                children: [actions!],
              ),
          ],
        ),
      ],
    );
  }
}
