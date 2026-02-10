import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show events;
import 'package:duxt_html/duxt_html.dart';
import 'package:duxt_icons/duxt_icons.dart' as duxt_icons;

/// Feature item for pricing plan
class DPricingFeature {
  final String text;
  final bool included;
  final String? tooltip;

  const DPricingFeature({
    required this.text,
    this.included = true,
    this.tooltip,
  });
}

/// DuxtUI PricingPlan component - Single pricing plan card
///
/// Displays a pricing plan with name, description, price, features, and CTA.
/// Supports highlighting for popular/recommended plans.
class DPricingPlan extends StatelessComponent {
  /// Plan name
  final String name;

  /// Plan description
  final String? description;

  /// Price amount (e.g., "29", "99")
  final String price;

  /// Price currency symbol
  final String currency;

  /// Billing period (e.g., "/month", "/year")
  final String? period;

  /// Original price for showing discounts
  final String? originalPrice;

  /// Badge text (e.g., "Popular", "Best Value")
  final String? badge;

  /// Badge color classes
  final String? badgeColor;

  /// List of features
  final List<DPricingFeature> features;

  /// CTA button text
  final String buttonText;

  /// CTA button variant
  final String? buttonVariant;

  /// Button click handler
  final VoidCallback? onButtonClick;

  /// Button href for link
  final String? buttonHref;

  /// Whether this plan is highlighted
  final bool highlighted;

  /// Whether this plan is disabled
  final bool disabled;

  /// Additional CSS classes
  final String? classes;

  /// Custom header content
  final Component? header;

  /// Custom footer content
  final Component? footer;

  const DPricingPlan({
    super.key,
    required this.name,
    this.description,
    required this.price,
    this.currency = '\$',
    this.period,
    this.originalPrice,
    this.badge,
    this.badgeColor,
    required this.features,
    this.buttonText = 'Get started',
    this.buttonVariant,
    this.onButtonClick,
    this.buttonHref,
    this.highlighted = false,
    this.disabled = false,
    this.classes,
    this.header,
    this.footer,
  });

  @override
  Component build(BuildContext context) {
    final baseClasses = [
      'relative',
      'flex',
      'flex-col',
      'p-6',
      'lg:p-8',
      'rounded-2xl',
      'bg-white',
      'dark:bg-zinc-800',
      'border',
      highlighted
          ? 'ring-2 ring-primary-500 border-primary-500 scale-105 shadow-xl z-10'
          : 'border-gray-200 dark:border-gray-700 shadow-sm',
      'transition-all',
      'duration-200',
      disabled ? 'opacity-60' : 'hover:shadow-lg',
      classes ?? '',
    ].where((c) => c.isNotEmpty).join(' ');

    return Div(
      className: baseClasses,
      children: [
        // Badge
        if (badge != null)
          Div(
            className: 'absolute -top-3 left-1/2 -translate-x-1/2',
            children: [
              Span(
                className:
                    'inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold ${badgeColor ?? "bg-primary-500 text-white"}',
                children: [Text(badge!)],
              ),
            ],
          ),

        // Custom header or default header
        if (header != null) header! else _buildDefaultHeader(),

        // Features list
        Div(
          className: 'flex-1 mt-6',
          children: [
            Ul(
              className: 'space-y-3',
              children: [
                for (final feature in features) _buildFeatureItem(feature),
              ],
            ),
          ],
        ),

        // CTA Button
        Div(
          className: 'mt-8',
          children: [
            _buildButton(),
          ],
        ),

        // Custom footer
        if (footer != null) Div(className: 'mt-4', children: [footer!]),
      ],
    );
  }

  Component _buildDefaultHeader() {
    return Div(children: [
      // Plan name
      H3(
        className: 'text-lg font-semibold text-gray-900 dark:text-white',
        children: [Text(name)],
      ),

      // Description
      if (description != null)
        P(
          className: 'mt-2 text-sm text-gray-500 dark:text-gray-400',
          children: [Text(description!)],
        ),

      // Price
      Div(
        className: 'mt-4 flex items-baseline gap-1',
        children: [
          // Original price (strikethrough)
          if (originalPrice != null)
            Span(
              className: 'text-lg text-gray-400 line-through mr-2',
              children: [Text('$currency$originalPrice')],
            ),
          // Currency
          Span(
            className: 'text-2xl font-semibold text-gray-900 dark:text-white',
            children: [Text(currency)],
          ),
          // Price amount
          Span(
            className:
                'text-4xl font-bold tracking-tight text-gray-900 dark:text-white',
            children: [Text(price)],
          ),
          // Period
          if (period != null)
            Span(
              className: 'text-sm text-gray-500 dark:text-gray-400',
              children: [Text(period!)],
            ),
        ],
      ),
    ]);
  }

  Component _buildFeatureItem(DPricingFeature feature) {
    final iconClasses = feature.included
        ? 'text-primary-500'
        : 'text-gray-300 dark:text-gray-600';

    final textClasses = feature.included
        ? 'text-gray-700 dark:text-gray-300'
        : 'text-gray-400 dark:text-gray-500 line-through';

    return Li(
      className: 'flex items-start gap-3',
      children: [
        // Checkmark or X icon
        Span(
          className: 'flex-shrink-0 mt-0.5 $iconClasses',
          children: [
            if (feature.included)
              duxt_icons.Icon('lucide:check', size: 20, className: 'h-5 w-5')
            else
              duxt_icons.Icon('lucide:x', size: 20, className: 'h-5 w-5'),
          ],
        ),
        // Feature text
        Span(
          className: 'text-sm $textClasses',
          children: [Text(feature.text)],
        ),
      ],
    );
  }

  Component _buildButton() {
    final buttonClasses = highlighted
        ? 'w-full py-3 px-4 rounded-lg font-semibold text-center transition-colors bg-primary-600 text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2'
        : 'w-full py-3 px-4 rounded-lg font-semibold text-center transition-colors bg-gray-100 text-gray-900 hover:bg-gray-200 dark:bg-zinc-700 dark:text-white dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2';

    final disabledClasses = disabled ? ' opacity-50 cursor-not-allowed' : '';

    if (buttonHref != null && !disabled) {
      return A(
        href: buttonHref!,
        className: buttonClasses,
        children: [Text(buttonText)],
      );
    }

    return Button(
      type: 'button',
      disabled: disabled,
      className: '$buttonClasses$disabledClasses',
      events: !disabled && onButtonClick != null
          ? events(onClick: () => onButtonClick!())
          : null,
      children: [Text(buttonText)],
    );
  }
}
