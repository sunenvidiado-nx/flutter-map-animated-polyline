import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class PolylineAnimationController {
  final TickerProvider vsync;
  AnimationController? _animationController;

  PolylineAnimationController({required this.vsync});

  void start({
    required double initialPortion,
    required double finishedPortion,
    Duration? animationDuration,
    Curve? animationCurve,
    ValueChanged<double>? onValueChange,
    VoidCallback? onFinish,
  }) {
    _animationController?.stop();
    _animationController?.dispose();
    _animationController =
        AnimationController(vsync: vsync, duration: animationDuration);

    var tween = Tween<double>(begin: initialPortion, end: finishedPortion);

    var animation = CurvedAnimation(
        parent: _animationController!, curve: animationCurve ?? Curves.ease);

    _animationController!.addListener(() {
      onValueChange?.call(tween.evaluate(animation));
    });

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController?.dispose();
        _animationController = null;
        onFinish?.call();
      }
    });
    _animationController!.forward();
  }

  void stop() {
    _animationController?.stop();
    _animationController?.dispose();
    _animationController = null;
  }

  bool get isAnimating => _animationController != null;
}
