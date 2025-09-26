import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

class AnimatedMapController {
  AnimatedMapController({
    required this.mapController,
    required this.vsync,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });
  final MapController mapController;
  final TickerProvider vsync;
  final Duration duration;
  final Curve curve;

  /// Animate the map to a new [destination] location and optional [zoom].
  void move({required LatLng destination, double? zoom}) {
    final startLat = mapController.camera.center.latitude;
    final startLng = mapController.camera.center.longitude;
    final startZoom = mapController.camera.zoom;
    final targetZoom = zoom ?? startZoom;

    final controller = AnimationController(vsync: vsync, duration: duration);
    final animation = CurvedAnimation(parent: controller, curve: curve);

    final latTween = Tween<double>(begin: startLat, end: destination.latitude);
    final lngTween = Tween<double>(begin: startLng, end: destination.longitude);
    final zoomTween = Tween<double>(begin: startZoom, end: targetZoom);

    animation.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.forward().then((_) => controller.dispose());
  }
}
