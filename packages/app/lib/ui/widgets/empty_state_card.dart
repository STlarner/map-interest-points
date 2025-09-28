import "package:flutter/material.dart";
import "shadowed_container.dart";

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ShadowedContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 16,
          children: [
            const Icon(Icons.search_off, size: 60),
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
