import "package:flutter/material.dart";
import "package:ui/ui.dart";

import "../images/app_images.dart";

class PlanCardWidget extends StatelessWidget {
  const PlanCardWidget({super.key});

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
                AppImages.tokyoSigns,
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
                  Text("Tokyo, Japan", style: context.textTheme.headlineSmall),
                  Text(
                    "A two week trip to Tokyo and nearby cities like Osaka and Kyoto.",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  Text("02 November - 12 November"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
