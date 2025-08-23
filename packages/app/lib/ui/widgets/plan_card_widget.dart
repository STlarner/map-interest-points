import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:ui/ui.dart";

import "../images/app_images.dart";

class PlanCardWidget extends StatelessWidget {
  const PlanCardWidget({
    super.key,
    required this.planTitle,
    required this.planDescription,
    required this.planImagePath,
    required this.planStartDate,
    required this.planEndDate,
  });

  final String planTitle;
  final String planDescription;
  final String planImagePath;
  final DateTime planStartDate;
  final DateTime planEndDate;

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
                planImagePath,
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
                  Text(planTitle, style: context.textTheme.headlineSmall),
                  Text(
                    planDescription,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  Text("${planStartDate.ddMMM} - ${planEndDate.ddMMM}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
