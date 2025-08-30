import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/extensions/context_extensions/context_text_style_extension.dart";
import "package:ui/ui.dart";

import "../../../dependency_injection/session_manager.dart";
import "../../../notifiers/async_state.dart";
import "../../../notifiers/trips_notifier.dart";
import "../../../router/app_routes.dart";
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
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              Text("Upcoming Trips", style: context.textTheme.titleLarge),
              const SizedBox(height: 16),
              Consumer<TripsNotifier>(
                builder: (context, tripsNotifier, child) {
                  switch (tripsNotifier.upcomingTripsState.status) {
                    case AsyncStatus.initial:
                    case AsyncStatus.loading:
                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const Padding(padding: EdgeInsets.only(bottom: 24)),
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
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
                      );
                    case AsyncStatus.error:
                      return const Center(child: CircularProgressIndicator());
                    case AsyncStatus.success:
                      return ListView.builder(
                        itemCount:
                            tripsNotifier.upcomingTripsState.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final trip =
                              tripsNotifier.upcomingTripsState.data![index];
                          return TripCardWidget.fromTripModel(tripModel: trip);
                        },
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
