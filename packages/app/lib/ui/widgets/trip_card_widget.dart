import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:ui/ui.dart";

class TripCardWidget extends StatelessWidget {
  const TripCardWidget({
    super.key,
    required this.tripTitle,
    required this.tripDescription,
    required this.tripImagePath,
    required this.tripStartDate,
    required this.tripEndDate,
  });

  final String tripTitle;
  final String tripDescription;
  final String tripImagePath;
  final DateTime tripStartDate;
  final DateTime tripEndDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                tripImagePath,
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
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  Text("${tripStartDate.ddMMM} - ${tripEndDate.ddMMM}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
