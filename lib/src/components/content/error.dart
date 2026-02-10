import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import '../../theme/colors.dart';

/// Error severity levels
enum DErrorSeverity { warning, error, fatal }

/// DuxtUI Error component - Error state display
class DError extends StatelessComponent {
  final String? icon;
  final Component? iconComponent;
  final String? title;
  final String? description;
  final String? errorCode;
  final Component? action;
  final List<Component> children;
  final DSize size;
  final DErrorSeverity severity;
  final bool padded;
  final VoidCallback? onRetry;

  const DError({
    super.key,
    this.icon,
    this.iconComponent,
    this.title,
    this.description,
    this.errorCode,
    this.action,
    this.children = const [],
    this.size = DSize.md,
    this.severity = DErrorSeverity.error,
    this.padded = true,
    this.onRetry,
  });

  String get _severityColorClasses {
    switch (severity) {
      case DErrorSeverity.warning:
        return 'text-yellow-500 dark:text-yellow-400';
      case DErrorSeverity.error:
        return 'text-red-500 dark:text-red-400';
      case DErrorSeverity.fatal:
        return 'text-red-600 dark:text-red-500';
    }
  }

  String get _iconSizeClasses {
    switch (size) {
      case DSize.xs:
        return 'text-3xl';
      case DSize.sm:
        return 'text-4xl';
      case DSize.md:
        return 'text-5xl';
      case DSize.lg:
        return 'text-6xl';
      case DSize.xl:
        return 'text-7xl';
    }
  }

  String get _titleSizeClasses {
    switch (size) {
      case DSize.xs:
        return 'text-sm';
      case DSize.sm:
        return 'text-base';
      case DSize.md:
        return 'text-lg';
      case DSize.lg:
        return 'text-xl';
      case DSize.xl:
        return 'text-2xl';
    }
  }

  String get _descriptionSizeClasses {
    switch (size) {
      case DSize.xs:
        return 'text-xs';
      case DSize.sm:
        return 'text-sm';
      case DSize.md:
        return 'text-sm';
      case DSize.lg:
        return 'text-base';
      case DSize.xl:
        return 'text-lg';
    }
  }

  String get _paddingClasses {
    if (!padded) return '';
    switch (size) {
      case DSize.xs:
        return 'py-6';
      case DSize.sm:
        return 'py-8';
      case DSize.md:
        return 'py-12';
      case DSize.lg:
        return 'py-16';
      case DSize.xl:
        return 'py-20';
    }
  }

  String get _defaultIcon {
    switch (severity) {
      case DErrorSeverity.warning:
        return '\u26A0\uFE0F'; // Warning sign
      case DErrorSeverity.error:
        return '\u274C'; // Cross mark
      case DErrorSeverity.fatal:
        return '\u{1F6A8}'; // Emergency light
    }
  }

  String get _defaultTitle {
    switch (severity) {
      case DErrorSeverity.warning:
        return 'Warning';
      case DErrorSeverity.error:
        return 'Something went wrong';
      case DErrorSeverity.fatal:
        return 'Critical error';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: cx([
        'flex flex-col items-center justify-center text-center',
        _paddingClasses,
      ]),
      children: [
        // Icon
        if (iconComponent != null)
          Div(
            className: cx(['mb-4', _severityColorClasses]),
            children: [iconComponent!],
          )
        else
          Div(
            className: cx([
              'mb-4',
              _iconSizeClasses,
              _severityColorClasses,
            ]),
            children: [Text(icon ?? _defaultIcon)],
          ),
        // Title
        H3(
          className: cx([
            'font-semibold',
            _titleSizeClasses,
            DTextColors.highlighted,
            'mb-2',
          ]),
          children: [Text(title ?? _defaultTitle)],
        ),
        // Description
        if (description != null)
          P(
            className: cx([
              _descriptionSizeClasses,
              DTextColors.muted,
              'max-w-sm',
              'mb-2',
            ]),
            children: [Text(description!)],
          ),
        // Error code
        if (errorCode != null)
          P(
            className: cx([
              'text-xs',
              'font-mono',
              DTextColors.dimmed,
              'mb-4',
            ]),
            children: [Text('Error code: $errorCode')],
          ),
        // Custom children
        if (children.isNotEmpty) Div(className: 'mt-2', children: children),
        // Actions
        Div(
          className: 'flex items-center gap-3 mt-4',
          children: [
            // Retry button
            if (onRetry != null)
              Button(
                type: 'button',
                onClick: onRetry,
                className: cx([
                  'px-4 py-2',
                  'text-sm font-medium',
                  'text-white',
                  'bg-gray-900 dark:bg-white dark:text-gray-900',
                  'rounded-lg',
                  'hover:bg-gray-800 dark:hover:bg-gray-100',
                  'transition-colors',
                ]),
                children: [Text('Try again')],
              ),
            // Custom action
            if (action != null) action!,
          ],
        ),
      ],
    );
  }
}

/// Preset 404 error state
class DError404 extends StatelessComponent {
  final Component? action;

  const DError404({super.key, this.action});

  @override
  Component build(BuildContext context) {
    return DError(
      icon: '\u{1F50D}', // Magnifying glass
      title: 'Page not found',
      description:
          'The page you are looking for does not exist or has been moved.',
      errorCode: '404',
      action: action,
    );
  }
}

/// Preset 500 error state
class DError500 extends StatelessComponent {
  final VoidCallback? onRetry;
  final Component? action;

  const DError500({super.key, this.onRetry, this.action});

  @override
  Component build(BuildContext context) {
    return DError(
      icon: '\u{1F6A7}', // Construction
      title: 'Server error',
      description: 'An unexpected error occurred. Please try again later.',
      errorCode: '500',
      severity: DErrorSeverity.fatal,
      onRetry: onRetry,
      action: action,
    );
  }
}

/// Preset network error state
class DErrorNetwork extends StatelessComponent {
  final VoidCallback? onRetry;

  const DErrorNetwork({super.key, this.onRetry});

  @override
  Component build(BuildContext context) {
    return DError(
      icon: '\u{1F4F6}', // Signal bars
      title: 'Network error',
      description:
          'Unable to connect. Please check your internet connection and try again.',
      onRetry: onRetry,
    );
  }
}
