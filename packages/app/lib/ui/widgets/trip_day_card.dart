import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:ui/ui.dart";

import "../../models/interest_point_model.dart";
import "checkbox_list_card_tile.dart";
import "shadowed_container.dart";

class TripDayCard extends StatelessWidget {
  const TripDayCard({
    super.key,
    required this.interestPoints,
    required this.date,
    required this.day,
    required this.showDeleteButton,
    this.onChanged,
    this.onTap,
    this.onDeleteTap,
  });

  final List<InterestPointModel> interestPoints;
  final DateTime date;
  final int day;
  final bool showDeleteButton;
  final void Function(String, bool?)? onChanged;
  final void Function(String)? onTap;
  final void Function(String)? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
        child: Column(
          spacing: 8,
          children: [
            Row(
              children: [
                Text("Day $day", style: context.textTheme.titleMedium),
                const Spacer(),
                Text(date.eEEEMMMd),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: interestPoints.length,
              itemBuilder: (context, index) {
                final interestPoint = interestPoints[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CheckboxListCardTile(
                    value: interestPoint.visited,
                    id: interestPoint.id,
                    title: interestPoint.title,
                    subtitle: interestPoint.description,
                    showDeleteButton: showDeleteButton,
                    onChanged: (value) =>
                        onChanged?.call(interestPoint.id, value),
                    onTap: () => onTap?.call(interestPoint.id),
                    onDeleteTap: () => onDeleteTap?.call(interestPoint.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
