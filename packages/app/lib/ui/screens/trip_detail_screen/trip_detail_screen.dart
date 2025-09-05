import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/extensions/context_extensions/context_text_style_extension.dart";
import "package:ui/ui.dart";

import "../../../notifiers/trip_detail_notifier.dart";
import "../../widgets/firebase_async_image.dart";

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TripDetailNotifier>(
      builder: (context, tripNotifier, child) {
        final trip = tripNotifier.trip;
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FloatingActionButton.extended(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              onPressed: () {},
              label: const Text("Open Map"),
              icon: const Icon(Icons.map_outlined, size: 25),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              /// Collapsible header with image
              SliverAppBar(
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
                    Text(
                      "${trip.startDate.ddMMM} - ${trip.endDate.ddMMM} · ${trip.days} days",
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${trip.description} · ${trip.interestPoints.length} saved spot",
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n "
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n"
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n"
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n"
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n"
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n"
                      "ffdfkdfhj \n fdjfdkslfdjk \n fdjfsklfdsjkl \n fsdfklfdj \n",
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }
}
