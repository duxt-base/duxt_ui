import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// DuxtUI Main component - main content wrapper
class DMain extends StatelessComponent {
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;
  final bool padded;
  final bool centered;

  const DMain({
    super.key,
    this.children = const [],
    this.className,
    this.id,
    this.attributes,
    this.events,
    this.padded = true,
    this.centered = false,
  });

  @override
  Component build(BuildContext context) {
    final paddingClasses = padded ? 'py-8 sm:py-12 lg:py-16' : '';
    final centerClasses = centered ? 'flex flex-col items-center' : '';

    return Main(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('flex-1 min-h-0 $paddingClasses $centerClasses', className),
      children: children,
    );
  }
}

/// DuxtUI Section component - semantic section wrapper
class DSection extends StatelessComponent {
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;
  final bool padded;

  const DSection({
    super.key,
    this.children = const [],
    this.className,
    this.id,
    this.attributes,
    this.events,
    this.padded = true,
  });

  @override
  Component build(BuildContext context) {
    final paddingClasses = padded ? 'py-12 sm:py-16 lg:py-20' : '';

    return Section(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(paddingClasses, className),
      children: children,
    );
  }
}

/// DuxtUI Aside component - sidebar wrapper
class DAside extends StatelessComponent {
  final List<Component> children;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;
  final bool sticky;

  const DAside({
    super.key,
    this.children = const [],
    this.className,
    this.id,
    this.attributes,
    this.events,
    this.sticky = false,
  });

  @override
  Component build(BuildContext context) {
    final stickyClasses = sticky ? 'sticky top-20' : '';

    return Aside(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(stickyClasses, className),
      children: children,
    );
  }
}
