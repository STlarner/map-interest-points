import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../notifiers/progress_indicator_notifier.dart";

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressIndicatorNotifier>(
      builder: (_, notifier, _) {
        if (!notifier.isLoading) {
          return const SizedBox.shrink();
        }
        return const ColoredBox(
          color: Colors.black45,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
