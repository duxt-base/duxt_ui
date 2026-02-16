import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';
import 'icon.dart';

/// Stepper orientation
enum DStepperOrientation { horizontal, vertical }

/// Step status
enum DStepStatus { upcoming, current, completed }

/// Step item data
class DStepItem {
  final String title;
  final String? description;
  final Component? icon;

  const DStepItem({
    required this.title,
    this.description,
    this.icon,
  });
}

/// DuxtUI Stepper component - Multi-step progress indicator
///
/// Displays progress through a multi-step process with numbered
/// circles and connecting lines.
class DStepper extends StatelessComponent {
  /// List of steps
  final List<DStepItem> steps;

  /// Current active step index (0-based)
  final int currentStep;

  /// Orientation of the stepper
  final DStepperOrientation orientation;

  /// Whether clicking on steps is allowed
  final bool clickable;

  /// Callback when a step is clicked
  final ValueChanged<int>? onStepClick;

  /// Custom CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DStepper({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.orientation = DStepperOrientation.horizontal,
    this.clickable = false,
    this.onStepClick,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  DStepStatus _getStepStatus(int index) {
    if (index < currentStep) return DStepStatus.completed;
    if (index == currentStep) return DStepStatus.current;
    return DStepStatus.upcoming;
  }

  String _getStepCircleClasses(DStepStatus status) {
    switch (status) {
      case DStepStatus.completed:
        return 'bg-cyan-600 text-white border-cyan-600';
      case DStepStatus.current:
        return 'bg-cyan-600 text-white border-cyan-600';
      case DStepStatus.upcoming:
        return 'bg-white dark:bg-zinc-900 text-gray-400 border-gray-300 dark:border-gray-600';
    }
  }

  String _getLineClasses(DStepStatus status) {
    switch (status) {
      case DStepStatus.completed:
        return 'bg-cyan-600';
      case DStepStatus.current:
      case DStepStatus.upcoming:
        return 'bg-gray-300 dark:bg-zinc-600';
    }
  }

  @override
  Component build(BuildContext context) {
    if (steps.isEmpty) {
      return Div(children: []);
    }

    final isHorizontal = orientation == DStepperOrientation.horizontal;

    return Div(
      id: id,
      className: twMerge(
        isHorizontal ? 'flex items-center' : 'flex flex-col',
        className),
      attributes: attributes,
      events: events,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          _buildStep(i, steps[i], isHorizontal),
          if (i < steps.length - 1) _buildConnector(i, isHorizontal),
        ],
      ],
    );
  }

  Component _buildStep(int index, DStepItem step, bool isHorizontal) {
    final status = _getStepStatus(index);
    final circleClasses = _getStepCircleClasses(status);

    final stepWidget = Div(
      className: [
        'flex',
        if (isHorizontal) 'flex-col items-center' else 'items-start gap-4',
      ].join(' '),
      children: [
        // Step circle
        Button(
          type: 'button',
          onClick: clickable ? () => onStepClick?.call(index) : null,
          className: [
            'flex items-center justify-center w-10 h-10 rounded-full border-2 font-medium text-sm transition-colors',
            circleClasses,
            if (clickable)
              'cursor-pointer hover:opacity-80'
            else
              'cursor-default',
          ].join(' '),
          children: [
            if (status == DStepStatus.completed)
              DIcon(name: DIconNames.check, size: DIconSize.sm)
            else if (step.icon != null)
              step.icon!
            else
              Text('${index + 1}'),
          ],
        ),

        // Step content
        Div(
          className: [
            if (isHorizontal) 'mt-2 text-center' else 'flex-1',
          ].join(' '),
          children: [
            // Title
            Span(
              className: [
                'block font-medium text-sm',
                status == DStepStatus.upcoming
                    ? 'text-gray-400 dark:text-gray-500'
                    : 'text-gray-900 dark:text-white',
              ].join(' '),
              children: [Text(step.title)],
            ),

            // Description
            if (step.description != null)
              Span(
                className:
                    'block text-xs text-gray-500 dark:text-gray-400 mt-0.5',
                children: [Text(step.description!)],
              ),
          ],
        ),
      ],
    );

    return stepWidget;
  }

  Component _buildConnector(int index, bool isHorizontal) {
    final status = _getStepStatus(index);
    final lineClasses = _getLineClasses(status);

    if (isHorizontal) {
      return Div(
        className: 'flex-1 h-0.5 mx-4 $lineClasses transition-colors',
        children: [],
      );
    } else {
      return Div(
        className: 'w-0.5 h-8 ml-5 my-2 $lineClasses transition-colors',
        children: [],
      );
    }
  }
}
