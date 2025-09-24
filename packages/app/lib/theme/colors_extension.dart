import "package:flutter/material.dart";

class ColorsExtension extends ThemeExtension<ColorsExtension> {
  const ColorsExtension({required this.mapMarkerColor});

  final Color? mapMarkerColor;

  @override
  ColorsExtension copyWith({Color? mapMarkerColor}) {
    return ColorsExtension(
      mapMarkerColor: mapMarkerColor ?? this.mapMarkerColor,
    );
  }

  @override
  ColorsExtension lerp(ColorsExtension? other, double t) {
    if (other is! ColorsExtension) {
      return this;
    }
    return ColorsExtension(
      mapMarkerColor: Color.lerp(mapMarkerColor, other.mapMarkerColor, t),
    );
  }
}

extension AppThemeExtension on ThemeData {
  ColorsExtension get additionalColors => extension<ColorsExtension>()!;
}
