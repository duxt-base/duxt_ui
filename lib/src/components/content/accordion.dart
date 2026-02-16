import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';

/// Accordion item configuration
class DAccordionItem {
  final String label;
  final String? description;
  final Component? icon;
  final bool disabled;
  final Component content;
  final String? value;
  final bool defaultOpen;

  const DAccordionItem({
    required this.label,
    required this.content,
    this.description,
    this.icon,
    this.disabled = false,
    this.value,
    this.defaultOpen = false,
  });
}

/// Accordion variants
enum DAccordionVariant { soft, ghost }

/// DuxtUI Accordion component using native HTML details/summary
///
/// Uses native `<details>` and `<summary>` elements for accessibility
/// and interactivity without JavaScript.
class DAccordion extends StatelessComponent {
  final List<DAccordionItem> items;
  final String? defaultValue;
  final DColor color;
  final DAccordionVariant variant;
  final DSize size;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DAccordion({
    super.key,
    required this.items,
    this.defaultValue,
    this.color = DColor.primary,
    this.variant = DAccordionVariant.soft,
    this.size = DSize.md,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DSize.xs:
        return 'text-xs';
      case DSize.sm:
        return 'text-sm';
      case DSize.md:
        return 'text-sm';
      case DSize.lg:
        return 'text-base';
      case DSize.xl:
        return 'text-lg';
    }
  }

  String get _paddingClasses {
    switch (size) {
      case DSize.xs:
        return 'px-2.5 py-1.5';
      case DSize.sm:
        return 'px-3 py-2';
      case DSize.md:
        return 'px-4 py-3';
      case DSize.lg:
        return 'px-4 py-3.5';
      case DSize.xl:
        return 'px-5 py-4';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(cx([
        'divide-y',
        DDivideColors.defaultDivide,
        'rounded-lg',
        'ring-1',
        DRingColors.defaultRing,
      ]), className),
      children: [
        for (int i = 0; i < items.length; i++) _buildItem(items[i], i),
      ],
    );
  }

  Component _buildItem(DAccordionItem item, int index) {
    final value = item.value ?? 'item-$index';
    final isOpen = item.defaultOpen || defaultValue == value;
    final isFirst = index == 0;
    final isLast = index == items.length - 1;

    return Details(
      className: cx([
        'group',
        isFirst ? 'rounded-t-lg' : null,
        isLast ? 'rounded-b-lg' : null,
      ]),
      attributes: {
        if (isOpen) 'open': 'true',
        'name': 'accordion_$hashCode', // Groups accordions to close others when one opens
      },
      children: [
        // Summary (clickable header)
        Summary(
          className: cx([
            'flex items-center justify-between',
            _paddingClasses,
            _sizeClasses,
            'font-medium',
            DTextColors.highlighted,
            'hover:bg-gray-50 dark:hover:bg-gray-800/50',
            'transition-colors',
            'cursor-pointer',
            'list-none', // Remove default marker
            '[&::-webkit-details-marker]:hidden', // Hide marker in webkit
            isFirst ? 'rounded-t-lg' : null,
            'group-open:rounded-b-none',
            isLast ? 'group-[[open]]:rounded-b-none rounded-b-lg' : null,
          ]),
          children: [
            Div(className: 'flex items-center gap-2', children: [
              if (item.icon != null) item.icon!,
              Div(children: [
                Span(children: [Text(item.label)]),
                if (item.description != null)
                  P(
                      className: cx(
                          ['font-normal', DTextColors.muted, 'text-xs mt-0.5']),
                      children: [
                        Text(item.description!),
                      ]),
              ]),
            ]),
            // Chevron icon - rotates when open
            Span(
              className: cx([
                'transform transition-transform duration-200',
                'group-open:rotate-180',
              ]),
              children: [Text('\u25BC')], // Down arrow
            ),
          ],
        ),
        // Content
        Div(
          className: cx([
            _paddingClasses,
            'pt-0',
            DTextColors.defaultText,
            _sizeClasses,
            isLast ? 'rounded-b-lg' : null,
          ]),
          children: [item.content],
        ),
      ],
    );
  }
}
