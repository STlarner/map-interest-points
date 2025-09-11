import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_map/flutter_map.dart";
import "package:provider/provider.dart";
import "package:ui/ui.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../models/interest_point_model.dart";
import "../../../notifiers/trip_detail_notifier.dart";

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Material(
              color: context.colorScheme.surfaceContainer,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.pop(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.close,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TripDetailNotifier>(
        builder: (context, tripNotifier, child) {
          final points = [
            if (tripNotifier.draftInterestPoint != null)
              tripNotifier.draftInterestPoint!,
            ...tripNotifier.trip.interestPoints,
          ];

          return FlutterMap(
            options: MapOptions(
              initialCenter:
                  tripNotifier.trip.interestPoints.first.coordinates.latLng,
              initialZoom: 13.0,
              onLongPress: (tagPosition, point) {
                GetIt.I<LogProvider>().log(
                  "Long press at $point",
                  Severity.debug,
                );
                tripNotifier.addDraftInterestPoint(
                  InterestPointModel(
                    title: "",
                    description: "",
                    date: DateTime.now(),
                    coordinates: Coordinates(
                      latitude: point.latitude,
                      longitude: point.longitude,
                    ),
                  ),
                );
              },
              onTap: (tapPosition, point) {
                GetIt.I<LogProvider>().log("Tapped at $point", Severity.debug);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.mapInterestPoints",
              ),
              MarkerLayer(
                markers: points
                    .map(
                      (point) => Marker(
                        point: point.coordinates.latLng,
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            GetIt.I<LogProvider>().log(
                              "Marker tapped!",
                              Severity.debug,
                            );
                          },
                          child: Icon(
                            Icons.location_pin,
                            color: context.colorScheme.primary,
                            size: 40,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    "OpenStreetMap contributors",
                    onTap: () => launchUrl(
                      Uri.parse("https://openstreetmap.org/copyright"),
                    ),
                  ),
                  // Also add images...
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
