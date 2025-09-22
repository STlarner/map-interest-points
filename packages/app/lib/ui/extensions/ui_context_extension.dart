import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../notifiers/progress_indicator_notifier.dart";

extension UIContextExtension on BuildContext {
  void showProgressIndicator() {
    final provider = read<ProgressIndicatorNotifier>();
    provider.show();
  }

  void hideProgressIndicator() {
    final provider = read<ProgressIndicatorNotifier>();
    provider.hide();
  }

  void showErrorBanner(String message) {
    ScaffoldMessenger.of(this).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Theme.of(this).colorScheme.errorContainer,
        content: Text(
          message,
          style: TextStyle(color: Theme.of(this).colorScheme.onErrorContainer),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(this).hideCurrentMaterialBanner();
            },
            child: const Text("DISMISS"),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        ScaffoldMessenger.of(this).hideCurrentMaterialBanner();
      }
    });
  }
}
