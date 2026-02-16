import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/tw_merge.dart';

/// Slider sizes with serialization support for @client
enum DSliderSize {
  xs,
  sm,
  md,
  lg,
  xl;

  @encoder
  static String encode(DSliderSize value) => value.name;

  @decoder
  static DSliderSize decode(String value) => DSliderSize.values.byName(value);
}

/// DuxtUI Slider component - Range input with client-side interactivity
///
/// This component uses @client for hydration and manages its own state.
/// Listen to value changes via the 'input' event on the element.
@client
class DSlider extends StatefulComponent {
  final String? label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? name;
  final String size; // Use string for serialization: 'xs', 'sm', 'md', 'lg', 'xl'
  final String color; // Use string: 'primary', 'secondary', etc.
  final bool disabled;
  final bool showValue;
  final String? hint;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DSlider({
    super.key,
    this.label,
    this.value = 0,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.name,
    this.size = 'md',
    this.color = 'primary',
    this.disabled = false,
    this.showValue = false,
    this.hint,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  @override
  State<DSlider> createState() => _DSliderState();
}

class _DSliderState extends State<DSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = component.value;
  }

  String get _trackHeightClass {
    switch (component.size) {
      case 'xs':
        return 'h-1';
      case 'sm':
        return 'h-1.5';
      case 'lg':
        return 'h-2.5';
      case 'xl':
        return 'h-3';
      default:
        return 'h-2';
    }
  }

  String get _accentColor {
    switch (component.color) {
      case 'secondary':
        return 'accent-blue-500';
      case 'success':
        return 'accent-green-500';
      case 'info':
        return 'accent-blue-500';
      case 'warning':
        return 'accent-yellow-500';
      case 'error':
        return 'accent-red-500';
      case 'neutral':
        return 'accent-slate-500';
      default:
        return 'accent-cyan-500';
    }
  }

  void _handleInput(String value) {
    final doubleValue = double.tryParse(value) ?? component.min;
    setState(() => _value = doubleValue);
  }

  @override
  Component build(BuildContext context) {
    final baseClasses = cx([
      'w-full',
      _trackHeightClass,
      'bg-gray-200',
      'dark:bg-zinc-700',
      'rounded-lg',
      'appearance-none',
      'cursor-pointer',
      _accentColor,
      component.disabled ? 'opacity-50 cursor-not-allowed' : null,
    ]);

    return Div(className: 'space-y-2', children: [
      if (component.label != null || component.showValue)
        Div(className: 'flex justify-between items-center', children: [
          if (component.label != null)
            Span(
              className:
                  'block text-sm font-medium text-gray-700 dark:text-gray-200',
              children: [Text(component.label!)],
            )
          else
            Span(children: []),
          if (component.showValue)
            Span(
              className: 'text-sm font-medium text-gray-500 dark:text-gray-400',
              children: [
                Text(
                    _value.toStringAsFixed(component.step < 1 ? 1 : 0))
              ],
            ),
        ]),
      Input(
        type: 'range',
        name: component.name,
        id: component.id,
        value: _value.toString(),
        disabled: component.disabled,
        className: twMerge(baseClasses, component.className),
        attributes: mergeAttributes({
          'min': component.min.toString(),
          'max': component.max.toString(),
          'step': component.step.toString(),
        }, component.attributes),
        events: {
          'input': (event) {
            final target = event.target as dynamic;
            _handleInput(target.value as String);
          },
          ...?component.events,
        },
      ),
      if (component.hint != null)
        P(
          className: 'text-sm text-gray-500 dark:text-gray-400',
          children: [Text(component.hint!)],
        ),
    ]);
  }
}
