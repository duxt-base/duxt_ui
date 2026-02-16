import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Separator orientation
enum DSeparatorOrientation { horizontal, vertical }

/// Separator type
enum DSeparatorType { solid, dashed, dotted }

/// DuxtUI Separator component - hr/divider
class DSeparator extends StatelessComponent {
  final DSeparatorOrientation orientation;
  final DSeparatorType type;
  final String? label;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSeparator({
    super.key,
    this.orientation = DSeparatorOrientation.horizontal,
    this.type = DSeparatorType.solid,
    this.label,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _orientationClasses {
    switch (orientation) {
      case DSeparatorOrientation.horizontal:
        return 'w-full border-t';
      case DSeparatorOrientation.vertical:
        return 'h-full border-l self-stretch';
    }
  }

  String get _typeClasses {
    switch (type) {
      case DSeparatorType.solid:
        return 'border-solid';
      case DSeparatorType.dashed:
        return 'border-dashed';
      case DSeparatorType.dotted:
        return 'border-dotted';
    }
  }

  @override
  Component build(BuildContext context) {
    final baseClasses = 'border-gray-200 dark:border-gray-800';

    if (label != null && orientation == DSeparatorOrientation.horizontal) {
      // Separator with label
      return Div(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('relative flex items-center w-full', className),
        children: [
          Div(className: 'flex-grow border-t $baseClasses $_typeClasses', children: []),
          Span(
            className:
                'mx-4 text-sm text-gray-500 dark:text-gray-400 bg-white dark:bg-zinc-900 px-2',
            children: [Text(label!)],
          ),
          Div(className: 'flex-grow border-t $baseClasses $_typeClasses', children: []),
        ],
      );
    }

    // Simple separator (hr-like)
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('$_orientationClasses $baseClasses $_typeClasses', className),
      children: [],
    );
  }
}

/// Convenience component for horizontal rule
class DHr extends StatelessComponent {
  final DSeparatorType type;
  final String? label;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DHr({
    super.key,
    this.type = DSeparatorType.solid,
    this.label,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return DSeparator(
      orientation: DSeparatorOrientation.horizontal,
      type: type,
      label: label,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
    );
  }
}

/// Convenience component for vertical divider
class DDivider extends StatelessComponent {
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DDivider({
    super.key,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return DSeparator(
      orientation: DSeparatorOrientation.vertical,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
    );
  }
}
