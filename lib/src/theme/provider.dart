import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import 'colors.dart';

/// Theme mode for dark/light switching
enum DThemeMode { light, dark, system }

/// Theme configuration for DuxtUI
class DThemeConfig {
  final DColor primaryColor;
  final DColor secondaryColor;
  final DColor successColor;
  final DColor infoColor;
  final DColor warningColor;
  final DColor errorColor;
  final DThemeMode mode;

  const DThemeConfig({
    this.primaryColor = DColor.primary,
    this.secondaryColor = DColor.secondary,
    this.successColor = DColor.success,
    this.infoColor = DColor.info,
    this.warningColor = DColor.warning,
    this.errorColor = DColor.error,
    this.mode = DThemeMode.system,
  });

  static const DThemeConfig defaultConfig = DThemeConfig();
}

/// Theme provider that wraps the app and provides theme context
class DThemeProvider extends StatefulComponent {
  final DThemeConfig config;
  final Component child;

  const DThemeProvider({
    super.key,
    this.config = DThemeConfig.defaultConfig,
    required this.child,
  });

  @override
  State createState() => _UThemeProviderState();
}

class _UThemeProviderState extends State<DThemeProvider> {
  late DThemeMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = component.config.mode;
  }

  String get _themeClass {
    switch (_currentMode) {
      case DThemeMode.dark:
        return 'dark';
      case DThemeMode.light:
        return '';
      case DThemeMode.system:
        // In browser, this would check prefers-color-scheme
        // For now, default to light
        return '';
    }
  }

  void toggleTheme() {
    setState(() {
      _currentMode = _currentMode == DThemeMode.dark ? DThemeMode.light : DThemeMode.dark;
    });
  }

  void setTheme(DThemeMode mode) {
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: _themeClass,
      children: [component.child],
    );
  }
}

/// App wrapper component that sets up the theme and base styles
class DApp extends StatelessComponent {
  final DThemeConfig theme;
  final Component child;

  const DApp({
    super.key,
    this.theme = DThemeConfig.defaultConfig,
    required this.child,
  });

  @override
  Component build(BuildContext context) {
    return DThemeProvider(
      config: theme,
      child: Div(
        className: 'min-h-screen bg-white dark:bg-zinc-900 text-gray-900 dark:text-gray-100 antialiased',
        children: [child],
      ),
    );
  }
}
