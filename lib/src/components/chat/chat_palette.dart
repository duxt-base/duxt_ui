import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import 'chat_message.dart';
import 'chat_messages.dart';
import 'chat_prompt.dart';
import 'chat_prompt_submit.dart';

/// Chat palette position
enum DChatPalettePosition { bottomRight, bottomLeft, topRight, topLeft }

/// DuxtUI ChatPalette component - floating chat overlay/modal
class DChatPalette extends StatefulComponent {
  final bool open;
  final String? title;
  final List<ChatMessageData> messages;
  final bool loading;
  final String? placeholder;
  final DChatPalettePosition position;
  final String? width;
  final String? height;
  final VoidCallback? onClose;
  final ValueChanged<String>? onSend;
  final Component? headerSlot;
  final Component? emptyState;

  const DChatPalette({
    super.key,
    required this.open,
    this.title,
    this.messages = const [],
    this.loading = false,
    this.placeholder,
    this.position = DChatPalettePosition.bottomRight,
    this.width,
    this.height,
    this.onClose,
    this.onSend,
    this.headerSlot,
    this.emptyState,
  });

  @override
  State<DChatPalette> createState() => _UChatPaletteState();
}

class _UChatPaletteState extends State<DChatPalette> {
  String _inputValue = '';

  String get _positionClasses {
    switch (component.position) {
      case DChatPalettePosition.bottomRight:
        return 'bottom-4 right-4';
      case DChatPalettePosition.bottomLeft:
        return 'bottom-4 left-4';
      case DChatPalettePosition.topRight:
        return 'top-4 right-4';
      case DChatPalettePosition.topLeft:
        return 'top-4 left-4';
    }
  }

  void _handleInput(String value) {
    setState(() => _inputValue = value);
  }

  void _handleSubmit() {
    if (_inputValue.trim().isEmpty) return;
    component.onSend?.call(_inputValue.trim());
    setState(() => _inputValue = '');
  }

  @override
  Component build(BuildContext context) {
    if (!component.open) {
      return Div(children: []);
    }

    final width = component.width ?? 'w-96';
    final height = component.height ?? 'h-[600px]';

    return Div(
      className: 'fixed $_positionClasses $width $height z-50',
      children: [
        // Main container
        Div(
          className:
              'flex flex-col h-full bg-white dark:bg-zinc-900 rounded-2xl shadow-2xl border border-gray-200 dark:border-gray-700 overflow-hidden',
          children: [
            // Header
            _buildHeader(),

            // Messages area
            Div(
              className: 'flex-1 overflow-hidden flex flex-col',
              children: [
                DChatMessages(
                  messages: component.messages,
                  autoScrollToBottom: true,
                  emptyState: component.emptyState,
                ),
              ],
            ),

            // Input area
            _buildPrompt(),
          ],
        ),
      ],
    );
  }

  Component _buildHeader() {
    if (component.headerSlot != null) {
      return component.headerSlot!;
    }

    return Div(
      className:
          'flex items-center justify-between px-4 py-3 border-b border-gray-200 dark:border-gray-700 bg-white dark:bg-zinc-900',
      children: [
        // Title
        if (component.title != null)
          H3(
            className: 'text-base font-semibold text-gray-900 dark:text-gray-100',
            children: [Text(component.title!)],
          )
        else
          Div(children: []),

        // Close button
        if (component.onClose != null)
          Button(
            type: 'button',
            onClick: component.onClose,
            className:
                'p-1 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors',
            attributes: {
              'aria-label': 'Close chat',
            },
            children: [
              Svg(
                className: 'w-5 h-5',
                viewBox: '0 0 24 24',
                attributes: {
                  'fill': 'none',
                  'stroke': 'currentColor',
                  'stroke-width': '2',
                  'stroke-linecap': 'round',
                  'stroke-linejoin': 'round',
                },
                children: [
                  RawText('<path d="M18 6L6 18M6 6l12 12"/>'),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Component _buildPrompt() {
    return Div(
      className: 'border-t border-gray-200 dark:border-gray-700',
      children: [
        DChatPrompt(
          placeholder: component.placeholder ?? 'Type a message...',
          value: _inputValue,
          disabled: component.loading,
          onInput: _handleInput,
          onSubmit: _handleSubmit,
          trailingSlot: DChatPromptSubmit(
            disabled: _inputValue.trim().isEmpty,
            loading: component.loading,
            onSubmit: _handleSubmit,
            tooltip: 'Send message',
          ),
        ),
      ],
    );
  }
}

/// Floating action button to toggle chat palette
class DChatPaletteTrigger extends StatelessComponent {
  final bool isOpen;
  final VoidCallback? onToggle;
  final String? tooltip;
  final Component? icon;
  final String? bgColor;

  const DChatPaletteTrigger({
    super.key,
    this.isOpen = false,
    this.onToggle,
    this.tooltip,
    this.icon,
    this.bgColor,
  });

  @override
  Component build(BuildContext context) {
    final colorClasses = bgColor ?? 'bg-cyan-600 hover:bg-cyan-700';

    // Default chat icon
    final chatIcon = Svg(
      className: 'w-6 h-6',
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      children: [
        RawText('<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>'),
      ],
    );

    // Close icon
    final closeIcon = Svg(
      className: 'w-6 h-6',
      viewBox: '0 0 24 24',
      attributes: {
        'fill': 'none',
        'stroke': 'currentColor',
        'stroke-width': '2',
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
      },
      children: [
        RawText('<path d="M18 6L6 18M6 6l12 12"/>'),
      ],
    );

    return Button(
      type: 'button',
      onClick: onToggle,
      className:
          'fixed bottom-4 right-4 p-4 rounded-full $colorClasses text-white shadow-lg transition-all focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:ring-offset-2 z-40',
      attributes: {
        if (tooltip != null) 'title': tooltip!,
        'aria-label': tooltip ?? (isOpen ? 'Close chat' : 'Open chat'),
      },
      children: [
        icon ?? (isOpen ? closeIcon : chatIcon),
      ],
    );
  }
}
