import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import 'package:duxt_icons/duxt_icons.dart' as duxt_icons;

/// Icon sizes
enum DIconSize { xs, sm, md, lg, xl }

/// DuxtUI Icon component - Iconify icon wrapper
///
/// Renders inline icons using Iconify icon names.
/// When the icon has been preloaded via [duxt_icons.IconResolver], renders
/// as inline SVG (SSR-friendly, no client JS). Otherwise falls back to the
/// `<iconify-icon>` web component.
/// Supports size variants.
class DIcon extends StatelessComponent {
  /// The icon name in Iconify format (e.g., 'heroicons:sun', 'mdi:home')
  final String name;

  /// Size of the icon
  final DIconSize size;

  /// Custom CSS classes to apply
  final String? classes;

  /// Custom color class (e.g., 'text-red-500')
  final String? color;

  const DIcon({
    super.key,
    required this.name,
    this.size = DIconSize.md,
    this.classes,
    this.color,
  });

  /// Maps [DIconSize] to pixel values.
  double get _sizePixels {
    switch (size) {
      case DIconSize.xs:
        return 16;
      case DIconSize.sm:
        return 20;
      case DIconSize.md:
        return 24;
      case DIconSize.lg:
        return 32;
      case DIconSize.xl:
        return 40;
    }
  }

  String get _sizeClasses {
    switch (size) {
      case DIconSize.xs:
        return 'size-4'; // 16px
      case DIconSize.sm:
        return 'size-5'; // 20px
      case DIconSize.md:
        return 'size-6'; // 24px
      case DIconSize.lg:
        return 'size-8'; // 32px
      case DIconSize.xl:
        return 'size-10'; // 40px
    }
  }

  @override
  Component build(BuildContext context) {
    final iconClasses = [
      'inline-block',
      'flex-shrink-0',
      _sizeClasses,
      if (color != null) color!,
      if (classes != null) classes!,
    ].join(' ');

    // If the icon has a valid prefix:name format and is cached, render inline SVG
    if (name.contains(':')) {
      final cached = duxt_icons.IconResolver.instance.get(name);
      if (cached != null) {
        return duxt_icons.Icon(
          name,
          size: _sizePixels,
          className: iconClasses,
        );
      }
    }

    // Fallback: use Iconify web component for icons not preloaded
    return Span(
      className: iconClasses,
      attributes: {
        'data-icon': name,
        'aria-hidden': 'true',
      },
      children: [
        Component.element(
          tag: 'iconify-icon',
          attributes: {
            'icon': name,
            'width': '100%',
            'height': '100%',
          },
        ),
      ],
    );
  }
}

/// Common icon names for convenience (using Lucide icons)
class DIconNames {
  // Navigation
  static const String chevronLeft = 'lucide:chevron-left';
  static const String chevronRight = 'lucide:chevron-right';
  static const String chevronUp = 'lucide:chevron-up';
  static const String chevronDown = 'lucide:chevron-down';
  static const String arrowLeft = 'lucide:arrow-left';
  static const String arrowRight = 'lucide:arrow-right';

  // Actions
  static const String plus = 'lucide:plus';
  static const String minus = 'lucide:minus';
  static const String close = 'lucide:x';
  static const String check = 'lucide:check';
  static const String edit = 'lucide:pencil';
  static const String trash = 'lucide:trash-2';
  static const String search = 'lucide:search';
  static const String copy = 'lucide:copy';
  static const String download = 'lucide:download';
  static const String upload = 'lucide:upload';
  static const String refresh = 'lucide:refresh-cw';
  static const String filter = 'lucide:filter';
  static const String sort = 'lucide:arrow-up-down';

  // Theme
  static const String sun = 'lucide:sun';
  static const String moon = 'lucide:moon';
  static const String system = 'lucide:monitor';

  // Status
  static const String info = 'lucide:info';
  static const String warning = 'lucide:alert-triangle';
  static const String error = 'lucide:x-circle';
  static const String success = 'lucide:check-circle';

  // Communication
  static const String mail = 'lucide:mail';
  static const String send = 'lucide:send';
  static const String message = 'lucide:message-square';
  static const String bell = 'lucide:bell';

  // Files & Folders
  static const String file = 'lucide:file';
  static const String folder = 'lucide:folder';
  static const String image = 'lucide:image';
  static const String video = 'lucide:video';

  // Misc
  static const String menu = 'lucide:menu';
  static const String home = 'lucide:home';
  static const String user = 'lucide:user';
  static const String users = 'lucide:users';
  static const String settings = 'lucide:settings';
  static const String calendar = 'lucide:calendar';
  static const String clock = 'lucide:clock';
  static const String link = 'lucide:link';
  static const String externalLink = 'lucide:external-link';
  static const String github = 'lucide:github';
  static const String heart = 'lucide:heart';
  static const String star = 'lucide:star';
  static const String bookmark = 'lucide:bookmark';
  static const String share = 'lucide:share-2';
  static const String eye = 'lucide:eye';
  static const String eyeOff = 'lucide:eye-off';
  static const String lock = 'lucide:lock';
  static const String unlock = 'lucide:unlock';
  static const String loader = 'lucide:loader-2';
  static const String moreHorizontal = 'lucide:more-horizontal';
  static const String moreVertical = 'lucide:more-vertical';
  static const String grip = 'lucide:grip-vertical';
  static const String code = 'lucide:code';
  static const String terminal = 'lucide:terminal';
  static const String database = 'lucide:database';
  static const String server = 'lucide:server';
  static const String globe = 'lucide:globe';
  static const String zap = 'lucide:zap';
  static const String rocket = 'lucide:rocket';
  static const String box = 'lucide:box';
  static const String package = 'lucide:package';
  static const String layers = 'lucide:layers';
  static const String layout = 'lucide:layout';
  static const String palette = 'lucide:palette';
}
