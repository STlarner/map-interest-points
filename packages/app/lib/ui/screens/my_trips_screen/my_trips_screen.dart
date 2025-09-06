import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../notifiers/async_state.dart";
import "../../../notifiers/trips_notifier.dart";
import "../../../router/app_routes.dart";
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
          switch (tripsNotifier.allUserTripsState.status) {
            case AsyncStatus.initial:
            case AsyncStatus.loading:
            case AsyncStatus.error:
              return const Center(child: CircularProgressIndicator());

            case AsyncStatus.success:
              return ListView.builder(
                itemCount: tripsNotifier.allUserTripsState.data!.length,
                itemBuilder: (context, index) {
                  final trip = tripsNotifier.allUserTripsState.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12,
                    ),
                    child: TripCardWidget.fromTripModel(
                      tripModel: trip,
                      onTap: () => context.pushNamed(
                        AppRoute.tripDetail.name,
                        pathParameters: {"tripId": trip.id},
                      ),
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
