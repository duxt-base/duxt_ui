import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';
import '../../theme/tw_merge.dart';

/// Input number sizes
enum DInputNumberSize { xs, sm, md, lg, xl }

/// DuxtUI InputNumber component - Numeric input with increment/decrement buttons
///
/// Uses inline JavaScript for increment/decrement functionality.
class DInputNumber extends StatelessComponent {
  final String? label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? name;
  final String? placeholder;
  final DInputNumberSize size;
  final DColor color;
  final bool disabled;
  final bool required;
  final String? hint;
  final String? error;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DInputNumber({
    super.key,
    this.label,
    this.value = 0,
    this.min = double.negativeInfinity,
    this.max = double.infinity,
    this.step = 1,
    this.name,
    this.placeholder,
    this.size = DInputNumberSize.md,
    this.color = DColor.primary,
    this.disabled = false,
    this.required = false,
    this.hint,
    this.error,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _sizeClasses {
    switch (size) {
      case DInputNumberSize.xs:
        return 'px-2 py-1 text-xs';
      case DInputNumberSize.sm:
        return 'px-2.5 py-1.5 text-xs';
      case DInputNumberSize.md:
        return 'px-2.5 py-1.5 text-sm';
      case DInputNumberSize.lg:
        return 'px-3 py-2 text-sm';
      case DInputNumberSize.xl:
        return 'px-3 py-2 text-base';
    }
  }

  String get _buttonSizeClasses {
    switch (size) {
      case DInputNumberSize.xs:
        return 'px-2 py-1';
      case DInputNumberSize.sm:
        return 'px-2.5 py-1.5';
      case DInputNumberSize.md:
        return 'px-3 py-1.5';
      case DInputNumberSize.lg:
        return 'px-3.5 py-2';
      case DInputNumberSize.xl:
        return 'px-4 py-2';
    }
  }

  String get _colorClasses {
    switch (color) {
      case DColor.primary:
        return 'focus:ring-cyan-500 focus:border-cyan-500';
      case DColor.secondary:
        return 'focus:ring-blue-500 focus:border-blue-500';
      case DColor.success:
        return 'focus:ring-green-500 focus:border-green-500';
      case DColor.info:
        return 'focus:ring-blue-500 focus:border-blue-500';
      case DColor.warning:
        return 'focus:ring-yellow-500 focus:border-yellow-500';
      case DColor.error:
        return 'focus:ring-red-500 focus:border-red-500';
      case DColor.neutral:
        return 'focus:ring-slate-500 focus:border-slate-500';
    }
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final borderColor = hasError
        ? 'border-red-500 focus:ring-red-500'
        : 'border-gray-300 dark:border-gray-600 $_colorClasses';

    final buttonBaseClasses = cx([
      _buttonSizeClasses,
      'text-gray-500',
      'dark:text-gray-400',
      'hover:bg-gray-100',
      'dark:hover:bg-gray-700',
      'focus:outline-none',
      'focus:ring-2',
      'focus:ring-inset',
      _colorClasses,
      disabled ? 'opacity-50 cursor-not-allowed' : null,
    ]);

    return Div(className: 'space-y-1', children: [
      if (label != null)
        Span(
            className:
                'block text-sm font-medium text-gray-700 dark:text-gray-200',
            children: [
              Text(label!),
              if (required)
                Span(className: 'text-red-500 ml-1', children: [Text('*')]),
            ]),
      Div(
        className: 'relative flex items-stretch',
        attributes: {
          'data-input-number': 'true',
          'data-step': step.toString(),
          'data-min': min.isFinite ? min.toString() : '',
          'data-max': max.isFinite ? max.toString() : '',
        },
        children: [
          // Decrement button
          Button(
            type: 'button',
            disabled: disabled,
            className: cx([
              buttonBaseClasses,
              'rounded-l-lg',
              'border',
              'border-r-0',
              borderColor,
              'bg-gray-50',
              'dark:bg-zinc-800',
            ]),
            attributes: {'data-action': 'decrement'},
            children: [
              Span(className: 'sr-only', children: [Text('Decrement')]),
              Span(className: 'text-lg font-medium', children: [Text('\u2212')]),
            ],
          ),
          // Input
          Input(
            type: 'number',
            name: name,
            id: id,
            value: value.toString(),
            disabled: disabled,
            className: twMerge(cx([
              'block',
              'w-full',
              'text-center',
              'border',
              borderColor,
              _sizeClasses,
              'text-gray-900 dark:text-white',
              disabled
                  ? 'bg-gray-100 dark:bg-zinc-800 cursor-not-allowed'
                  : 'bg-white dark:bg-zinc-900',
              'focus:outline-none',
              'focus:ring-2',
              '[appearance:textfield]',
              '[&::-webkit-outer-spin-button]:appearance-none',
              '[&::-webkit-inner-spin-button]:appearance-none',
            ]), className),
            placeholder: placeholder,
            attributes: mergeAttributes({
              if (min.isFinite) 'min': min.toString(),
              if (max.isFinite) 'max': max.toString(),
              'step': step.toString(),
              'data-input': 'true',
            }, attributes),
            events: {
              ...?events,
            },
          ),
          // Increment button
          Button(
            type: 'button',
            disabled: disabled,
            className: cx([
              buttonBaseClasses,
              'rounded-r-lg',
              'border',
              'border-l-0',
              borderColor,
              'bg-gray-50',
              'dark:bg-zinc-800',
            ]),
            attributes: {'data-action': 'increment'},
            children: [
              Span(className: 'sr-only', children: [Text('Increment')]),
              Span(className: 'text-lg font-medium', children: [Text('+')]),
            ],
          ),
        ],
      ),
      if (hasError)
        P(className: 'text-sm text-red-600 dark:text-red-400',
            children: [Text(error!)])
      else if (hint != null)
        P(className: 'text-sm text-gray-500 dark:text-gray-400',
            children: [Text(hint!)]),
      // Global input number handler
      RawText('''<script>
if (!window._inputNumberInit) {
  window._inputNumberInit = true;
  document.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-action]');
    if (!btn) return;
    var container = btn.closest('[data-input-number]');
    if (!container) return;
    var input = container.querySelector('[data-input]');
    if (!input || input.disabled) return;
    var step = parseFloat(container.dataset.step) || 1;
    var min = container.dataset.min !== '' ? parseFloat(container.dataset.min) : -Infinity;
    var max = container.dataset.max !== '' ? parseFloat(container.dataset.max) : Infinity;
    var val = parseFloat(input.value) || 0;
    if (btn.dataset.action === 'increment') {
      val = Math.min(val + step, max);
    } else if (btn.dataset.action === 'decrement') {
      val = Math.max(val - step, min);
    }
    input.value = val;
    input.dispatchEvent(new Event('input', { bubbles: true }));
  });
}
</script>'''),
    ]);
  }
}
