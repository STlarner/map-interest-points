import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/extensions/context_extensions/context_text_style_extension.dart";

import "../../../dependency_injection/session_manager.dart";
import "../../../notifiers/async_state.dart";
import "../../../notifiers/trips_notifier.dart";
import "../../../router/app_routes.dart";
import "../../images/app_images.dart";
import "../../widgets/trip_card_widget.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              GetIt.I<SessionManager>().logout();
              context.go(AppRoute.login.path);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<TripsNotifier>().fetchAllUserTrips(),
        child: Consumer<TripsNotifier>(
          builder: (context, tripsNotifier, child) {
            switch (tripsNotifier.upcomingTripsState.status) {
              case AsyncStatus.initial:
              case AsyncStatus.loading:
              case AsyncStatus.error:
                return const Center(child: CircularProgressIndicator());

              case AsyncStatus.success:
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Text(
                        "Upcoming Trips",
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                    ListView.builder(
                      itemCount: tripsNotifier.upcomingTripsState.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final trip =
                            tripsNotifier.upcomingTripsState.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 0,
                            left: 24,
                            right: 24,
                            bottom: 12,
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
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
