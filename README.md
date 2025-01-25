# flutter_map_animated_polyline

[![Tests](https://github.com/sunenvidiado-nx/flutter-map-animated-polyline/actions/workflows/test.yaml/badge.svg)](https://github.com/sunenvidiado-nx/flutter-map-animated-polyline/actions/workflows/test.yaml)
[![codecov](https://codecov.io/github/sunenvidiado-nx/flutter-map-animated-polyline/graph/badge.svg?token=5L9ZEZX78E)](https://codecov.io/github/sunenvidiado-nx/flutter-map-animated-polyline)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-52bdeb.svg?longCache=true)](https://github.com/Solido/awesome-flutter)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/sunenvidiado-nx/very-simple-state-manager/main/LICENSE)

This package is a modernized fork of the original `flutter_map_animated_polyline`, updated to work with the latest versions of Flutter and related packages. It provides smooth animation capabilities for polylines in `flutter_map`, allowing you to create animated paths on maps with customizable animation duration and curves.

## Features

- Smooth polyline animation on `flutter_map`
- Customizable animation duration and curves
- Simple API for controlling animations
- Support for complex paths with multiple points

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_map_animated_polyline: any
```

## Usage

```dart
class MapExample extends StatefulWidget {
  @override
  State<MapExample> createState() => _MapExampleState();
}

class _MapExampleState extends State<MapExample> with TickerProviderStateMixin {
  late final PolylineAnimationController _controller;
  late final ProjectedPointList _projectedPoints;
  double _portion = 0.0;

  final List<LatLng> _route = [
    LatLng(14.4793, 121.0198),
    LatLng(14.4499, 120.9833),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PolylineAnimationController(vsync: this);
    _projectedPoints = ProjectedPointList(_route);
  }

  void _animate() {
    _controller.start(
      initialPortion: _portion,
      finishedPortion: 1.0,
      animationDuration: const Duration(seconds: 2),
      animationCurve: Curves.easeInOut,
      onValueChange: (value) => setState(() => _portion = value),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: _route[0],
        zoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: '', // Replace with your tile layer URL
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: _projectedPoints.getPointsForPortion(_portion),
              strokeWidth: 4,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
```

For a complete example, check out the example directory in the repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
