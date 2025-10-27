import "package:flutter/material.dart";
import "package:ui/ui.dart";
import "../../theme/colors_extension.dart";

class LocationPin extends StatelessWidget {
  const LocationPin({super.key, required this.day, required this.visited});

  final int day;
  final bool visited;
  double get size => 40;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.location_pin,
          size: size,
          color: context.theme.additionalColors.mapMarkerColor.withValues(
            alpha: visited ? 0.5 : 1,
          ),
        ),
        Positioned(
          top: 7,
          child: CircleAvatar(
            radius: size * 0.22,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            child: Text(
              "$day",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
