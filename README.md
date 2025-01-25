# flutter_map_animated_polyline

[![Tests](https://github.com/sunenvidiado-nx/flutter-map-animated-polyline/actions/workflows/test.yaml/badge.svg)](https://github.com/sunenvidiado-nx/flutter-map-animated-polyline/actions/workflows/test.yaml)
[![codecov](https://codecov.io/github/sunenvidiado-nx/flutter-map-animated-polyline/graph/badge.svg?token=5L9ZEZX78E)](https://codecov.io/github/sunenvidiado-nx/flutter-map-animated-polyline)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-52bdeb.svg?longCache=true)](https://github.com/Solido/awesome-flutter)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/sunenvidiado-nx/very-simple-state-manager/main/LICENSE)

This package is a modernized fork of the original `flutter_map_animated_polyline`, updated to work with the latest versions of Flutter and related packages. It provides smooth animation capabilities for polylines in `flutter_map`, allowing you to create animated paths on maps with customizable animation duration and curves.

## Improvements

- Updated for Flutter Map v6.x compatibility
- Full null safety implementation
- Modern Flutter SDK support (3.27.1+)
- Updated dependencies (`latlong2`, `maps_toolkit`)
- Improved type safety and error handling

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
// Create an animation controller
final controller = PolylineAnimationController(vsync: this);

// Define your route points
final route = [
  LatLng(14.4793, 121.0198),
  LatLng(14.4499, 120.9833),
  LatLng(14.4316, 120.9142),
];

// Start the animation
controller.start(
  initialPortion: 0.0,
  finishedPortion: 1.0,
  animationDuration: Duration(seconds: 2),
  animationCurve: Curves.easeInOut,
  onValueChange: (value) {
    // Update your polyline here
  },
);
```

For a complete example, check out the example directory in the repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
