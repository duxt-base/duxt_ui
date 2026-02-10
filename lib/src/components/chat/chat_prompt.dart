import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// DuxtUI ChatPrompt component - input textarea for chat messages
class DChatPrompt extends StatefulComponent {
  final String? placeholder;
  final String? value;
  final bool disabled;
  final bool autoFocus;
  final int minRows;
  final int maxRows;
  final ValueChanged<String>? onInput;
  final VoidCallback? onSubmit;
  final Component? leadingSlot;
  final Component? trailingSlot;

  const DChatPrompt({
    super.key,
    this.placeholder,
    this.value,
    this.disabled = false,
    this.autoFocus = false,
    this.minRows = 1,
    this.maxRows = 5,
    this.onInput,
    this.onSubmit,
    this.leadingSlot,
    this.trailingSlot,
  });

  @override
  State<DChatPrompt> createState() => _UChatPromptState();
}

class _UChatPromptState extends State<DChatPrompt> {
  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = component.value ?? '';
  }

  @override
  void didUpdateComponent(DChatPrompt oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (component.value != null && component.value != _value) {
      _value = component.value!;
    }
  }

  void _handleInput(String newValue) {
    setState(() => _value = newValue);
    component.onInput?.call(newValue);
  }

  @override
  Component build(BuildContext context) {
    final isDisabled = component.disabled;

    return Div(
      className:
          'flex items-end gap-2 p-4 border-t border-gray-200 dark:border-gray-800 bg-white dark:bg-zinc-900',
      children: [
        // Leading slot (e.g., attachment button)
        if (component.leadingSlot != null) component.leadingSlot!,

        // Textarea container
        Div(
          className: 'flex-1 relative',
          children: [
            Textarea(
              onInput: _handleInput,
              className:
                  'w-full resize-none rounded-lg border border-gray-300 dark:border-gray-600 p-3 pr-12 text-sm bg-white dark:bg-zinc-800 text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:border-cyan-500 disabled:opacity-50 disabled:cursor-not-allowed',
              attributes: {
                if (component.placeholder != null)
                  'placeholder': component.placeholder!,
                'rows': component.minRows.toString(),
                if (isDisabled) 'disabled': 'true',
                if (component.autoFocus) 'autofocus': 'true',
                // CSS for auto-grow would need JavaScript interop
                // Using min/max height as a fallback
              },
              style: 'min-height: ${component.minRows * 24 + 24}px; max-height: ${component.maxRows * 24 + 24}px; overflow-y: auto',
              children: [Text(_value)],
            ),
          ],
        ),

        // Trailing slot (e.g., submit button, emoji picker)
        if (component.trailingSlot != null) component.trailingSlot!,
      ],
    );
  }
}
