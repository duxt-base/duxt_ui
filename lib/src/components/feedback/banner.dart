import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import '../../theme/tw_merge.dart';

/// Banner color variants
enum DBannerColor { primary, secondary, success, info, warning, error }

/// Banner variant styles
enum DBannerVariant { solid, outline, soft, subtle }

/// Banner position
enum DBannerPosition { top, bottom }

/// DuxtUI Banner component - Top/bottom banner message
class DBanner extends StatelessComponent {
  final String? title;
  final String? description;
  final DBannerColor color;
  final DBannerVariant variant;
  final DBannerPosition position;
  final Component? icon;
  final List<Component> actions;
  final bool closable;
  final VoidCallback? onClose;
  final bool sticky;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBanner({
    super.key,
    this.title,
    this.description,
    this.color = DBannerColor.primary,
    this.variant = DBannerVariant.solid,
    this.position = DBannerPosition.top,
    this.icon,
    this.actions = const [],
    this.closable = true,
    this.onClose,
    this.sticky = false,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _colorName {
    switch (color) {
      case DBannerColor.primary:
        return 'green';
      case DBannerColor.secondary:
        return 'blue';
      case DBannerColor.success:
        return 'green';
      case DBannerColor.info:
        return 'blue';
      case DBannerColor.warning:
        return 'yellow';
      case DBannerColor.error:
        return 'red';
    }
  }

  String get _variantClasses {
    final c = _colorName;
    switch (variant) {
      case DBannerVariant.solid:
        return 'bg-$c-500 text-white';
      case DBannerVariant.outline:
        return 'bg-white dark:bg-zinc-900 border-b border-$c-500 text-$c-600 dark:text-$c-400';
      case DBannerVariant.soft:
        return 'bg-$c-50 dark:bg-$c-950 text-$c-700 dark:text-$c-300';
      case DBannerVariant.subtle:
        return 'bg-$c-50 dark:bg-$c-950 border-b border-$c-200 dark:border-$c-800 text-$c-700 dark:text-$c-300';
    }
  }

  String get _positionClasses {
    final stickyClass = sticky ? 'sticky z-40' : '';
    switch (position) {
      case DBannerPosition.top:
        return '$stickyClass ${sticky ? "top-0" : ""}';
      case DBannerPosition.bottom:
        return '$stickyClass ${sticky ? "bottom-0" : ""}';
    }
  }

  String get _closeButtonClasses {
    switch (variant) {
      case DBannerVariant.solid:
        return 'text-white/80 hover:text-white hover:bg-white/10';
      case DBannerVariant.outline:
      case DBannerVariant.soft:
      case DBannerVariant.subtle:
        return 'text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800';
    }
  }

  String get _actionButtonClasses {
    switch (variant) {
      case DBannerVariant.solid:
        return 'text-white underline-offset-2 hover:underline';
      case DBannerVariant.outline:
      case DBannerVariant.soft:
      case DBannerVariant.subtle:
        return 'font-medium hover:underline';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge(cx([
        'w-full',
        'px-4 py-3',
        _variantClasses,
        _positionClasses,
      ]), className),
      children: [
        Div(
          className: 'flex items-center justify-center gap-4 max-w-7xl mx-auto',
          children: [
            // Icon
            if (icon != null) Div(className: 'flex-shrink-0', children: [icon!]),
            // Content
            Div(
              className:
                  'flex-1 flex items-center justify-center gap-x-4 gap-y-2 flex-wrap text-center sm:text-left',
              children: [
                // Message
                Div(
                  className: 'text-sm',
                  children: [
                    if (title != null)
                      Span(className: 'font-semibold', children: [Text(title!)]),
                    if (title != null && description != null)
                      Text(' \u2013 '), // En dash separator
                    if (description != null)
                      Span(children: [Text(description!)]),
                  ],
                ),
                // Actions
                if (actions.isNotEmpty)
                  Div(
                    className: cx([
                      'flex items-center gap-3',
                      'text-sm',
                      _actionButtonClasses,
                    ]),
                    children: actions,
                  ),
              ],
            ),
            // Close button
            if (closable && onClose != null)
              Button(
                type: 'button',
                onClick: onClose,
                className: cx([
                  'flex-shrink-0',
                  'p-1',
                  'rounded',
                  'transition-colors',
                  _closeButtonClasses,
                ]),
                children: [
                  Span(
                      className: 'text-lg leading-none',
                      children: [Text('\u00D7')])
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// Banner link action
class DBannerAction extends StatelessComponent {
  final String label;
  final VoidCallback? onClick;
  final String? href;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBannerAction({
    super.key,
    required this.label,
    this.onClick,
    this.href,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    if (href != null) {
      return A(
        href: href!,
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('whitespace-nowrap', className),
        children: [Text(label)],
      );
    }
    return Button(
      type: 'button',
      id: id,
      attributes: attributes,
      events: events,
      onClick: onClick,
      className: twMerge('whitespace-nowrap', className),
      children: [Text(label)],
    );
  }
}

/// Preset announcement banner
class DBannerAnnouncement extends StatelessComponent {
  final String message;
  final String? linkText;
  final String? linkHref;
  final VoidCallback? onClose;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBannerAnnouncement({
    super.key,
    required this.message,
    this.linkText,
    this.linkHref,
    this.onClose,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return DBanner(
      description: message,
      color: DBannerColor.primary,
      variant: DBannerVariant.solid,
      closable: onClose != null,
      onClose: onClose,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
      actions: linkText != null
          ? [DBannerAction(label: linkText!, href: linkHref)]
          : [],
    );
  }
}

/// Preset maintenance banner
class DBannerMaintenance extends StatelessComponent {
  final String? message;
  final VoidCallback? onClose;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBannerMaintenance({
    super.key,
    this.message,
    this.onClose,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return DBanner(
      icon: Div(children: [Text('\u{1F6A7}')]), // Construction emoji
      title: 'Maintenance',
      description: message ??
          'We are currently performing maintenance. Some features may be unavailable.',
      color: DBannerColor.warning,
      variant: DBannerVariant.soft,
      closable: onClose != null,
      onClose: onClose,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
    );
  }
}

/// Preset cookie consent banner
class DBannerCookieConsent extends StatelessComponent {
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final String? privacyPolicyHref;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DBannerCookieConsent({
    super.key,
    this.onAccept,
    this.onDecline,
    this.privacyPolicyHref,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return DBanner(
      description: 'We use cookies to enhance your browsing experience.',
      color: DBannerColor.info,
      variant: DBannerVariant.subtle,
      position: DBannerPosition.bottom,
      sticky: true,
      closable: false,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
      actions: [
        if (privacyPolicyHref != null)
          DBannerAction(label: 'Learn more', href: privacyPolicyHref),
        Button(
          type: 'button',
          onClick: onDecline,
          className:
              'px-3 py-1 text-sm rounded bg-gray-200 dark:bg-zinc-700 hover:bg-gray-300 dark:hover:bg-gray-600',
          children: [Text('Decline')],
        ),
        Button(
          type: 'button',
          onClick: onAccept,
          className:
              'px-3 py-1 text-sm rounded bg-blue-500 text-white hover:bg-blue-600',
          children: [Text('Accept')],
        ),
      ],
    );
  }
}
