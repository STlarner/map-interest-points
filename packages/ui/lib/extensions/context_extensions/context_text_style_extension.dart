import "package:flutter/material.dart";

extension ContextTextStyleExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension TextStyleWeightExtension on TextStyle? {
  TextStyle? withWeight(FontWeight weight) =>
      this?.copyWith(fontWeight: weight);
}

extension TextStyleColorExtension on TextStyle? {
  TextStyle? withColor(Color color) => this?.copyWith(color: color);
}
