import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animated_polyline/flutter_map_animated_polyline.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Polyline Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Animated Polyline Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final PolylineAnimationController _controller;
  late final ProjectedPointList _projectedPoints;
  double _portion = 0.0;
  bool _isAnimating = false;

  final List<LatLng> _route = [
    LatLng(14.4793, 121.0198), // Paranaque City
    LatLng(14.4499, 120.9833), // Las Pinas
    LatLng(14.4316, 120.9142), // Bacoor City
  ];

  @override
  void initState() {
    super.initState();
    _controller = PolylineAnimationController(vsync: this);
    _projectedPoints = ProjectedPointList(_route);
  }

  void _startAnimation() {
    if (!_isAnimating) {
      _controller.start(
        initialPortion: _portion,
        finishedPortion: 1.0,
        animationDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
        onValueChange: (value) {
          setState(() {
            _portion = value;
          });
        },
        onFinish: () {
          setState(() {
            _isAnimating = false;
          });
        },
      );
      setState(() {
        _isAnimating = true;
      });
    }
  }

  void _resetAnimation() {
    _controller.stop();
    setState(() {
      _portion = 0.0;
      _isAnimating = false;
    });
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(14.5995, 120.9842), // Center on Manila
              initialZoom: 10,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _projectedPoints.portion(_portion),
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isAnimating ? null : _startAnimation,
                      child: const Text('Start Animation'),
                    ),
                    ElevatedButton(
                      onPressed: _isAnimating ? _resetAnimation : null,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
