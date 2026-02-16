/// Simple Tailwind CSS class merger for duxt_ui.
///
/// When [overrides] are provided, they replace conflicting classes
/// from [base] in the same utility group. This lets users override
/// bg-color, text-color, border, rounded, etc. without fighting specificity.
///
/// Example:
/// ```dart
/// twMerge('bg-cyan-500 text-white rounded-md p-4', 'bg-red-500 rounded-full')
/// // => 'text-white p-4 bg-red-500 rounded-full'
/// ```
String twMerge(String base, String? overrides) {
  if (overrides == null || overrides.isEmpty) return base.trim();

  final baseTokens = base.split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
  final overrideTokens =
      overrides.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();

  // Build set of group keys from overrides
  final overrideKeys = <String>{};
  for (final cls in overrideTokens) {
    final key = _groupKey(cls);
    if (key != null) overrideKeys.add(key);
  }

  // Keep base classes that don't conflict with overrides
  final kept = <String>[];
  for (final cls in baseTokens) {
    final key = _groupKey(cls);
    if (key != null && overrideKeys.contains(key)) continue;
    kept.add(cls);
  }

  return [...kept, ...overrideTokens].join(' ');
}

/// Merge attributes maps (override wins for same key).
Map<String, String>? mergeAttributes(
    Map<String, String>? base, Map<String, String>? overrides) {
  if (base == null && overrides == null) return null;
  if (base == null) return overrides;
  if (overrides == null) return base;
  return {...base, ...overrides};
}

/// Extract a group key for a Tailwind class.
/// Classes in the same group conflict — only one should remain.
/// Returns null for classes we don't group (they always stay).
String? _groupKey(String cls) {
  // Strip variant prefixes: dark:, hover:, focus:, sm:, md:, lg:, xl:, etc.
  var prefix = '';
  var base = cls;
  final variantPattern = RegExp(
      r'^((?:(?:sm|md|lg|xl|2xl|dark|hover|focus|focus-visible|focus-within|active|disabled|group-hover|peer-hover|first|last|odd|even|aria-disabled):)*)');
  final match = variantPattern.firstMatch(base);
  if (match != null && match.group(0)!.isNotEmpty) {
    prefix = match.group(0)!;
    base = base.substring(prefix.length);
  }

  // Negative values
  if (base.startsWith('-')) base = base.substring(1);

  // Background
  if (base.startsWith('bg-')) return '${prefix}bg';

  // Text color vs text size
  if (base.startsWith('text-')) {
    if (_isTextSize(base)) return '${prefix}text-size';
    return '${prefix}text-color';
  }

  // Font weight
  if (base.startsWith('font-')) {
    if (_isFontWeight(base)) return '${prefix}font-weight';
    return '${prefix}font-family';
  }

  // Border radius
  if (base.startsWith('rounded')) return '${prefix}rounded';

  // Border width + color
  if (base.startsWith('border-')) {
    if (_isBorderWidth(base)) return '${prefix}border-width';
    return '${prefix}border-color';
  }
  if (base == 'border') return '${prefix}border-width';

  // Ring
  if (base.startsWith('ring-') || base == 'ring') return '${prefix}ring';

  // Shadow
  if (base.startsWith('shadow')) return '${prefix}shadow';

  // Opacity
  if (base.startsWith('opacity-')) return '${prefix}opacity';

  // Padding
  if (base.startsWith('p-')) return '${prefix}p';
  if (base.startsWith('px-')) return '${prefix}px';
  if (base.startsWith('py-')) return '${prefix}py';
  if (base.startsWith('pt-')) return '${prefix}pt';
  if (base.startsWith('pb-')) return '${prefix}pb';
  if (base.startsWith('pl-')) return '${prefix}pl';
  if (base.startsWith('pr-')) return '${prefix}pr';
  if (base.startsWith('ps-')) return '${prefix}ps';
  if (base.startsWith('pe-')) return '${prefix}pe';

  // Margin
  if (base.startsWith('m-')) return '${prefix}m';
  if (base.startsWith('mx-')) return '${prefix}mx';
  if (base.startsWith('my-')) return '${prefix}my';
  if (base.startsWith('mt-')) return '${prefix}mt';
  if (base.startsWith('mb-')) return '${prefix}mb';
  if (base.startsWith('ml-')) return '${prefix}ml';
  if (base.startsWith('mr-')) return '${prefix}mr';
  if (base.startsWith('ms-')) return '${prefix}ms';
  if (base.startsWith('me-')) return '${prefix}me';

  // Width / height
  if (base.startsWith('w-')) return '${prefix}w';
  if (base.startsWith('h-')) return '${prefix}h';
  if (base.startsWith('min-w-')) return '${prefix}min-w';
  if (base.startsWith('max-w-')) return '${prefix}max-w';
  if (base.startsWith('min-h-')) return '${prefix}min-h';
  if (base.startsWith('max-h-')) return '${prefix}max-h';
  if (base.startsWith('size-')) return '${prefix}size';

  // Gap
  if (base.startsWith('gap-')) return '${prefix}gap';

  // Display
  if (_isDisplay(base)) return '${prefix}display';

  // Position
  if (_isPosition(base)) return '${prefix}position';

  // Overflow
  if (base.startsWith('overflow-')) return '${prefix}overflow';

  // Z-index
  if (base.startsWith('z-')) return '${prefix}z';

  // Cursor
  if (base.startsWith('cursor-')) return '${prefix}cursor';

  return null;
}

bool _isTextSize(String cls) {
  const sizes = {
    'text-xs', 'text-sm', 'text-base', 'text-lg', 'text-xl',
    'text-2xl', 'text-3xl', 'text-4xl', 'text-5xl', 'text-6xl',
    'text-7xl', 'text-8xl', 'text-9xl',
  };
  return sizes.contains(cls);
}

bool _isFontWeight(String cls) {
  const weights = {
    'font-thin', 'font-extralight', 'font-light', 'font-normal',
    'font-medium', 'font-semibold', 'font-bold', 'font-extrabold',
    'font-black',
  };
  return weights.contains(cls);
}

bool _isBorderWidth(String cls) {
  const widths = {'border-0', 'border-2', 'border-4', 'border-8'};
  return widths.contains(cls);
}

bool _isDisplay(String cls) {
  const displays = {
    'block', 'inline', 'inline-block', 'flex', 'inline-flex',
    'grid', 'inline-grid', 'hidden', 'table', 'contents', 'flow-root',
  };
  return displays.contains(cls);
}

bool _isPosition(String cls) {
  const positions = {'static', 'fixed', 'absolute', 'relative', 'sticky'};
  return positions.contains(cls);
}
