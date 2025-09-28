import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/ui.dart";

import "../../../notifiers/async_state.dart";
import "../../../notifiers/trips_notifier.dart";
import "../../../router/app_routes.dart";
import "../../../theme/colors_extension.dart";
import "../../widgets/trip_card_widget.dart";

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Trips")),
      body: Consumer<TripsNotifier>(
        builder: (context, tripsNotifier, child) {
          // FIXME(Lo): gestire l'errore
          switch (tripsNotifier.tripsStatus) {
            case AsyncStatus.initial:
            case AsyncStatus.loading:
            case AsyncStatus.error:
              return Padding(
                padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Padding(padding: EdgeInsets.only(bottom: 24)),
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor:
                          context.theme.additionalColors.shimmerBaseColor,
                      highlightColor:
                          context.theme.additionalColors.shimmerHighlightColor,
                      period: const Duration(milliseconds: 1000),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: context.colorScheme.surface,
                        ),
                        height: 130,
                      ),
                    );
                  },
                  itemCount: 2,
                ),
              );

            case AsyncStatus.success:
              return ListView.builder(
                itemCount: tripsNotifier.trips.length,
                itemBuilder: (context, index) {
                  final trip = tripsNotifier.trips[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12,
                    ),
                    child: TripCardWidget.fromTripModel(
                      tripModel: trip,
                      onTap: () {
                        tripsNotifier.selectedTrip = trip;
                        context.pushNamed(AppRoute.tripDetail.name);
                      },
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
