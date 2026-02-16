import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../theme/tw_merge.dart';

/// Spinner sizes
enum DSpinnerSize { xs, sm, md, lg }

/// DuxtUI Spinner component
class DSpinner extends StatelessComponent {
  final DSpinnerSize size;
  final String? color;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSpinner({
    super.key,
    this.size = DSpinnerSize.md,
    this.color,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DSpinnerSize.xs:
        return 'h-3 w-3 border';
      case DSpinnerSize.sm:
        return 'h-4 w-4 border-2';
      case DSpinnerSize.md:
        return 'h-6 w-6 border-2';
      case DSpinnerSize.lg:
        return 'h-8 w-8 border-2';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(
          'animate-spin $_sizeClasses ${color ?? "border-cyan-600"} border-t-transparent rounded-full',
          className),
      children: [],
    );
  }
}

/// DuxtUI Loading overlay
class DLoading extends StatelessComponent {
  final String? message;
  final bool overlay;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DLoading({
    super.key,
    this.message,
    this.overlay = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    final content = Div(
      className: 'flex flex-col items-center justify-center gap-3',
      children: [
        DSpinner(size: DSpinnerSize.lg),
        if (message != null)
          P(className: 'text-sm text-gray-600', children: [Text(message!)]),
      ],
    );

    if (overlay) {
      return Div(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge(
            'fixed inset-0 bg-white/80 flex items-center justify-center z-50',
            className),
        children: [content],
      );
    }

    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('py-12', className),
      children: [content],
    );
  }
}
