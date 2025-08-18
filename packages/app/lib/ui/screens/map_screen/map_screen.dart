import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../providers/session_provider.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Map 8 Example")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(37.7749, -122.4194),
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            GetIt.I<LogProvider>().log("Tapped at $point", Severity.debug);
          },
          onPositionChanged: (position, hasGesture) {
            GetIt.I<LogProvider>().log(
              "Map moved to ${position.center}, zoom ${position.zoom}",
              Severity.debug,
            );
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.mapInterestPoints",
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(37.7749, -122.4194),
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    GetIt.I<LogProvider>().log("Marker tapped!", Severity.debug);
                    context.read<SessionProvider>().logout();
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
                onTap: () => launchUrl(Uri.parse("https://openstreetmap.org/copyright")),
              ),
              // Also add images...
            ],
          ),
        ],
      ),
    );
  }
}
