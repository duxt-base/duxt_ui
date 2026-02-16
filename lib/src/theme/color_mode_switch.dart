import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../components/utility/icon.dart';
import '../theme/tw_merge.dart';
import 'provider.dart';

/// DuxtUI ColorModeSwitch component - Switch toggle for dark/light mode
///
/// A toggle switch with sun and moon icons for theme switching.
/// Shows current mode visually with animated transition.
class DColorModeSwitch extends StatefulComponent {
  /// Initial mode
  final DThemeMode initialMode;

  /// Callback when mode changes
  final ValueChanged<DThemeMode>? onModeChange;

  /// Custom CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Custom HTML attributes
  final Map<String, String>? attributes;

  /// Custom event handlers
  final Map<String, EventCallback>? events;

  const DColorModeSwitch({
    super.key,
    this.initialMode = DThemeMode.light,
    this.onModeChange,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  State createState() => _UColorModeSwitchState();
}

class _UColorModeSwitchState extends State<DColorModeSwitch> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = component.initialMode == DThemeMode.dark;
  }

  void _toggle() {
    setState(() {
      _isDark = !_isDark;
    });
    final newMode = _isDark ? DThemeMode.dark : DThemeMode.light;
    component.onModeChange?.call(newMode);
  }

  @override
  Component build(BuildContext context) {
    final baseClasses = [
      'relative inline-flex h-8 w-16 items-center rounded-full',
      'transition-colors duration-200 ease-in-out',
      'focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:ring-offset-2',
      _isDark ? 'bg-cyan-600' : 'bg-gray-200 dark:bg-zinc-700',
    ].join(' ');

    return Button(
      type: 'button',
      id: component.id,
      onClick: _toggle,
      className: twMerge(baseClasses, component.className),
      attributes: mergeAttributes({
        'role': 'switch',
        'aria-checked': _isDark ? 'true' : 'false',
        'aria-label': 'Toggle dark mode',
      }, component.attributes),
      events: component.events,
      children: [
        // Switch track with icons
        Span(
          className: 'sr-only',
          children: [
            Text(_isDark ? 'Dark mode enabled' : 'Light mode enabled')
          ],
        ),

        // Sun icon (left side)
        Span(
          className: [
            'absolute left-1.5 flex items-center justify-center',
            'text-yellow-500 transition-opacity',
            _isDark ? 'opacity-100' : 'opacity-40',
          ].join(' '),
          children: [
            DIcon(name: DIconNames.sun, size: DIconSize.xs),
          ],
        ),

        // Moon icon (right side)
        Span(
          className: [
            'absolute right-1.5 flex items-center justify-center',
            'text-cyan-300 transition-opacity',
            _isDark ? 'opacity-40' : 'opacity-100',
          ].join(' '),
          children: [
            DIcon(name: DIconNames.moon, size: DIconSize.xs),
          ],
        ),

        // Switch thumb/knob
        Span(
          className: [
            'inline-block h-6 w-6 transform rounded-full bg-white shadow-lg',
            'transition-transform duration-200 ease-in-out',
            _isDark ? 'translate-x-8' : 'translate-x-1',
          ].join(' '),
          children: [],
        ),
      ],
    );
  }
}
