import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';

/// Keyboard key size variants
enum DKbdSize { xs, sm, md }

/// DuxtUI Kbd component - keyboard key display
class DKbd extends StatelessComponent {
  final String? value;
  final List<String>? keys;
  final DKbdSize size;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DKbd({
    super.key,
    this.value,
    this.keys,
    this.size = DKbdSize.sm,
    this.className,
    this.id,
    this.attributes,
    this.events,
  }) : assert(value != null || keys != null,
            'Either value or keys must be provided');

  String get _sizeClasses {
    switch (size) {
      case DKbdSize.xs:
        return 'px-1 py-0.5 text-[10px]';
      case DKbdSize.sm:
        return 'px-1.5 py-0.5 text-xs';
      case DKbdSize.md:
        return 'px-2 py-1 text-sm';
    }
  }

  @override
  Component build(BuildContext context) {
    final baseClasses =
        'inline-flex items-center justify-center font-mono font-medium bg-gray-100 dark:bg-zinc-800 border border-gray-300 dark:border-gray-600 rounded shadow-sm';

    // If multiple keys (shortcut), render with separator
    if (keys != null && keys!.isNotEmpty) {
      final List<Component> keyComponents = [];

      for (var i = 0; i < keys!.length; i++) {
        keyComponents.add(
          Kbd(
            className: '$baseClasses $_sizeClasses'.trim(),
            children: [Text(_formatKey(keys![i]))],
          ),
        );

        if (i < keys!.length - 1) {
          keyComponents.add(
            Span(
              className: 'mx-0.5 text-gray-400 dark:text-gray-500 text-xs',
              children: [Text('+')],
            ),
          );
        }
      }

      return Span(
        id: id,
        attributes: attributes,
        events: events,
        className: twMerge('inline-flex items-center gap-0.5', className),
        children: keyComponents,
      );
    }

    // Single key
    return Kbd(
      id: id,
      attributes: attributes,
      events: events,
      className: twMerge('$baseClasses $_sizeClasses', className),
      children: [Text(_formatKey(value!))],
    );
  }

  /// Format special key names to their symbols
  String _formatKey(String key) {
    final keyMap = {
      'cmd': '\u2318',
      'command': '\u2318',
      'ctrl': '\u2303',
      'control': '\u2303',
      'alt': '\u2325',
      'option': '\u2325',
      'opt': '\u2325',
      'shift': '\u21E7',
      'enter': '\u23CE',
      'return': '\u23CE',
      'tab': '\u21E5',
      'esc': '\u238B',
      'escape': '\u238B',
      'backspace': '\u232B',
      'delete': '\u2326',
      'up': '\u2191',
      'down': '\u2193',
      'left': '\u2190',
      'right': '\u2192',
      'space': '\u2423',
      'caps': '\u21EA',
      'capslock': '\u21EA',
    };

    final lowerKey = key.toLowerCase();
    return keyMap[lowerKey] ?? key.toUpperCase();
  }
}

/// DuxtUI Shortcut component - display keyboard shortcuts
class DShortcut extends StatelessComponent {
  final List<String> keys;
  final DKbdSize size;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DShortcut({
    super.key,
    required this.keys,
    this.size = DKbdSize.sm,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    return DKbd(
      keys: keys,
      size: size,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
    );
  }
}

/// Platform-aware shortcut that shows Cmd on Mac, Ctrl on others
class DPlatformShortcut extends StatelessComponent {
  final String keyName;
  final bool withShift;
  final bool withAlt;
  final DKbdSize size;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DPlatformShortcut({
    super.key,
    required this.keyName,
    this.withShift = false,
    this.withAlt = false,
    this.size = DKbdSize.sm,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  Component build(BuildContext context) {
    // In a real implementation, you'd detect platform
    // For now, showing Mac-style (Cmd)
    final keys = <String>[
      'cmd',
      if (withShift) 'shift',
      if (withAlt) 'alt',
      keyName,
    ];

    return DKbd(
      keys: keys,
      size: size,
      className: className,
      id: id,
      attributes: attributes,
      events: events,
    );
  }
}
