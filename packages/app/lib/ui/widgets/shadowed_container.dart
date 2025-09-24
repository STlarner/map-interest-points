import "package:flutter/material.dart";
import "package:ui/ui.dart";

class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: !lightMode
            ? Border.all(color: context.colorScheme.outline, width: 1)
            : null,
        boxShadow: lightMode
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
