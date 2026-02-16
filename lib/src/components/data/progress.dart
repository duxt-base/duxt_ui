import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show svg, circle;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';

/// Progress animation types
enum DProgressAnimation { none, pulse, indeterminate }

/// DuxtUI Progress Bar component
class DProgress extends StatelessComponent {
  /// Current progress value (0-100)
  final double value;

  /// Maximum value (default 100)
  final double max;

  /// Progress color
  final DColor color;

  /// Progress size
  final DSize size;

  /// Whether to show percentage label
  final bool showLabel;

  /// Custom label (overrides percentage)
  final String? label;

  /// Animation type
  final DProgressAnimation animation;

  /// Whether the progress is indeterminate (unknown progress)
  final bool indeterminate;

  /// Custom track (background) color class
  final String? trackColor;

  /// Custom indicator (fill) color class
  final String? indicatorColor;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DProgress({
    super.key,
    this.value = 0,
    this.max = 100,
    this.color = DColor.primary,
    this.size = DSize.md,
    this.showLabel = false,
    this.label,
    this.animation = DProgressAnimation.none,
    this.indeterminate = false,
    this.trackColor,
    this.indicatorColor,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  double get _percentage => (value / max * 100).clamp(0, 100);

  String get _heightClass {
    switch (size) {
      case DSize.xs:
        return 'h-1';
      case DSize.sm:
        return 'h-1.5';
      case DSize.md:
        return 'h-2';
      case DSize.lg:
        return 'h-3';
      case DSize.xl:
        return 'h-4';
    }
  }

  String get _trackColorClass {
    return trackColor ?? 'bg-gray-200 dark:bg-zinc-700';
  }

  String get _indicatorColorClass {
    if (indicatorColor != null) return indicatorColor!;

    final baseColor = defaultColorMapping[color] ?? 'green';
    return 'bg-$baseColor-500';
  }

  String get _animationClass {
    if (indeterminate) {
      return 'animate-indeterminate';
    }
    switch (animation) {
      case DProgressAnimation.none:
        return '';
      case DProgressAnimation.pulse:
        return 'animate-pulse';
      case DProgressAnimation.indeterminate:
        return 'animate-indeterminate';
    }
  }

  @override
  Component build(BuildContext context) {
    final progressBar = Div(
      className: cx([
        'overflow-hidden rounded-full w-full',
        _heightClass,
        _trackColorClass,
      ]),
      attributes: {
        'role': 'progressbar',
        'aria-valuenow': indeterminate ? '' : '${value.toInt()}',
        'aria-valuemin': '0',
        'aria-valuemax': '${max.toInt()}',
      },
      children: [
        Div(
          className: cx([
            _heightClass,
            _indicatorColorClass,
            'rounded-full transition-all duration-300',
            _animationClass,
          ]),
          style: indeterminate ? 'width: 30%' : 'width: ${_percentage}%',
          children: [],
        ),
      ],
    );

    if (showLabel || label != null) {
      return Div(
        id: id,
        className: twMerge('w-full', className),
        attributes: attributes,
        events: events,
        children: [
          if (showLabel || label != null)
            Div(
              className: 'flex justify-between mb-1',
              children: [
                if (label != null)
                  Span(
                    className: 'text-sm font-medium ${DTextColors.defaultText}',
                    children: [Text(label!)],
                  ),
                Span(
                  className: 'text-sm font-medium ${DTextColors.muted}',
                  children: [Text('${_percentage.toInt()}%')],
                ),
              ],
            ),
          progressBar,
        ],
      );
    }

    // Wrap with id/className/attributes/events when no label wrapper
    if (id != null || className != null || attributes != null || events != null) {
      return Div(
        id: id,
        className: twMerge('w-full', className),
        attributes: attributes,
        events: events,
        children: [progressBar],
      );
    }
    return progressBar;
  }
}

/// Circular Progress component
class DProgressCircular extends StatelessComponent {
  /// Current progress value (0-100)
  final double value;

  /// Maximum value
  final double max;

  /// Progress color
  final DColor color;

  /// Size of the circle
  final DSize size;

  /// Stroke width
  final double strokeWidth;

  /// Whether to show percentage in center
  final bool showLabel;

  /// Custom label
  final String? label;

  /// Whether the progress is indeterminate
  final bool indeterminate;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DProgressCircular({
    super.key,
    this.value = 0,
    this.max = 100,
    this.color = DColor.primary,
    this.size = DSize.md,
    this.strokeWidth = 4,
    this.showLabel = true,
    this.label,
    this.indeterminate = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  double get _percentage => (value / max * 100).clamp(0, 100);

  int get _sizePixels {
    switch (size) {
      case DSize.xs:
        return 24;
      case DSize.sm:
        return 32;
      case DSize.md:
        return 48;
      case DSize.lg:
        return 64;
      case DSize.xl:
        return 80;
    }
  }

  String get _sizeClass {
    switch (size) {
      case DSize.xs:
        return 'size-6';
      case DSize.sm:
        return 'size-8';
      case DSize.md:
        return 'size-12';
      case DSize.lg:
        return 'size-16';
      case DSize.xl:
        return 'size-20';
    }
  }

  String get _textSizeClass {
    switch (size) {
      case DSize.xs:
        return 'text-[8px]';
      case DSize.sm:
        return 'text-[10px]';
      case DSize.md:
        return 'text-xs';
      case DSize.lg:
        return 'text-sm';
      case DSize.xl:
        return 'text-base';
    }
  }

  String get _strokeColor {
    final baseColor = defaultColorMapping[color] ?? 'green';
    return 'stroke-$baseColor-500';
  }

  @override
  Component build(BuildContext context) {
    final sizeVal = _sizePixels;
    final radius = (sizeVal - strokeWidth) / 2;
    final circumference = 2 * 3.14159 * radius;
    final dashOffset = circumference - (_percentage / 100 * circumference);

    return Div(
      id: id,
      className: twMerge('relative inline-flex items-center justify-center $_sizeClass', className),
      attributes: attributes,
      events: events,
      children: [
        // SVG using Jaspr's native SVG components
        svg(
          [
            // Background circle
            circle(
              [],
              cx: '${sizeVal / 2}',
              cy: '${sizeVal / 2}',
              r: '$radius',
              classes: 'stroke-gray-200 dark:stroke-gray-700',
              attributes: {
                'fill': 'none',
                'stroke-width': '$strokeWidth',
              },
            ),
            // Progress circle
            circle(
              [],
              cx: '${sizeVal / 2}',
              cy: '${sizeVal / 2}',
              r: '$radius',
              classes: '$_strokeColor transition-all duration-300',
              attributes: {
                'fill': 'none',
                'stroke-width': '$strokeWidth',
                'stroke-linecap': 'round',
                'stroke-dasharray': '$circumference',
                'stroke-dashoffset':
                    indeterminate ? '${circumference * 0.75}' : '$dashOffset',
                'transform': 'rotate(-90 ${sizeVal / 2} ${sizeVal / 2})',
              },
            ),
          ],
          viewBox: '0 0 $sizeVal $sizeVal',
          classes: cx([
            '$_sizeClass',
            if (indeterminate) 'animate-spin',
          ]),
        ),
        // Center label
        if ((showLabel || label != null) && !indeterminate)
          Span(
            className:
                'absolute $_textSizeClass font-medium ${DTextColors.defaultText}',
            children: [Text(label ?? '${_percentage.toInt()}%')],
          ),
      ],
    );
  }
}

/// Progress with steps/segments
class DProgressSteps extends StatelessComponent {
  /// Current step (0-indexed)
  final int currentStep;

  /// Total number of steps
  final int totalSteps;

  /// Step labels (optional)
  final List<String>? labels;

  /// Progress color
  final DColor color;

  /// Size
  final DSize size;

  /// Additional CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DProgressSteps({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.labels,
    this.color = DColor.primary,
    this.size = DSize.md,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _heightClass {
    switch (size) {
      case DSize.xs:
        return 'h-1';
      case DSize.sm:
        return 'h-1.5';
      case DSize.md:
        return 'h-2';
      case DSize.lg:
        return 'h-3';
      case DSize.xl:
        return 'h-4';
    }
  }

  String get _activeColor {
    final baseColor = defaultColorMapping[color] ?? 'green';
    return 'bg-$baseColor-500';
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      className: twMerge('w-full', className),
      attributes: attributes,
      events: events,
      children: [
        // Progress segments
        Div(
          className: 'flex gap-1',
          children: [
            for (var i = 0; i < totalSteps; i++)
              Div(
                className: cx([
                  'flex-1 rounded-full $_heightClass transition-colors',
                  i <= currentStep
                      ? _activeColor
                      : 'bg-gray-200 dark:bg-zinc-700',
                ]),
                children: [],
              ),
          ],
        ),
        // Labels
        if (labels != null && labels!.isNotEmpty)
          Div(
            className: 'flex justify-between mt-2',
            children: [
              for (var i = 0; i < totalSteps && i < labels!.length; i++)
                Span(
                  className: cx([
                    'text-xs',
                    i <= currentStep
                        ? DTextColors.defaultText
                        : DTextColors.muted,
                  ]),
                  children: [Text(labels![i])],
                ),
            ],
          ),
      ],
    );
  }
}
