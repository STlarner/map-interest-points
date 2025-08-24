import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../notifiers/async_state.dart";
import "../../../notifiers/trips_notifier.dart";
import "../../images/app_images.dart";
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
                    child: TripCardWidget(
                      tripTitle: trip.title,
                      tripDescription: trip.description,
                      tripImagePath: AppImages.tokyoSigns,
                      tripStartDate: trip.startDate,
                      tripEndDate: trip.endDate,
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
