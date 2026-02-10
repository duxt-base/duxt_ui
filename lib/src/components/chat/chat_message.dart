import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../avatar.dart';

/// Role for chat messages
enum DChatMessageRole { user, assistant }

/// Chat message data model
class ChatMessageData {
  final String id;
  final String content;
  final String role;
  final DateTime timestamp;
  final bool isLoading;

  const ChatMessageData({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
  });

  DChatMessageRole get roleEnum =>
      role == 'user' ? DChatMessageRole.user : DChatMessageRole.assistant;
}

/// DuxtUI ChatMessage component - displays a single chat message
class DChatMessage extends StatelessComponent {
  final ChatMessageData message;
  final DAvatar? avatar;
  final bool showAvatar;
  final bool showTimestamp;
  final String? userBgColor;
  final String? assistantBgColor;

  const DChatMessage({
    super.key,
    required this.message,
    this.avatar,
    this.showAvatar = true,
    this.showTimestamp = true,
    this.userBgColor,
    this.assistantBgColor,
  });

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Component build(BuildContext context) {
    final isUser = message.roleEnum == DChatMessageRole.user;

    // Message bubble classes
    final bubbleClasses = isUser
        ? 'rounded-2xl rounded-br-sm px-4 py-2 max-w-[80%] ${userBgColor ?? "bg-cyan-600 text-white"}'
        : 'rounded-2xl rounded-bl-sm px-4 py-2 max-w-[80%] ${assistantBgColor ?? "bg-gray-100 dark:bg-zinc-800 text-gray-900 dark:text-gray-100"}';

    // Container alignment
    final containerClasses = isUser ? 'flex justify-end' : 'flex justify-start';

    // Loading dots animation
    final loadingContent = Div(
      className: 'flex gap-1 items-center py-1',
      children: [
        Span(className: 'w-2 h-2 bg-gray-400 rounded-full animate-bounce', children: []),
        Span(
            className:
                'w-2 h-2 bg-gray-400 rounded-full animate-bounce [animation-delay:0.1s]',
            children: []),
        Span(
            className:
                'w-2 h-2 bg-gray-400 rounded-full animate-bounce [animation-delay:0.2s]',
            children: []),
      ],
    );

    return Div(
      className: containerClasses,
      children: [
        Div(
          className: 'flex items-end gap-2 ${isUser ? "flex-row-reverse" : ""}',
          children: [
            // Avatar
            if (showAvatar)
              avatar ??
                  DAvatar(
                    size: DAvatarSize.sm,
                    text: isUser ? 'U' : 'A',
                  ),
            // Message bubble and timestamp
            Div(
              className: 'flex flex-col ${isUser ? "items-end" : "items-start"}',
              children: [
                // Message bubble
                Div(
                  className: bubbleClasses,
                  children: [
                    if (message.isLoading)
                      loadingContent
                    else
                      P(
                          className: 'whitespace-pre-wrap break-words',
                          children: [Text(message.content)]),
                  ],
                ),
                // Timestamp
                if (showTimestamp && !message.isLoading)
                  Span(
                    className: 'text-xs text-gray-400 mt-1 px-1',
                    children: [Text(_formatTimestamp(message.timestamp))],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
