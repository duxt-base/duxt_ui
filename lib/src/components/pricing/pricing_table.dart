import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' as dom;
import 'package:duxt_html/duxt_html.dart';
import 'package:duxt_icons/duxt_icons.dart' as duxt_icons;
import '../../theme/tw_merge.dart';

/// A plan column in the pricing table
class DPricingTablePlan {
  /// Plan name
  final String name;

  /// Price display
  final String price;

  /// Price period
  final String? period;

  /// Badge text
  final String? badge;

  /// Whether this plan is highlighted
  final bool highlighted;

  /// CTA button text
  final String buttonText;

  /// Button href
  final String? buttonHref;

  /// Button click handler
  final VoidCallback? onButtonClick;

  const DPricingTablePlan({
    required this.name,
    required this.price,
    this.period,
    this.badge,
    this.highlighted = false,
    this.buttonText = 'Choose plan',
    this.buttonHref,
    this.onButtonClick,
  });
}

/// A feature row in the pricing table
class DPricingTableFeature {
  /// Feature name
  final String name;

  /// Feature description/tooltip
  final String? description;

  /// Values for each plan (can be bool, String, or Component)
  final List<dynamic> values;

  const DPricingTableFeature({
    required this.name,
    this.description,
    required this.values,
  });
}

/// Feature category/group
class DPricingTableCategory {
  /// Category name
  final String name;

  /// Features in this category
  final List<DPricingTableFeature> features;

  const DPricingTableCategory({
    required this.name,
    required this.features,
  });
}

/// DuxtUI PricingTable component - Feature comparison table
///
/// Displays a detailed feature comparison table with plans as columns
/// and features as rows. Supports categories, checkmarks, and custom values.
class DPricingTable extends StatelessComponent {
  /// List of plans (columns)
  final List<DPricingTablePlan> plans;

  /// List of feature categories
  final List<DPricingTableCategory> categories;

  /// Optional ungrouped features (shown at top if no categories)
  final List<DPricingTableFeature> features;

  /// Additional CSS classes
  final String? className;

  /// Whether to show plan headers as sticky
  final bool stickyHeaders;

  /// Whether to make table horizontally scrollable on mobile
  final bool scrollable;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DPricingTable({
    super.key,
    required this.plans,
    this.categories = const [],
    this.features = const [],
    this.className,
    this.stickyHeaders = true,
    this.scrollable = true,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge(scrollable ? 'overflow-x-auto' : '', className),
      attributes: attributes,
      events: events,
      children: [
        Table(
          className: 'w-full border-collapse',
          children: [
            // Table header with plans
            Thead(children: [
              Tr(
                className: stickyHeaders ? 'sticky top-0 z-10' : '',
                children: [
                  // Empty cell for feature column
                  Th(
                    className: 'bg-white dark:bg-zinc-900 px-6 py-4 text-left',
                    children: [],
                  ),
                  // Plan columns
                  for (final plan in plans) _buildPlanHeader(plan),
                ],
              ),
            ]),
            // Table body with features
            Tbody(children: [
              // Ungrouped features
              if (features.isNotEmpty)
                for (final feature in features) _buildFeatureRow(feature),
              // Categorized features
              for (final category in categories) ...[
                _buildCategoryRow(category),
                for (final feature in category.features)
                  _buildFeatureRow(feature),
              ],
            ]),
            // Table footer with CTA buttons
            Tfoot(children: [
              Tr(children: [
                Td(className: 'px-6 py-6', children: []),
                for (final plan in plans) _buildPlanFooter(plan),
              ]),
            ]),
          ],
        ),
      ],
    );
  }

  Component _buildPlanHeader(DPricingTablePlan plan) {
    final bgClass = plan.highlighted
        ? 'bg-primary-50 dark:bg-primary-900/20'
        : 'bg-gray-50 dark:bg-zinc-800';

    return Th(
      className: 'px-6 py-6 text-center $bgClass relative',
      children: [
        // Badge
        if (plan.badge != null)
          Div(
            className: 'absolute -top-3 left-1/2 -translate-x-1/2',
            children: [
              Span(
                className:
                    'inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-primary-500 text-white',
                children: [Text(plan.badge!)],
              ),
            ],
          ),
        // Plan name
        Div(
          className: 'text-lg font-semibold text-gray-900 dark:text-white',
          children: [Text(plan.name)],
        ),
        // Price
        Div(
          className: 'mt-2 flex items-baseline justify-center gap-1',
          children: [
            Span(
              className: 'text-3xl font-bold text-gray-900 dark:text-white',
              children: [Text(plan.price)],
            ),
            if (plan.period != null)
              Span(
                className: 'text-sm text-gray-500 dark:text-gray-400',
                children: [Text(plan.period!)],
              ),
          ],
        ),
      ],
    );
  }

  Component _buildCategoryRow(DPricingTableCategory category) {
    return Tr(
      className: 'border-t border-gray-200 dark:border-gray-700',
      children: [
        Td(
          attributes: {'colspan': (plans.length + 1).toString()},
          className: 'px-6 py-4 bg-gray-50 dark:bg-zinc-800/50',
          children: [
            Span(
              className:
                  'text-sm font-semibold text-gray-900 dark:text-white uppercase tracking-wider',
              children: [Text(category.name)],
            ),
          ],
        ),
      ],
    );
  }

  Component _buildFeatureRow(DPricingTableFeature feature) {
    return Tr(
      className:
          'border-t border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800/50',
      children: [
        // Feature name
        Td(
          className: 'px-6 py-4',
          children: [
            Div(
              className: 'text-sm font-medium text-gray-900 dark:text-white',
              children: [Text(feature.name)],
            ),
            if (feature.description != null)
              Div(
                className: 'text-xs text-gray-500 dark:text-gray-400 mt-0.5',
                children: [Text(feature.description!)],
              ),
          ],
        ),
        // Values for each plan
        for (var i = 0; i < plans.length; i++)
          _buildFeatureValue(
            i < feature.values.length ? feature.values[i] : null,
            plans[i].highlighted,
          ),
      ],
    );
  }

  Component _buildFeatureValue(dynamic value, bool highlighted) {
    final bgClass =
        highlighted ? 'bg-primary-50/50 dark:bg-primary-900/10' : '';

    if (value == null) {
      return Td(
        className: 'px-6 py-4 text-center $bgClass',
        children: [
          Span(
            className: 'text-gray-300 dark:text-gray-600',
            children: [Text('-')],
          ),
        ],
      );
    }

    if (value is bool) {
      return Td(
        className: 'px-6 py-4 text-center $bgClass',
        children: [
          if (value)
            Span(
              className: 'text-primary-500',
              children: [
                duxt_icons.Icon('lucide:check', size: 20, className: 'h-5 w-5 mx-auto'),
              ],
            )
          else
            Span(
              className: 'text-gray-300 dark:text-gray-600',
              children: [
                duxt_icons.Icon('lucide:x', size: 20, className: 'h-5 w-5 mx-auto'),
              ],
            ),
        ],
      );
    }

    if (value is String) {
      return Td(
        className: 'px-6 py-4 text-center $bgClass',
        children: [
          Span(
            className: 'text-sm text-gray-900 dark:text-white',
            children: [Text(value)],
          ),
        ],
      );
    }

    if (value is Component) {
      return Td(
        className: 'px-6 py-4 text-center $bgClass',
        children: [value],
      );
    }

    return Td(
      className: 'px-6 py-4 text-center $bgClass',
      children: [Text(value.toString())],
    );
  }

  Component _buildPlanFooter(DPricingTablePlan plan) {
    final bgClass =
        plan.highlighted ? 'bg-primary-50/50 dark:bg-primary-900/10' : '';

    final buttonClasses = plan.highlighted
        ? 'w-full py-2.5 px-4 rounded-lg font-semibold text-sm text-center transition-colors bg-primary-600 text-white hover:bg-primary-700'
        : 'w-full py-2.5 px-4 rounded-lg font-semibold text-sm text-center transition-colors bg-gray-100 text-gray-900 hover:bg-gray-200 dark:bg-zinc-700 dark:text-white dark:hover:bg-gray-600';

    return Td(
      className: 'px-6 py-6 $bgClass',
      children: [
        if (plan.buttonHref != null)
          A(
            href: plan.buttonHref!,
            className: buttonClasses,
            children: [Text(plan.buttonText)],
          )
        else
          Button(
            type: 'button',
            className: buttonClasses,
            events: plan.onButtonClick != null
                ? dom.events(onClick: () => plan.onButtonClick!())
                : null,
            children: [Text(plan.buttonText)],
          ),
      ],
    );
  }
}
