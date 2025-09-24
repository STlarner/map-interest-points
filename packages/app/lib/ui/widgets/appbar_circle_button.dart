import "package:flutter/material.dart";
import "package:ui/ui.dart";

class AppBarCircleButton extends StatelessWidget {
  const AppBarCircleButton({
    super.key,
    this.foregroundColor,
    this.backgroundColor,
    this.padding,
    required this.icon,
    required this.onTap,
  });

  final IconData? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 4),
      child: Material(
        color: backgroundColor ?? context.colorScheme.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(
            icon,
            color: foregroundColor ?? context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
