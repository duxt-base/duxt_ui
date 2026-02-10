import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';

/// Pin input sizes
enum DPinInputSize { xs, sm, md, lg, xl }

/// Pin input types
enum DPinInputType { text, number, password }

/// DuxtUI PinInput component - PIN/OTP entry with individual digit inputs
///
/// Uses inline JavaScript for auto-advance functionality.
class DPinInput extends StatelessComponent {
  final int length;
  final String? label;
  final String value;
  final DPinInputSize size;
  final DPinInputType type;
  final DColor color;
  final bool disabled;
  final bool required;
  final bool autofocus;
  final String? placeholder;
  final String? hint;
  final String? error;
  final String? name;

  const DPinInput({
    super.key,
    this.length = 4,
    this.label,
    this.value = '',
    this.size = DPinInputSize.md,
    this.type = DPinInputType.number,
    this.color = DColor.primary,
    this.disabled = false,
    this.required = false,
    this.autofocus = false,
    this.placeholder,
    this.hint,
    this.error,
    this.name,
  });

  String get _sizeClasses {
    switch (size) {
      case DPinInputSize.xs:
        return 'w-8 h-8 text-sm';
      case DPinInputSize.sm:
        return 'w-10 h-10 text-base';
      case DPinInputSize.md:
        return 'w-12 h-12 text-lg';
      case DPinInputSize.lg:
        return 'w-14 h-14 text-xl';
      case DPinInputSize.xl:
        return 'w-16 h-16 text-2xl';
    }
  }

  String get _gapClasses {
    switch (size) {
      case DPinInputSize.xs:
        return 'gap-1';
      case DPinInputSize.sm:
        return 'gap-1.5';
      case DPinInputSize.md:
        return 'gap-2';
      case DPinInputSize.lg:
        return 'gap-2.5';
      case DPinInputSize.xl:
        return 'gap-3';
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

  String get _inputType {
    switch (type) {
      case DPinInputType.text:
        return 'text';
      case DPinInputType.number:
        return 'text'; // Use text with inputmode for better mobile support
      case DPinInputType.password:
        return 'password';
    }
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final borderColor =
        hasError ? 'border-red-500' : 'border-gray-300 dark:border-gray-600';

    // Pre-fill digits from value
    final digits = List.generate(
      length,
      (i) => i < value.length ? value[i] : '',
    );

    return Div(className: 'space-y-2', children: [
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
        className: 'flex items-center $_gapClasses',
        attributes: {'data-pin-input': 'true'},
        children: [
          for (var i = 0; i < length; i++)
            Input(
              type: _inputType,
              name: name != null ? '${name}_$i' : null,
              value: digits[i],
              disabled: disabled,
              className: cx([
                _sizeClasses,
                'text-center',
                'font-medium',
                'rounded-lg',
                'border',
                borderColor,
                _colorClasses,
                'text-gray-900 dark:text-white',
                disabled
                    ? 'bg-gray-100 dark:bg-zinc-800 cursor-not-allowed'
                    : 'bg-white dark:bg-zinc-900',
                'focus:outline-none',
                'focus:ring-2',
              ]),
              placeholder: placeholder,
              attributes: {
                'maxlength': '1',
                'data-pin-index': '$i',
                if (type == DPinInputType.number) 'inputmode': 'numeric',
                if (type == DPinInputType.number) 'pattern': '[0-9]*',
                if (autofocus && i == 0) 'autofocus': 'true',
              },
            ),
          // Hidden input for form submission with complete value
          if (name != null)
            Input(
              type: 'hidden',
              name: name,
              value: value,
              attributes: {'data-pin-hidden': 'true'},
            ),
        ],
      ),
      if (hasError)
        P(className: 'text-sm text-red-600 dark:text-red-400',
            children: [Text(error!)])
      else if (hint != null)
        P(className: 'text-sm text-gray-500 dark:text-gray-400',
            children: [Text(hint!)]),
      // Global PIN input handler
      RawText('''<script>
if (!window._pinInputInit) {
  window._pinInputInit = true;
  document.addEventListener('input', function(e) {
    var input = e.target;
    if (!input.hasAttribute('data-pin-index')) return;
    var container = input.closest('[data-pin-input]');
    if (!container) return;
    var val = input.value;
    // Keep only last character
    if (val.length > 1) {
      input.value = val[val.length - 1];
    }
    // Auto-advance to next input
    if (input.value.length === 1) {
      var next = input.nextElementSibling;
      if (next && next.hasAttribute('data-pin-index')) {
        next.focus();
        next.select();
      }
    }
    // Update hidden input
    var inputs = container.querySelectorAll('[data-pin-index]');
    var hidden = container.querySelector('[data-pin-hidden]');
    if (hidden) {
      var fullVal = '';
      inputs.forEach(function(inp) { fullVal += inp.value; });
      hidden.value = fullVal;
    }
  });
  document.addEventListener('keydown', function(e) {
    var input = e.target;
    if (!input.hasAttribute('data-pin-index')) return;
    if (e.key === 'Backspace' && input.value === '') {
      var prev = input.previousElementSibling;
      if (prev && prev.hasAttribute('data-pin-index')) {
        prev.focus();
        prev.select();
      }
    } else if (e.key === 'ArrowLeft') {
      var prev = input.previousElementSibling;
      if (prev && prev.hasAttribute('data-pin-index')) {
        prev.focus();
        prev.select();
      }
    } else if (e.key === 'ArrowRight') {
      var next = input.nextElementSibling;
      if (next && next.hasAttribute('data-pin-index')) {
        next.focus();
        next.select();
      }
    }
  });
  document.addEventListener('focus', function(e) {
    var input = e.target;
    if (input.hasAttribute && input.hasAttribute('data-pin-index')) {
      input.select();
    }
  }, true);
}
</script>'''),
    ]);
  }
}
