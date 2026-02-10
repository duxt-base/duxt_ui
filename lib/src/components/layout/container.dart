import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// Container max-width variants
enum DContainerSize { xs, sm, md, lg, xl, xxl, full }

/// DuxtUI Container component - max-width wrapper with responsive padding
class DContainer extends StatelessComponent {
  final List<Component> children;
  final DContainerSize size;
  final bool padded;
  final String? classes;

  const DContainer({
    super.key,
    this.children = const [],
    this.size = DContainerSize.xl,
    this.padded = true,
    this.classes,
  });

  String get _maxWidthClasses {
    switch (size) {
      case DContainerSize.xs:
        return 'max-w-xs';
      case DContainerSize.sm:
        return 'max-w-sm';
      case DContainerSize.md:
        return 'max-w-md';
      case DContainerSize.lg:
        return 'max-w-4xl';
      case DContainerSize.xl:
        return 'max-w-6xl';
      case DContainerSize.xxl:
        return 'max-w-7xl';
      case DContainerSize.full:
        return 'max-w-full';
    }
  }

  String get _paddingClasses {
    return padded ? 'px-4 sm:px-6 lg:px-8' : '';
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'mx-auto $_maxWidthClasses $_paddingClasses ${classes ?? ""}'.trim(),
      children: children,
    );
  }
}
