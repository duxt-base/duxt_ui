import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI Collapsible component using native HTML details/summary
///
/// Uses native `<details>` and `<summary>` elements for accessibility
/// and interactivity without JavaScript.
class DCollapsible extends StatelessComponent {
  final Component trigger;
  final List<Component> children;
  final bool defaultOpen;
  final bool disabled;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DCollapsible({
    super.key,
    required this.trigger,
    required this.children,
    this.defaultOpen = false,
    this.disabled = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final baseAttributes = {
      if (defaultOpen) 'open': 'true',
    };
    final mergedAttributes = {...baseAttributes, ...?attributes};

    return Details(
      id: id,
      events: events,
      className: twMerge(cx([
        'w-full group',
        disabled ? 'pointer-events-none opacity-50' : null,
      ]), className),
      attributes: mergedAttributes.isNotEmpty ? mergedAttributes : null,
      children: [
        // Trigger wrapped in summary
        Summary(
          className: cx([
            'list-none',
            '[&::-webkit-details-marker]:hidden',
            disabled ? 'cursor-not-allowed' : 'cursor-pointer',
          ]),
          children: [trigger],
        ),
        // Content
        Div(
          className: 'overflow-hidden',
          children: children,
        ),
      ],
    );
  }
}

/// Collapsible trigger helper component with chevron
///
/// Use inside DCollapsible's trigger parameter. The chevron automatically
/// rotates when the parent details element is open via CSS group-open.
class DCollapsibleTrigger extends StatelessComponent {
  final String label;
  final Component? icon;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DCollapsibleTrigger({
    super.key,
    required this.label,
    this.icon,
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
      className: twMerge(cx([
        'flex items-center justify-between',
        'px-4 py-3',
        'font-medium',
        DTextColors.highlighted,
        'hover:bg-gray-50 dark:hover:bg-gray-800/50',
        'transition-colors',
        'rounded-lg',
        'select-none',
      ]), className),
      children: [
        Div(className: 'flex items-center gap-2', children: [
          if (icon != null) icon!,
          Span(children: [Text(label)]),
        ]),
        Span(
          className: cx([
            'transform transition-transform duration-200',
            'group-open:rotate-180', // Rotates when details is open
          ]),
          children: [Text('\u25BC')],
        ),
      ],
    );
  }
}

/// Collapsible content wrapper with padding
class DCollapsibleContent extends StatelessComponent {
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DCollapsibleContent({
    super.key,
    required this.children,
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
      className: twMerge(cx([
        'px-4 py-3',
        DTextColors.defaultText,
      ]), className),
      children: children,
    );
  }
}
