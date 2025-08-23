import "package:flutter/material.dart";

extension ColorSchemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
