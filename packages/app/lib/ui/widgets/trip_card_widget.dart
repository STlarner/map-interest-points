import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:ui/ui.dart";

import "../../models/trip_model.dart";
import "firebase_async_image.dart";
import "shadowed_container.dart";

class TripCardWidget extends StatelessWidget {
  const TripCardWidget({
    super.key,
    required this.tripTitle,
    required this.tripDescription,
    required this.tripImagePath,
    required this.tripStartDate,
    required this.tripEndDate,
    this.onTap,
  });

  TripCardWidget.fromTripModel({
    Key? key,
    required TripModel tripModel,
    VoidCallback? onTap,
  }) : this(
         key: key,
         tripTitle: tripModel.title,
         tripDescription: tripModel.description,
         tripImagePath: tripModel.imagePath,
         tripStartDate: tripModel.startDate,
         tripEndDate: tripModel.endDate,
         onTap: onTap,
       );

  final String tripTitle;
  final String tripDescription;
  final String? tripImagePath;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ShadowedContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FirebaseAsyncImage(
                  path: tripImagePath ?? "trips/default/camera.jpg",
                  fit: BoxFit.cover,
                  width: 90,
                  height: 120,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tripTitle, style: context.textTheme.headlineSmall),
                    Text(
                      tripDescription,
                      style: context.textTheme.bodyMedium!.withColor(
                        context.colorScheme.secondary,
                      ),
                    ),
                    Text("${tripStartDate.ddMMM} - ${tripEndDate.ddMMM}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
