import "package:core/core.dart";
import "package:flutter/material.dart";

import "dependency_injection/app_dependency_provider.dart";
import "router/app_routes.dart";
import "theme/app_theme.dart";

late final GoRouter router;

void main() {
  setupRouter();
  setupDependencies();
  runApp(const MyApp());
}

void setupDependencies() {
  for (final provider in [AppDependencyProvider(), CoreDependencyProvider()]) {
    provider.registerDependencies();
  }
}

void setupRouter() {
  router = CoreRouter([AppRoutes()]).buildRouter();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Flutter Demo",
      routerConfig: router,
      theme: light,
      darkTheme: dark,
    );
  }
}
