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
}
