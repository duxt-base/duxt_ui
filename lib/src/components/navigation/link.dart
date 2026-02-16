import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Link color variants
enum DLinkColor { primary, neutral, inherit }

/// DuxtUI Link component - styled anchor
class DLink extends StatelessComponent {
  final String? label;
  final String href;
  final bool external;
  final bool active;
  final bool disabled;
  final DLinkColor color;
  final bool underline;
  final Component? icon;
  final Component? trailingIcon;
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DLink({
    super.key,
    this.label,
    required this.href,
    this.external = false,
    this.active = false,
    this.disabled = false,
    this.color = DLinkColor.primary,
    this.underline = false,
    this.icon,
    this.trailingIcon,
    this.children = const [],
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _colorClasses {
    switch (color) {
      case DLinkColor.primary:
        return active
            ? 'text-primary-600 dark:text-primary-400'
            : 'text-primary-500 dark:text-primary-400 hover:text-primary-600 dark:hover:text-primary-300';
      case DLinkColor.neutral:
        return active
            ? 'text-gray-900 dark:text-white'
            : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white';
      case DLinkColor.inherit:
        return 'text-inherit hover:opacity-80';
    }
  }

  @override
  Component build(BuildContext context) {
    final baseClasses =
        'inline-flex items-center gap-1 font-medium transition-colors';
    final underlineClasses = underline
        ? 'underline underline-offset-4'
        : 'hover:underline hover:underline-offset-4';
    final disabledClasses =
        disabled ? 'opacity-50 cursor-not-allowed pointer-events-none' : '';

    final baseAttributes = external ? {'rel': 'noopener noreferrer'} : <String, String>{};
    final mergedAttributes = {...baseAttributes, ...?attributes};

    return A(
      href: href,
      id: id,
      target: external ? Target.blank : null,
      attributes: mergedAttributes.isNotEmpty ? mergedAttributes : null,
      events: events,
      className: twMerge(
          '$baseClasses $_colorClasses $underlineClasses $disabledClasses',
          className),
      children: [
        if (icon != null) icon!,
        if (label != null) Text(label!),
        ...children,
        if (trailingIcon != null) trailingIcon!,
        if (external && trailingIcon == null)
          Span(
            className: 'text-xs',
            children: [Text('\u2197')], // External link arrow
          ),
      ],
    );
  }
}

/// DuxtUI NavLink component - navigation-specific link styling
class DNavLink extends StatelessComponent {
  final String label;
  final String href;
  final bool active;
  final bool exact;
  final Component? icon;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DNavLink({
    super.key,
    required this.label,
    required this.href,
    this.active = false,
    this.exact = false,
    this.icon,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final baseClasses =
        'inline-flex items-center gap-2 px-3 py-2 text-sm font-medium rounded-md transition-colors';
    final stateClasses = active
        ? 'text-gray-900 dark:text-white bg-gray-100 dark:bg-zinc-800'
        : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-gray-50 dark:hover:bg-gray-800/50';

    return A(
      href: href,
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('$baseClasses $stateClasses', className),
      children: [
        if (icon != null) icon!,
        Text(label),
      ],
    );
  }
}

/// DuxtUI SocialLink component - for social media links
class DSocialLink extends StatelessComponent {
  final String href;
  final Component icon;
  final String? label;
  final String? ariaLabel;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSocialLink({
    super.key,
    required this.href,
    required this.icon,
    this.label,
    this.ariaLabel,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final baseAttributes = {
      'rel': 'noopener noreferrer',
      if (ariaLabel != null) 'aria-label': ariaLabel!,
    };
    final mergedAttributes = {...baseAttributes, ...?attributes};

    return A(
      href: href,
      id: id,
      target: Target.blank,
      events: events,
      className: twMerge(
          'inline-flex items-center gap-2 text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors',
          className),
      attributes: mergedAttributes,
      children: [
        icon,
        if (label != null) Span(className: 'sr-only', children: [Text(label!)]),
      ],
    );
  }
}
