import "package:flutter/material.dart";
import "shadowed_container.dart";

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 16,
          children: [
            icon,
            Expanded(
              child: ListTile(
                title: Text(title),
                subtitle: Text(description),
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
