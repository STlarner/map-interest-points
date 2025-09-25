import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_map/flutter_map.dart";
import "package:provider/provider.dart";
import "package:ui/ui.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../models/interest_point_model.dart";
import "../../../notifiers/trip_detail_notifier.dart";
import "../../../router/app_routes.dart";
import "../../../theme/colors_extension.dart";
import "../../extensions/input_decoration_extension.dart";
import "../../widgets/appbar_circle_button.dart";
import "../interest_point_bottom_sheet/interest_point_bottom_sheet.dart";

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  double currentZoom = 13;

  @override
  void initState() {
    final selectedInterestPoint = context
        .read<TripDetailNotifier>()
        .selectedInterestPoint;

    if (selectedInterestPoint != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showInterestPointBottomSheet(context, selectedInterestPoint);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
        leading: AppBarCircleButton(
          icon: Icons.close,
          onTap: () {
            context.read<TripDetailNotifier>().clearMapSearch();
            context.pop();
          },
        ),
        title: GestureDetector(
          onTap: () =>
              context.pushNamed(AppRoute.mapSearch.name).then((object) {
                if (context.mounted) {
                  _searchController.text =
                      context.read<TripDetailNotifier>().mapSearchQuery ?? "";
                }
                if (object != null) {
                  final interestPoint = object as InterestPointModel;
                  _mapController.move(
                    interestPoint.coordinates.latLng,
                    currentZoom,
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      showInterestPointBottomSheet(context, interestPoint);
                    }
                  });
                }
              }),
          child: AbsorbPointer(
            absorbing: true,
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(
                hintText: "Search here...",
                prefixIcon: Icon(Icons.search),
              ).withoutBorder(fillColor: context.colorScheme.surface),
            ),
          ),
        ),
      ),
      body: Consumer<TripDetailNotifier>(
        builder: (context, tripNotifier, child) {
          final points = [
            if (tripNotifier.draftInterestPoint != null)
              tripNotifier.draftInterestPoint!,
            ...tripNotifier.trip.interestPoints,
          ];

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: tripNotifier.getMapInitialCenter(),
              initialZoom: currentZoom,
              onLongPress: (tagPosition, point) {
                final interestPoint = InterestPointModel(
                  id: "draft",
                  title: "",
                  description: "",
                  date: DateTime.now(),
                  coordinates: Coordinates(
                    latitude: point.latitude,
                    longitude: point.longitude,
                  ),
                );

                tripNotifier.addDraftInterestPoint(interestPoint);
                showInterestPointBottomSheet(context, interestPoint);
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
                rotate: true,
                markers: points.map((point) {
                  final isSelected =
                      point == tripNotifier.selectedInterestPoint;
                  return Marker(
                    key: ValueKey(point.id),
                    point: point.coordinates.latLng,
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => showInterestPointBottomSheet(context, point),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child:
                            Icon(
                                  Icons.location_pin,
                                  color: context
                                      .theme
                                      .additionalColors
                                      .mapMarkerColor,
                                  size: 40,
                                )
                                .animate(target: isSelected ? 1 : 0)
                                .scaleXY(
                                  begin: 1.0,
                                  end: 1.5,
                                  duration: 300.ms,
                                  curve: Curves.easeOut,
                                ),
                      ),
                    ),
                  );
                }).toList(),
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

  void showInterestPointBottomSheet(
    BuildContext context,
    InterestPointModel selectedInterestPoint,
  ) {
    context.read<TripDetailNotifier>().selectInterestPoint(
      selectedInterestPoint,
    );

    showModalBottomSheet<InterestPointBottomSheet>(
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (context) =>
          InterestPointBottomSheet(interestPoint: selectedInterestPoint),
    ).then((_) {
      if (context.mounted) {
        context.read<TripDetailNotifier>().clearSelectedInterestPoint();
        context.read<TripDetailNotifier>().clearDraftInterestPoint();
      }
    });
  }
}
