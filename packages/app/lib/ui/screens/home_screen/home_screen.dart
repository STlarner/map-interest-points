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
      context.read<TripsNotifier>().fetchTrips();
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
            onRefresh: () =>
                context.read<TripsNotifier>().fetchTrips(forceRefresh: true),
            child: CustomScrollView(
              slivers: [
                if (tripsNotifier.tripsStatus != AsyncStatus.error)
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

                if (tripsNotifier.tripsStatus == AsyncStatus.error)
                  SliverToBoxAdapter(
                    child: MaterialBanner(
                      backgroundColor: context.colorScheme.errorContainer,
                      elevation: 2,
                      content: Text(
                        "Oops! We couldn’t load your trips right now. Please try again later.",
                        style: TextStyle(
                          color: context.colorScheme.onErrorContainer,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            tripsNotifier.fetchTrips();
                          },
                          child: const Text("Load again"),
                        ),
                      ],
                    ),
                  ),

                if (tripsNotifier.tripsStatus == AsyncStatus.loading)
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

                if (tripsNotifier.tripsStatus == AsyncStatus.success)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 120,
                    ),
                    sliver: tripsNotifier.upcomingTrips.isEmpty
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
                              final trip = tripsNotifier.upcomingTrips[index];
                              return TripCardWidget.fromTripModel(
                                tripModel: trip,
                                onTap: () {
                                  tripsNotifier.selectedTrip = trip;
                                  context.pushNamed(AppRoute.tripDetail.name);
                                },
                              );
                            },
                            itemCount: tripsNotifier.upcomingTrips.length,
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
