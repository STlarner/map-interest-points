import "package:core/core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../notifiers/session_notifier.dart";
import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/map_screen/map_screen.dart";
import "../ui/widgets/progress_indicator_overlay.dart";

class AppRoutes implements RouteProvider {
  @override
  List<GoRoute> get routes => [
    GoRoute(
      name: "login",
      path: "/",
      builder: (context, state) => ProgressIndicatorOverlay(
        child: Consumer<SessionNotifier>(
          builder: (context, notifier, child) {
            if (notifier.isLoggedIn) {
              GetIt.I<LogProvider>().log("User logged in: ${notifier.user!.email}", Severity.info);
              return const MapScreen();
            }
            GetIt.I<LogProvider>().log("No user logged in", Severity.info);
            return const LoginScreen();
          },
        ),
      ),
    ),
    GoRoute(name: "map", path: "/map", builder: (context, state) => const MapScreen()),
  ];
}
