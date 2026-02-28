import 'package:jaspr_test/jaspr_test.dart';
import 'package:duxt_ui/src/components/form/slider.dart';
import 'package:duxt_ui/src/theme/colors.dart';

void main() {
  group('DSlider', () {
    group('rendering', () {
      testComponents('renders with default props', (tester) async {
        tester.pumpComponent(DSlider());

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders with label', (tester) async {
        tester.pumpComponent(
          DSlider(label: 'Volume'),
        );

        expect(find.text('Volume'), findsOneComponent);
        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders with custom value', (tester) async {
        tester.pumpComponent(
          DSlider(value: 50),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders with hint text', (tester) async {
        tester.pumpComponent(
          DSlider(
            label: 'Brightness',
            hint: 'Adjust screen brightness',
          ),
        );

        expect(find.text('Brightness'), findsOneComponent);
        expect(find.text('Adjust screen brightness'), findsOneComponent);
      });

      testComponents('renders with showValue enabled', (tester) async {
        tester.pumpComponent(
          DSlider(
            label: 'Progress',
            value: 75,
            showValue: true,
          ),
        );

        expect(find.text('Progress'), findsOneComponent);
        expect(find.text('75'), findsOneComponent);
      });

      testComponents('renders without label when not provided', (tester) async {
        tester.pumpComponent(
          DSlider(value: 25),
        );

        expect(find.tag('input'), findsOneComponent);
      });
    });

    group('range configuration', () {
      testComponents('renders with custom min and max', (tester) async {
        tester.pumpComponent(
          DSlider(
            min: 10,
            max: 200,
            value: 100,
          ),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders with custom step', (tester) async {
        tester.pumpComponent(
          DSlider(
            min: 0,
            max: 100,
            step: 5,
            value: 50,
          ),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders with decimal step for precision', (tester) async {
        tester.pumpComponent(
          DSlider(
            min: 0,
            max: 1,
            step: 0.1,
            value: 0.5,
            showValue: true,
          ),
        );

        expect(find.tag('input'), findsOneComponent);
        expect(find.text('0.5'), findsOneComponent);
      });
    });

    group('sizes', () {
      testComponents('renders xs size', (tester) async {
        tester.pumpComponent(
          DSlider(size: DSliderSize.xs),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders sm size', (tester) async {
        tester.pumpComponent(
          DSlider(size: DSliderSize.sm),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders md size (default)', (tester) async {
        tester.pumpComponent(
          DSlider(size: DSliderSize.md),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders lg size', (tester) async {
        tester.pumpComponent(
          DSlider(size: DSliderSize.lg),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders xl size', (tester) async {
        tester.pumpComponent(
          DSlider(size: DSliderSize.xl),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders all sizes', (tester) async {
        for (final size in DSliderSize.values) {
          tester.pumpComponent(
            DSlider(size: size),
          );

          expect(find.tag('input'), findsOneComponent);
        }
      });
    });

    group('colors', () {
      testComponents('renders primary color (default)', (tester) async {
        tester.pumpComponent(
          DSlider(color: DColor.primary),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders secondary color', (tester) async {
        tester.pumpComponent(
          DSlider(color: DColor.secondary),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders success color', (tester) async {
        tester.pumpComponent(
          DSlider(color: DColor.success),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders warning color', (tester) async {
        tester.pumpComponent(
          DSlider(color: DColor.warning),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders error color', (tester) async {
        tester.pumpComponent(
          DSlider(color: DColor.error),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders neutral color', (tester) async {
        tester.pumpComponent(
          DSlider(color: DColor.neutral),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders all colors', (tester) async {
        for (final color in DColor.values) {
          tester.pumpComponent(
            DSlider(color: color),
          );

          expect(find.tag('input'), findsOneComponent);
        }
      });
    });

    group('states', () {
      testComponents('renders disabled state', (tester) async {
        tester.pumpComponent(
          DSlider(disabled: true),
        );

        expect(find.tag('input'), findsOneComponent);
      });

      testComponents('renders enabled state by default', (tester) async {
        tester.pumpComponent(
          DSlider(),
        );

        expect(find.tag('input'), findsOneComponent);
      });
    });

    group('form integration', () {
      testComponents('renders with name attribute', (tester) async {
        tester.pumpComponent(
          DSlider(name: 'volume_slider'),
        );

        expect(find.tag('input'), findsOneComponent);
      });
    });

    group('interactions', () {
      testComponents('onChange callback can be set', (tester) async {
        double? changedValue;
        tester.pumpComponent(
          DSlider(
            value: 50,
            onChange: (value) {
              changedValue = value;
            },
          ),
        );

        expect(find.tag('input'), findsOneComponent);
      });
    });

    group('complete configurations', () {
      testComponents('renders with all props', (tester) async {
        tester.pumpComponent(
          DSlider(
            label: 'Sound Volume',
            value: 60,
            min: 0,
            max: 100,
            step: 5,
            name: 'sound_volume',
            size: DSliderSize.lg,
            color: DColor.primary,
            disabled: false,
            showValue: true,
            hint: 'Adjust the sound level',
          ),
        );

        expect(find.tag('input'), findsOneComponent);
        expect(find.text('Sound Volume'), findsOneComponent);
        expect(find.text('60'), findsOneComponent);
        expect(find.text('Adjust the sound level'), findsOneComponent);
      });

      testComponents('renders with label and value display', (tester) async {
        tester.pumpComponent(
          DSlider(
            label: 'Opacity',
            value: 80,
            showValue: true,
          ),
        );

        expect(find.text('Opacity'), findsOneComponent);
        expect(find.text('80'), findsOneComponent);
      });
    });
  });
}
