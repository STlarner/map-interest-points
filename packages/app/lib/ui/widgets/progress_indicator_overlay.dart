import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../notifiers/progress_indicator_notifier.dart";

class ProgressIndicatorOverlay extends StatelessWidget {
  const ProgressIndicatorOverlay({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Consumer<ProgressIndicatorNotifier>(
          builder: (_, notifier, _) {
            if (!notifier.isLoading) {
              return const SizedBox.shrink();
            }
            return const ColoredBox(
              color: Colors.black45,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }
}
