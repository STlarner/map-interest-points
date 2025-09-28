import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/ui.dart";

import "../../../dependency_injection/session_manager.dart";
import "../../../notifiers/async_state.dart";
import "../../../notifiers/trips_notifier.dart";
import "../../../router/app_routes.dart";
import "../../../theme/colors_extension.dart";
import "../../widgets/appbar_circle_button.dart";
import "../../widgets/empty_state_card.dart";
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
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: AppBarCircleButton(
                    padding: EdgeInsets.zero,
                    icon: Icons.logout,
                    onTap: () {
                      GetIt.I<SessionManager>().logout();
                      context.goNamed(AppRoute.login.name);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<TripsNotifier>().fetchAllUserTrips(
              forceRefresh: true,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 24,
                      right: 24,
                      bottom: 16,
                    ),
                    child: Text(
                      "Upcoming Trips",
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                ),

                // FIXME(Lo): gestire lo stato di errore
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
                          baseColor:
                              context.theme.additionalColors.shimmerBaseColor,
                          highlightColor: context
                              .theme
                              .additionalColors
                              .shimmerHighlightColor,
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

                // FIXME(Lo): rimuovere il wrapper attorno ad async status
                if (tripsNotifier.upcomingTripsState.status ==
                    AsyncStatus.success)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 120,
                    ),
                    sliver: tripsNotifier.upcomingTripsState.data!.isEmpty
                        ? const SliverToBoxAdapter(
                            child: EmptyStateCard(
                              icon: Icon(Icons.inbox, size: 60),
                              title: "You have no upcoming trips",
                              description:
                                  "In this section you will find all the trips planned for the next month",
                            ),
                          )
                        : SliverList.separated(
                            separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.only(bottom: 24),
                            ),
                            itemBuilder: (context, index) {
                              final trip =
                                  tripsNotifier.upcomingTripsState.data![index];
                              return TripCardWidget.fromTripModel(
                                tripModel: trip,
                                onTap: () {
                                  tripsNotifier.selectedTrip = trip;
                                  context.pushNamed(AppRoute.tripDetail.name);
                                },
                              );
                            },
                            itemCount:
                                tripsNotifier.upcomingTripsState.data!.length,
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
