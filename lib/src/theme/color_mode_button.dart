import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../components/utility/icon.dart';
import 'provider.dart';

/// Button sizes for color mode toggle
enum DColorModeButtonSize { xs, sm, md, lg, xl }

/// DuxtUI ColorModeButton component - Toggle dark/light mode
///
/// An icon button that toggles between light and dark themes.
/// Shows sun icon in dark mode and moon icon in light mode.
class DColorModeButton extends StatefulComponent {
  /// Size of the button
  final DColorModeButtonSize size;

  /// Custom CSS classes
  final String? classes;

  /// Callback when theme changes
  final ValueChanged<DThemeMode>? onModeChange;

  const DColorModeButton({
    super.key,
    this.size = DColorModeButtonSize.md,
    this.classes,
    this.onModeChange,
  });

  @override
  State createState() => _UColorModeButtonState();
}

class _UColorModeButtonState extends State<DColorModeButton> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    // Check initial state from DOM
    _checkDarkMode();
  }

  void _checkDarkMode() {
    // In browser context, check if dark class is on html/body
    // For now, default to false
    _isDark = false;
  }

  void _toggleMode() {
    setState(() {
      _isDark = !_isDark;
    });
    final newMode = _isDark ? DThemeMode.dark : DThemeMode.light;
    component.onModeChange?.call(newMode);

    // Toggle dark class on document
    // This is a simplified implementation - in production,
    // you'd use a proper theme context/provider
  }

  String get _buttonSizeClasses {
    switch (component.size) {
      case DColorModeButtonSize.xs:
        return 'p-1';
      case DColorModeButtonSize.sm:
        return 'p-1.5';
      case DColorModeButtonSize.md:
        return 'p-2';
      case DColorModeButtonSize.lg:
        return 'p-2.5';
      case DColorModeButtonSize.xl:
        return 'p-3';
    }
  }

  DIconSize get _iconSize {
    switch (component.size) {
      case DColorModeButtonSize.xs:
        return DIconSize.xs;
      case DColorModeButtonSize.sm:
        return DIconSize.sm;
      case DColorModeButtonSize.md:
        return DIconSize.md;
      case DColorModeButtonSize.lg:
        return DIconSize.lg;
      case DColorModeButtonSize.xl:
        return DIconSize.xl;
    }
  }

  @override
  Component build(BuildContext context) {
    return Button(
      type: 'button',
      onClick: _toggleMode,
      className: [
        'inline-flex items-center justify-center rounded-lg',
        'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200',
        'hover:bg-gray-100 dark:hover:bg-gray-800',
        'focus:outline-none focus:ring-2 focus:ring-gray-300 dark:focus:ring-gray-600',
        'transition-colors',
        _buttonSizeClasses,
        if (component.classes != null) component.classes!,
      ].join(' '),
      attributes: {
        'aria-label': _isDark ? 'Switch to light mode' : 'Switch to dark mode',
      },
      children: [
        // Show sun in dark mode (to switch to light), moon in light mode (to switch to dark)
        if (_isDark)
          DIcon(name: DIconNames.sun, size: _iconSize)
        else
          DIcon(name: DIconNames.moon, size: _iconSize),
      ],
    );
  }
}
