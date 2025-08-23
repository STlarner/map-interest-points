import "package:flutter/material.dart";
import "package:ui/ui.dart";

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Expanded(
          child: Divider(thickness: 1, color: context.colorScheme.secondary),
        ),
        Text("or", style: TextStyle(color: context.colorScheme.secondary)),
        Expanded(
          child: Divider(thickness: 1, color: context.colorScheme.secondary),
        ),
      ],
    );
  }
}
