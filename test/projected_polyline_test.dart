import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map_animated_polyline/flutter_map_animated_polyline.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('ProjectedPointList should', () {
    final testPoints = [
      LatLng(14.4793, 121.0198),
      LatLng(14.4499, 120.9833),
      LatLng(14.4316, 120.9142),
      LatLng(14.4123, 120.8833),
      LatLng(14.3899, 120.8142),
    ];

    group('when initialized', () {
      test('throw error on empty list', () {
        expect(
          () => ProjectedPointList([]),
          throwsArgumentError,
        );
      });

      test('accept valid point list', () {
        expect(
          () => ProjectedPointList(testPoints),
          returnsNormally,
        );
      });
    });

    group('when calculating portions', () {
      late ProjectedPointList projectedPoints;

      setUp(() {
        projectedPoints = ProjectedPointList(testPoints);
      });

      test('return empty list for 0.0 portion', () {
        expect(projectedPoints.portion(0.0), isEmpty);
      });

      test('return full list for 1.0 portion', () {
        expect(projectedPoints.portion(1.0), equals(testPoints));
      });

      test('throw error for invalid portion values', () {
        expect(
          () => projectedPoints.portion(-0.1),
          throwsArgumentError,
        );
        expect(
          () => projectedPoints.portion(1.1),
          throwsArgumentError,
        );
      });

      test('return intermediate points for portion between 0.0 and 1.0', () {
        final halfwayPoints = projectedPoints.portion(0.5);
        expect(halfwayPoints.length, greaterThan(0));
        expect(halfwayPoints.length, lessThanOrEqualTo(testPoints.length));
      });

      test('return correct points for small portion values', () {
        final points = projectedPoints.portion(0.1);
        expect(points.length, greaterThan(0));
        expect(points.first, equals(testPoints.first));
      });

      test('return correct points for large portion values', () {
        final points = projectedPoints.portion(0.9);
        expect(points.length, greaterThan(1));
        expect(points.first, equals(testPoints.first));
      });

      test('return intermediate points for valid portions', () {
        final halfwayPoints = projectedPoints.portion(0.5);
        expect(halfwayPoints.length, greaterThan(0));
        expect(halfwayPoints.length, lessThanOrEqualTo(testPoints.length));
      });

      test('return correct points for exact portion values', () {
        final points = projectedPoints.portion(0.333);
        expect(points.length, greaterThan(0));
        expect(points.first, equals(testPoints.first));

        final points2 = projectedPoints.portion(0.667);
        expect(points2.length, greaterThan(points.length));
        expect(points2.first, equals(testPoints.first));
      });

      test('handle consecutive portion calls correctly', () {
        final points1 = projectedPoints.portion(0.25);
        final points2 = projectedPoints.portion(0.5);
        final points3 = projectedPoints.portion(0.75);

        expect(points1.first, equals(testPoints.first));
        expect(points2.first, equals(testPoints.first));
        expect(points3.first, equals(testPoints.first));
        expect(points1.length, greaterThanOrEqualTo(2));
        expect(points2.length, greaterThanOrEqualTo(points1.length));
        expect(points3.length, greaterThanOrEqualTo(points2.length));
      });
    });
  });
}
