import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' as dom;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';
import 'pricing_plan.dart';

/// Grid column configuration for pricing plans
enum DPricingPlansColumns { two, three, four }

/// DuxtUI PricingPlans component - Grid of pricing plan cards
///
/// Displays a responsive grid of DPricingPlan components.
/// Typically used for side-by-side plan comparison.
class DPricingPlans extends StatelessComponent {
  /// List of pricing plans
  final List<DPricingPlan> plans;

  /// Number of columns at large breakpoint
  final DPricingPlansColumns columns;

  /// Gap between plans
  final String gap;

  /// Additional CSS classes
  final String? className;

  /// Optional title for the section
  final String? title;

  /// Optional description for the section
  final String? description;

  /// Whether to center the grid when fewer plans than columns
  final bool centerWhenFewer;

  /// Billing toggle component (monthly/yearly)
  final Component? billingToggle;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPricingPlans({
    super.key,
    required this.plans,
    this.columns = DPricingPlansColumns.three,
    this.gap = 'gap-8',
    this.className,
    this.title,
    this.description,
    this.centerWhenFewer = true,
    this.billingToggle,
    this.id,
    this.attributes,
    this.events,
  });

  String get _columnClasses {
    switch (columns) {
      case DPricingPlansColumns.two:
        return 'grid-cols-1 md:grid-cols-2';
      case DPricingPlansColumns.three:
        return 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3';
      case DPricingPlansColumns.four:
        return 'grid-cols-1 md:grid-cols-2 lg:grid-cols-4';
    }
  }

  @override
  Component build(BuildContext context) {
    final hasHeader =
        title != null || description != null || billingToggle != null;

    return Div(
      id: id,
      className: className,
      attributes: attributes,
      events: events,
      children: [
        if (hasHeader) _buildHeader(),
        Div(
          className:
              'grid $_columnClasses $gap items-start ${centerWhenFewer ? "justify-center" : ""}',
          children: plans,
        ),
      ],
    );
  }

  Component _buildHeader() {
    return Div(
      className: 'text-center mb-12',
      children: [
        if (title != null)
          H2(
            className:
                'text-3xl font-bold text-gray-900 dark:text-white sm:text-4xl',
            children: [Text(title!)],
          ),
        if (description != null)
          P(
            className:
                'mt-4 text-lg text-gray-600 dark:text-gray-400 max-w-2xl mx-auto',
            children: [Text(description!)],
          ),
        if (billingToggle != null) Div(className: 'mt-8', children: [billingToggle!]),
      ],
    );
  }
}

/// Billing toggle component for switching between monthly/yearly pricing
class DBillingToggle extends StatelessComponent {
  /// Currently selected option (true = yearly, false = monthly)
  final bool isYearly;

  /// Monthly label
  final String monthlyLabel;

  /// Yearly label
  final String yearlyLabel;

  /// Savings badge text for yearly (e.g., "Save 20%")
  final String? yearlySavings;

  /// Change callback
  final void Function(bool isYearly)? onChange;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DBillingToggle({
    super.key,
    required this.isYearly,
    this.monthlyLabel = 'Monthly',
    this.yearlyLabel = 'Yearly',
    this.yearlySavings,
    this.onChange,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge(
          'inline-flex items-center gap-3 p-1 bg-gray-100 dark:bg-zinc-800 rounded-lg',
          className),
      attributes: attributes,
      events: this.events,
      children: [
        // Monthly button
        Button(
          type: 'button',
          className:
              'px-4 py-2 text-sm font-medium rounded-md transition-colors ${!isYearly ? "bg-white dark:bg-zinc-700 text-gray-900 dark:text-white shadow-sm" : "text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white"}',
          events: dom.events(onClick: () => onChange?.call(false)),
          children: [Text(monthlyLabel)],
        ),
        // Yearly button
        Button(
          type: 'button',
          className:
              'px-4 py-2 text-sm font-medium rounded-md transition-colors flex items-center gap-2 ${isYearly ? "bg-white dark:bg-zinc-700 text-gray-900 dark:text-white shadow-sm" : "text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white"}',
          events: dom.events(onClick: () => onChange?.call(true)),
          children: [
            Text(yearlyLabel),
            if (yearlySavings != null)
              Span(
                className:
                    'inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-cyan-100 text-cyan-700 dark:bg-cyan-900 dark:text-cyan-300',
                children: [Text(yearlySavings!)],
              ),
          ],
        ),
      ],
    );
  }
}
