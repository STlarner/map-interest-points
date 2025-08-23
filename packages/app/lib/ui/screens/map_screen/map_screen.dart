import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../dependency_injection/session_manager.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: StadiumBorder(), // Perfect capsule shape
          ),
          child: const Text(
            "Capsule Text",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
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
                    GetIt.I<LogProvider>().log(
                      "Marker tapped!",
                      Severity.debug,
                    );
                    GetIt.I<SessionManager>().logout();
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),

          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                "OpenStreetMap contributors",
                onTap: () =>
                    launchUrl(Uri.parse("https://openstreetmap.org/copyright")),
              ),
              // Also add images...
            ],
          ),
        ],
      ),
    );
  }
}
