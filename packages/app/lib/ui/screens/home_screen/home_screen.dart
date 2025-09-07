import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripsNotifier>().fetchAllUserTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsNotifier>(
      builder: (context, tripsNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
            actions: [
              IconButton(
                onPressed: () {
                  GetIt.I<SessionManager>().logout();
                  context.goNamed(AppRoute.login.name);
                },
                icon: const Icon(Icons.person),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<TripsNotifier>().fetchAllUserTrips(
              forceRefresh: true,
            ),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                    bottom: 16,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        "Upcoming Trips",
                        style: context.textTheme.titleLarge,
                      ),
                    ]),
                  ),
                ),

                if (tripsNotifier.upcomingTripsState.status ==
                    AsyncStatus.loading)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 100,
                    ),
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) =>
                          const Padding(padding: EdgeInsets.only(bottom: 24)),
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
                      itemCount: 2,
                    ),
                  ),

                if (tripsNotifier.upcomingTripsState.status ==
                    AsyncStatus.success)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 120,
                    ),
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) =>
                          const Padding(padding: EdgeInsets.only(bottom: 24)),
                      itemBuilder: (context, index) {
                        final trip =
                            tripsNotifier.upcomingTripsState.data![index];
                        return TripCardWidget.fromTripModel(
                          tripModel: trip,
                          onTap: () => context.pushNamed(
                            AppRoute.tripDetail.name,
                            pathParameters: {"tripId": trip.id},
                          ),
                        );
                      },
                      itemCount: tripsNotifier.upcomingTripsState.data!.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
