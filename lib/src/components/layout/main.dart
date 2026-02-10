import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI Main component - main content wrapper
class DMain extends StatelessComponent {
  final List<Component> children;
  final String? classes;
  final bool padded;
  final bool centered;

  const DMain({
    super.key,
    this.children = const [],
    this.classes,
    this.padded = true,
    this.centered = false,
  });

  @override
  Component build(BuildContext context) {
    final paddingClasses = padded ? 'py-8 sm:py-12 lg:py-16' : '';
    final centerClasses = centered ? 'flex flex-col items-center' : '';

    return Main(
      className: 'flex-1 min-h-0 $paddingClasses $centerClasses ${classes ?? ""}'
          .trim(),
      children: children,
    );
  }
}

/// DuxtUI Section component - semantic section wrapper
class DSection extends StatelessComponent {
  final List<Component> children;
  final String? classes;
  final String? id;
  final bool padded;

  const DSection({
    super.key,
    this.children = const [],
    this.classes,
    this.id,
    this.padded = true,
  });

  @override
  Component build(BuildContext context) {
    final paddingClasses = padded ? 'py-12 sm:py-16 lg:py-20' : '';

    return Section(
      id: id,
      className: '$paddingClasses ${classes ?? ""}'.trim(),
      children: children,
    );
  }
}

/// DuxtUI Aside component - sidebar wrapper
class DAside extends StatelessComponent {
  final List<Component> children;
  final String? classes;
  final bool sticky;

  const DAside({
    super.key,
    this.children = const [],
    this.classes,
    this.sticky = false,
  });

  @override
  Component build(BuildContext context) {
    final stickyClasses = sticky ? 'sticky top-20' : '';

    return Aside(
      className: '$stickyClasses ${classes ?? ""}'.trim(),
      children: children,
    );
  }
}
