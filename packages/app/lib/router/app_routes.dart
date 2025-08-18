import "package:core/core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/map_screen/map_screen.dart";

class AppRoutes implements RouteProvider {
  @override
  List<GoRoute> get routes => [
    GoRoute(
      name: "login",
      path: "/",
      builder: (context, state) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            GetIt.I<LogProvider>().log("No user logged in", Severity.info);
            return const LoginScreen();
          }

          GetIt.I<LogProvider>().log("User logged in: ${snapshot.data!.email}", Severity.info);
          return const MapScreen();
        },
      ),
    ),
    GoRoute(name: "map", path: "/map", builder: (context, state) => const MapScreen()),
  ];
}
