import "package:flutter/material.dart";

class ColorsExtension extends ThemeExtension<ColorsExtension> {
  const ColorsExtension({
    required this.mapMarkerColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
  });

  final Color mapMarkerColor;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;

  @override
  ColorsExtension copyWith({
    Color? mapMarkerColor,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
  }) {
    return ColorsExtension(
      mapMarkerColor: mapMarkerColor ?? this.mapMarkerColor,
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor:
          shimmerHighlightColor ?? this.shimmerHighlightColor,
    );
  }

  @override
  ColorsExtension lerp(ColorsExtension? other, double t) {
    if (other is! ColorsExtension) {
      return this;
    }
    return ColorsExtension(
      mapMarkerColor: Color.lerp(mapMarkerColor, other.mapMarkerColor, t)!,
      shimmerBaseColor: Color.lerp(
        shimmerBaseColor,
        other.shimmerBaseColor,
        t,
      )!,
      shimmerHighlightColor: Color.lerp(
        shimmerHighlightColor,
        other.shimmerHighlightColor,
        t,
      )!,
    );
  }
}

extension AppThemeExtension on ThemeData {
  ColorsExtension get additionalColors => extension<ColorsExtension>()!;
}
