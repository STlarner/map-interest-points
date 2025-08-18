import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:url_launcher/url_launcher.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Map 8 Example')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(37.7749, -122.4194),
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            print('Tapped at $point');
          },
          onPositionChanged: (position, hasGesture) {
            print('Map moved to ${position.center}, zoom ${position.zoom}');
          },
        ),
        children: [
          TileLayer(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"),
          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(37.7749, -122.4194),
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    print('Marker tapped!');
                  },
                  child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
                ),
              ),
            ],
          ),

          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                "OpenStreetMap contributors",
                onTap: () =>
                    launchUrl(Uri.parse("https://openstreetmap.org/copyright")), // (external)
              ),
              // Also add images...
            ],
          ),
        ],
      ),
    );
  }
}
