import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import 'chat_message.dart';

/// DuxtUI ChatMessages component - displays a scrollable list of chat messages
class DChatMessages extends StatefulComponent {
  final List<ChatMessageData> messages;
  final bool autoScrollToBottom;
  final bool showAvatars;
  final bool showTimestamps;
  final Component? emptyState;
  final String? userBgColor;
  final String? assistantBgColor;

  const DChatMessages({
    super.key,
    required this.messages,
    this.autoScrollToBottom = true,
    this.showAvatars = true,
    this.showTimestamps = true,
    this.emptyState,
    this.userBgColor,
    this.assistantBgColor,
  });

  @override
  State<DChatMessages> createState() => _UChatMessagesState();
}

class _UChatMessagesState extends State<DChatMessages> {
  @override
  void didUpdateComponent(DChatMessages oldComponent) {
    super.didUpdateComponent(oldComponent);
    // Auto-scroll logic would be handled via JavaScript interop in a real implementation
    // The scroll behavior is managed via CSS scroll-snap and overflow-anchor
  }

  @override
  Component build(BuildContext context) {
    if (component.messages.isEmpty && component.emptyState != null) {
      return Div(
        className: 'flex-1 flex items-center justify-center p-4',
        children: [component.emptyState!],
      );
    }

    if (component.messages.isEmpty) {
      return Div(
        className:
            'flex-1 flex flex-col items-center justify-center p-4 text-gray-400',
        children: [
          // Empty chat icon
          Div(
            className:
                'w-16 h-16 mb-4 rounded-full bg-gray-100 dark:bg-zinc-800 flex items-center justify-center',
            children: [
              Span(className: 'text-2xl', children: [Text('💬')]),
            ],
          ),
          P(className: 'text-sm', children: [Text('No messages yet')]),
          P(className: 'text-xs mt-1', children: [Text('Start a conversation')]),
        ],
      );
    }

    return Div(
      className: 'flex flex-col gap-4 overflow-y-auto p-4 flex-1',
      style: 'scroll-behavior: smooth; overflow-anchor: auto',
      id: 'chat-messages-container',
      children: [
        for (final message in component.messages)
          DChatMessage(
            key: ValueKey(message.id),
            message: message,
            showAvatar: component.showAvatars,
            showTimestamp: component.showTimestamps,
            userBgColor: component.userBgColor,
            assistantBgColor: component.assistantBgColor,
          ),
        // Scroll anchor element
        if (component.autoScrollToBottom)
          Div(
            id: 'chat-scroll-anchor',
            style: 'overflow-anchor: auto; height: 1px',
            children: [],
          ),
      ],
    );
  }
}
