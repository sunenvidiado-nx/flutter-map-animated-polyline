import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map_animated_polyline/flutter_map_animated_polyline.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PolylineAnimationController should', () {
    late PolylineAnimationController controller;

    setUp(() {
      controller = PolylineAnimationController(vsync: TestVSync());
    });

    tearDown(() {
      controller.stop();
    });

    group('when initialized', () {
      test('not be in animating state', () {
        expect(controller.isAnimating, false);
      });
    });

    group('when animation is started', () {
      test('change to animating state', () {
        controller.start(
          initialPortion: 0.0,
          finishedPortion: 1.0,
          animationDuration: const Duration(seconds: 1),
        );
        expect(controller.isAnimating, true);
        controller.stop();
      });

      testWidgets('call onValueChange callback', (WidgetTester tester) async {
        double? lastValue;
        controller.start(
          initialPortion: 0.0,
          finishedPortion: 1.0,
          animationDuration: const Duration(milliseconds: 100),
          animationCurve: Curves.easeInOut,
          onValueChange: (value) {
            lastValue = value;
          },
        );
        await tester.pump();
        expect(lastValue, isNotNull);
        expect(lastValue! >= 0.0 && lastValue! <= 1.0, true);
        controller.stop();
        await tester.pumpAndSettle();
      });

      testWidgets('handle custom animation curves',
          (WidgetTester tester) async {
        double? lastValue;
        controller.start(
          initialPortion: 0.0,
          finishedPortion: 1.0,
          animationDuration: const Duration(milliseconds: 100),
          animationCurve: Curves.bounceOut,
          onValueChange: (value) {
            lastValue = value;
          },
        );
        await tester.pump();
        expect(lastValue, isNotNull);
        controller.stop();
        await tester.pumpAndSettle();
      });

      testWidgets('call onFinish callback when completed',
          (WidgetTester tester) async {
        bool finished = false;
        controller.start(
          initialPortion: 0.0,
          finishedPortion: 1.0,
          animationDuration: const Duration(milliseconds: 100),
          onFinish: () {
            finished = true;
          },
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        expect(finished, true);
        await tester.pumpAndSettle();
      });
    });

    group('when animation is stopped', () {
      test('change to not animating state', () {
        controller.start(
          initialPortion: 0.0,
          finishedPortion: 1.0,
          animationDuration: const Duration(seconds: 1),
        );
        controller.stop();
        expect(controller.isAnimating, false);
      });
    });
  });
}

class TestVSync extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
