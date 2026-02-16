import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import 'package:duxt_icons/duxt_icons.dart' as duxt_icons;
import '../../theme/tw_merge.dart';
import '../spinner.dart';

/// Submit button size
enum DChatPromptSubmitSize { sm, md, lg }

/// DuxtUI ChatPromptSubmit component - send button for chat prompt
class DChatPromptSubmit extends StatelessComponent {
  final bool disabled;
  final bool loading;
  final DChatPromptSubmitSize size;
  final String? tooltip;
  final VoidCallback? onSubmit;
  final Component? icon;
  final String? bgColor;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DChatPromptSubmit({
    super.key,
    this.disabled = false,
    this.loading = false,
    this.size = DChatPromptSubmitSize.md,
    this.tooltip,
    this.onSubmit,
    this.icon,
    this.bgColor,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DChatPromptSubmitSize.sm:
        return 'p-1.5';
      case DChatPromptSubmitSize.md:
        return 'p-2';
      case DChatPromptSubmitSize.lg:
        return 'p-3';
    }
  }

  String get _iconSize {
    switch (size) {
      case DChatPromptSubmitSize.sm:
        return 'w-4 h-4';
      case DChatPromptSubmitSize.md:
        return 'w-5 h-5';
      case DChatPromptSubmitSize.lg:
        return 'w-6 h-6';
    }
  }

  double get _sizePixels {
    switch (size) {
      case DChatPromptSubmitSize.sm:
        return 16;
      case DChatPromptSubmitSize.md:
        return 20;
      case DChatPromptSubmitSize.lg:
        return 24;
    }
  }

  DSpinnerSize get _spinnerSize {
    switch (size) {
      case DChatPromptSubmitSize.sm:
        return DSpinnerSize.xs;
      case DChatPromptSubmitSize.md:
        return DSpinnerSize.sm;
      case DChatPromptSubmitSize.lg:
        return DSpinnerSize.md;
    }
  }

  @override
  Component build(BuildContext context) {
    final isDisabled = disabled || loading;
    final colorClasses = bgColor ?? 'bg-cyan-600 hover:bg-cyan-700';

    // Default send icon (arrow up)
    final defaultIcon = duxt_icons.Icon(
      'lucide:arrow-up',
      size: _sizePixels,
      className: _iconSize,
    );

    final baseAttributes = {
      if (tooltip != null) 'title': tooltip!,
      'aria-label': tooltip ?? 'Send message',
    };
    final mergedAttributes = {...baseAttributes, ...?attributes};

    return Button(
      type: 'button',
      id: id,
      disabled: isDisabled,
      onClick: isDisabled ? null : onSubmit,
      events: events,
      className: twMerge('$_sizeClasses rounded-lg $colorClasses text-white transition-colors focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed', className),
      attributes: mergedAttributes,
      children: [
        if (loading)
          DSpinner(size: _spinnerSize, color: 'border-white')
        else
          icon ?? defaultIcon,
      ],
    );
  }
}
