import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../components/utility/icon.dart';
import 'provider.dart';

/// DuxtUI ColorModeSelect component - Dropdown for theme selection
///
/// A dropdown select that allows choosing between Light, Dark, and System
/// theme modes. Shows current selection with icon.
class DColorModeSelect extends StatefulComponent {
  /// Currently selected mode
  final DThemeMode selectedMode;

  /// Callback when mode changes
  final ValueChanged<DThemeMode>? onModeChange;

  /// Custom CSS classes
  final String? classes;

  const DColorModeSelect({
    super.key,
    this.selectedMode = DThemeMode.system,
    this.onModeChange,
    this.classes,
  });

  @override
  State createState() => _UColorModeSelectState();
}

class _UColorModeSelectState extends State<DColorModeSelect> {
  late DThemeMode _currentMode;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _currentMode = component.selectedMode;
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _selectMode(DThemeMode mode) {
    setState(() {
      _currentMode = mode;
      _isOpen = false;
    });
    component.onModeChange?.call(mode);
  }

  String _getModeLabel(DThemeMode mode) {
    switch (mode) {
      case DThemeMode.light:
        return 'Light';
      case DThemeMode.dark:
        return 'Dark';
      case DThemeMode.system:
        return 'System';
    }
  }

  String _getModeIcon(DThemeMode mode) {
    switch (mode) {
      case DThemeMode.light:
        return DIconNames.sun;
      case DThemeMode.dark:
        return DIconNames.moon;
      case DThemeMode.system:
        return DIconNames.system;
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'relative inline-block ${component.classes ?? ""}',
      children: [
        // Trigger button
        Button(
          type: 'button',
          onClick: _toggleDropdown,
          className: [
            'inline-flex items-center justify-between gap-2 px-3 py-2',
            'bg-white dark:bg-zinc-800 border border-gray-300 dark:border-gray-600',
            'rounded-lg shadow-sm min-w-[140px]',
            'text-sm text-gray-700 dark:text-gray-200',
            'hover:bg-gray-50 dark:hover:bg-gray-700',
            'focus:outline-none focus:ring-2 focus:ring-cyan-500',
            'transition-colors',
          ].join(' '),
          attributes: {
            'aria-haspopup': 'listbox',
            'aria-expanded': _isOpen ? 'true' : 'false',
          },
          children: [
            // Current selection
            Span(
              className: 'flex items-center gap-2',
              children: [
                DIcon(
                  name: _getModeIcon(_currentMode),
                  size: DIconSize.sm,
                  color: 'text-gray-500 dark:text-gray-400',
                ),
                Text(_getModeLabel(_currentMode)),
              ],
            ),
            // Dropdown arrow
            DIcon(
              name: DIconNames.chevronDown,
              size: DIconSize.xs,
              classes: [
                'transition-transform',
                if (_isOpen) 'rotate-180',
              ].join(' '),
            ),
          ],
        ),

        // Dropdown menu
        if (_isOpen)
          Div(
            className: [
              'absolute z-10 mt-1 w-full',
              'bg-white dark:bg-zinc-800',
              'border border-gray-200 dark:border-gray-700',
              'rounded-lg shadow-lg',
              'py-1',
            ].join(' '),
            attributes: {'role': 'listbox'},
            children: [
              for (final mode in DThemeMode.values) _buildOption(mode),
            ],
          ),
      ],
    );
  }

  Component _buildOption(DThemeMode mode) {
    final isSelected = mode == _currentMode;

    return Button(
      type: 'button',
      onClick: () => _selectMode(mode),
      className: [
        'w-full flex items-center gap-2 px-3 py-2 text-sm',
        'transition-colors',
        if (isSelected)
          'bg-cyan-50 dark:bg-cyan-900/20 text-cyan-600 dark:text-cyan-400'
        else
          'text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700',
      ].join(' '),
      attributes: {
        'role': 'option',
        'aria-selected': isSelected ? 'true' : 'false',
      },
      children: [
        DIcon(
          name: _getModeIcon(mode),
          size: DIconSize.sm,
          color: isSelected
              ? 'text-cyan-500'
              : 'text-gray-400 dark:text-gray-500',
        ),
        Text(_getModeLabel(mode)),
        if (isSelected)
          Span(
            className: 'ml-auto',
            children: [
              DIcon(
                name: DIconNames.check,
                size: DIconSize.sm,
                color: 'text-cyan-500',
              ),
            ],
          ),
      ],
    );
  }
}
