import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:ui/extensions/context_extensions/context_text_style_extension.dart";

import "../../../notifiers/trip_detail_notifier.dart";

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
          appBar: AppBar(title: Text(tripNotifier.trip.title)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                Text(
                  "${trip.startDate.ddMMM} - ${trip.endDate.ddMMM} · ${trip.days} days",
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  "${trip.description} · ${trip.interestPoints.length} saved spot",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
