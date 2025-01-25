import 'dart:math' as Math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Represents a point with projected coordinates and its distance from the start
class _ProjectedPoint {
  Math.Point<double> projectedCoordinates;
  double distanceFromStart;

  _ProjectedPoint({
    required this.projectedCoordinates,
    required this.distanceFromStart,
  });
}

/// Manages a list of points with their projections and provides utilities for
/// calculating portions of the polyline
class ProjectedPointList {
  List<LatLng> _pointList = [];
  List<_ProjectedPoint> _points = [];
  double _totalProjectedLength = 0.0;
  late Crs _crs;

  /// Creates a new ProjectedPointList with the given points and optional CRS
  ///
  /// If no CRS is provided, defaults to EPSG:3857 (Web Mercator)
  ProjectedPointList(List<LatLng> pointList, [Crs? crs]) {
    if (pointList.isEmpty) {
      throw ArgumentError('Point list cannot be empty');
    }
    _pointList = List.from(pointList);
    _project(crs ?? Epsg3857());
  }

  void _project(Crs crs) {
    final projectedPoints = _pointList.map((coords) {
      final projectedCoords = crs.projection.project(coords);
      return _ProjectedPoint(
        projectedCoordinates: projectedCoords,
        distanceFromStart: 0.0,
      );
    }).toList();

    var entireLength = 0.0;
    for (var i = 1; i < projectedPoints.length; i++) {
      entireLength += _distance(
        projectedPoints[i - 1].projectedCoordinates,
        projectedPoints[i].projectedCoordinates,
      );
      projectedPoints[i].distanceFromStart = entireLength;
    }

    _totalProjectedLength = entireLength;
    _points = projectedPoints;
    _crs = crs;
  }

  /// Returns a portion of the polyline based on the given ratio (0.0 to 1.0)
  ///
  /// [portion] must be between 0.0 and 1.0 inclusive
  List<LatLng> portion(double portion) {
    if (portion < 0.0 || portion > 1.0) {
      throw ArgumentError('Portion must be between 0.0 and 1.0');
    }
    if (portion == 0.0) return [];
    if (portion == 1.0) return List.from(_pointList);
    if (_points.isEmpty) return [];

    final requestedLength = portion * _totalProjectedLength;
    final nextPointIndex = _points
        .indexWhere((point) => point.distanceFromStart >= requestedLength);

    if (nextPointIndex == -1) return List.from(_pointList);

    final newArr = _pointList.sublist(0, nextPointIndex);
    if (_points[nextPointIndex].distanceFromStart > requestedLength) {
      final previousPoint = _points[nextPointIndex - 1];
      final nextPoint = _points[nextPointIndex];
      newArr.add(_crs.projection.unproject(_pointBetween(
          previousPoint.projectedCoordinates,
          nextPoint.projectedCoordinates,
          requestedLength - previousPoint.distanceFromStart)));
    }
    return newArr;
  }
}

/// Calculates the Euclidean distance between two points
double _distance(Math.Point<double> pointA, Math.Point<double> pointB) {
  final dx = pointA.x - pointB.x;
  final dy = pointA.y - pointB.y;
  return Math.sqrt(dx * dx + dy * dy);
}

Math.Point<double> _pointBetween(Math.Point<double> pointA,
    Math.Point<double> pointB, double distanceFromPointA) {
  var distanceBetweenPoints = _distance(pointA, pointB);
  var newX = pointA.x +
      (distanceFromPointA / distanceBetweenPoints) * (pointB.x - pointA.x);
  var newY = pointA.y +
      (distanceFromPointA / distanceBetweenPoints) * (pointB.y - pointA.y);
  return Math.Point(newX, newY);
}
