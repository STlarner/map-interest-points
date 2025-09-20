import "dart:io";

import "package:core/core.dart";
import "package:flutter/widgets.dart";

class BackGestureShellWrapper extends StatelessWidget {
  const BackGestureShellWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final canPop = _canPop(context);
    return PopScope(canPop: canPop, child: child);
  }

  bool _canPop(BuildContext context) {
    if (!Platform.isIOS) {
      return true;
    }

    final matches = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.matches;

    final lastMatch = matches.lastOrNull;

    if (lastMatch is! ShellRouteMatch) {
      return true;
    }
    return _isAtShellRoot(lastMatch);
  }

  /// Loop until we're at the last non-shell route
  bool _isAtShellRoot(ShellRouteMatch match) {
    final lastNested = match.matches.lastOrNull;

    if (lastNested is ShellRouteMatch) {
      return _isAtShellRoot(lastNested);
    }

    // Consider we're at root only if the shell contains one route
    return match.matches.length <= 1;
  }
}
