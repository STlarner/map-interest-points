import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/ui.dart";

import "../../../dependency_injection/app_repository.dart";
import "../../../notifiers/async_state.dart";
import "../../../notifiers/progress_indicator_notifier.dart";
import "../../../notifiers/trip_detail_notifier.dart";
import "../../../router/app_routes.dart";
import "../../../theme/colors_extension.dart";
import "../../extensions/ui_context_extension.dart";
import "../../widgets/appbar_circle_button.dart";
import "../../widgets/firebase_async_image.dart";
import "../../widgets/trip_day_card.dart";

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final ValueNotifier<bool> _isEditModeEnabled = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Consumer<TripDetailNotifier>(
      builder: (context, tripNotifier, child) {
        final trip = tripNotifier.trip;
        final isFloatingButtonEnabled =
            tripNotifier.interestPointsStatus == AsyncStatus.success;

        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FloatingActionButton.extended(
              backgroundColor: isFloatingButtonEnabled
                  ? context.colorScheme.primary
                  : context.colorScheme.primary.withValues(alpha: 0.3),
              foregroundColor: context.colorScheme.onPrimary,
              onPressed: !isFloatingButtonEnabled
                  ? null
                  : () {
                      _isEditModeEnabled.value = false;
                      context.pushNamed(AppRoute.map.name);
                    },
              label: const Text("Open Map"),
              icon: const Icon(Icons.map_outlined, size: 25),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: AppBarCircleButton(
                  icon: Icons.chevron_left,
                  padding: const EdgeInsets.only(left: 16),
                  onTap: () => context.pop(),
                ),
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    const maxExtent = 250.0;
                    final minExtent =
                        kToolbarHeight + MediaQuery.of(context).padding.top;

                    final currentExtent = constraints.biggest.height;
                    final t =
                        (currentExtent - minExtent) / (maxExtent - minExtent);
                    final fadeValue = t.clamp(0.0, 1.0);

                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: Opacity(
                        opacity: 1 - fadeValue,
                        child: Text(
                          trip.title,
                          style: TextStyle(
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      background: FirebaseAsyncImage(
                        path: trip.imagePath ?? "trips/default/camera.jpg",
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  },
                ),
              ),

              /// Spacer
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ListTile(
                      title: Text(
                        "${trip.startDate.ddMMM} - ${trip.endDate.ddMMM} · ${trip.days} days",
                        style: context.textTheme.titleMedium,
                      ),
                      leading: const Icon(Icons.calendar_month),
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      dense: true,
                    ),
                    const SizedBox(height: 8),
                    Text(trip.description),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              if (tripNotifier.interestPointsStatus == AsyncStatus.success)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 20,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          "${tripNotifier.trip.interestPoints.length} Points of interest",
                          style: context.textTheme.titleLarge,
                        ),
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: _isEditModeEnabled,
                          builder: (context, bool value, child) {
                            return TextButton.icon(
                              onPressed: () => _isEditModeEnabled.value =
                                  !_isEditModeEnabled.value,
                              label: Text(value ? "Stop Editing" : "Edit"),
                              icon: const Icon(Icons.edit),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              if (tripNotifier.interestPointsStatus == AsyncStatus.loading)
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
                    itemCount: 3,
                  ),
                ),

              if (tripNotifier.interestPointsStatus == AsyncStatus.success)
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
                      final tripDay = tripNotifier.tripDays[index];
                      return ValueListenableBuilder<bool>(
                        valueListenable: _isEditModeEnabled,
                        builder: (context, bool value, child) {
                          return TripDayCard(
                            showDeleteButton: value,
                            interestPoints: tripDay.interestPoints,
                            day: tripDay.day,
                            date: tripDay.date,
                            onTap: (id) {
                              tripNotifier.selectInterestPoint(
                                tripNotifier.trip.interestPoints.firstWhere(
                                  (element) => element.id == id,
                                ),
                              );
                              context.pushNamed(AppRoute.map.name);
                            },
                            onDeleteTap: (id) {
                              final point = tripNotifier.trip.interestPoints
                                  .firstWhere((element) => element.id == id);
                              context.read<ProgressIndicatorNotifier>().show();
                              GetIt.I<AppRepository>()
                                  .deleteInterestPoint(trip, point)
                                  .then((_) {
                                    tripNotifier.deleteInterestPoint(point);
                                  })
                                  .catchError((dynamic error) {
                                    if (context.mounted) {
                                      context.showErrorBanner(error.toString());
                                    }
                                  })
                                  .whenComplete(() {
                                    if (context.mounted) {
                                      context
                                          .read<ProgressIndicatorNotifier>()
                                          .hide();
                                    }
                                  });
                            },
                          );
                        },
                      );
                    },
                    itemCount: tripNotifier.tripDays.length,
                  ),
                ),

              if (tripNotifier.interestPointsStatus == AsyncStatus.error)
                SliverToBoxAdapter(
                  child: MaterialBanner(
                    backgroundColor: context.colorScheme.errorContainer,
                    elevation: 2,
                    content: Text(
                      "Oops! We couldn’t load your trip plan right now. Please try again later.",
                      style: TextStyle(
                        color: context.colorScheme.onErrorContainer,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          tripNotifier.fetchInterestPoints();
                        },
                        child: const Text("Load again"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
