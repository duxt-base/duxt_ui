import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';
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
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DChatMessages({
    super.key,
    required this.messages,
    this.autoScrollToBottom = true,
    this.showAvatars = true,
    this.showTimestamps = true,
    this.emptyState,
    this.userBgColor,
    this.assistantBgColor,
    this.className,
    this.id,
    this.attributes,
    this.events,
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
        id: component.id,
        attributes: component.attributes,
        events: component.events,
        className: twMerge('flex-1 flex items-center justify-center p-4', component.className),
        children: [component.emptyState!],
      );
    }

    if (component.messages.isEmpty) {
      return Div(
        id: component.id,
        attributes: component.attributes,
        events: component.events,
        className: twMerge(
            'flex-1 flex flex-col items-center justify-center p-4 text-gray-400',
            component.className),
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
      id: component.id ?? 'chat-messages-container',
      attributes: component.attributes,
      events: component.events,
      className: twMerge('flex flex-col gap-4 overflow-y-auto p-4 flex-1', component.className),
      style: 'scroll-behavior: smooth; overflow-anchor: auto',
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
