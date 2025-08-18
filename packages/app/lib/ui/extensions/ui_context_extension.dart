import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../providers/progress_indicator_provider.dart";

extension UIContextExtension on BuildContext {
  void showProgressIndicator() {
    final provider = read<ProgressIndicatorProvider>();
    provider.show();
  }

  void hideProgressIndicator() {
    final provider = read<ProgressIndicatorProvider>();
    provider.hide();
  }
}
