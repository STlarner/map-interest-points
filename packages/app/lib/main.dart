import "package:core/core.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "dependency_injection/app_dependency_provider.dart";
import "firebase_options.dart";
import "notifiers/trips_notifier.dart";
import "notifiers/progress_indicator_notifier.dart";
import "router/app_routes.dart";
import "theme/app_theme.dart";
import "ui/widgets/progress_indicator_overlay.dart";

late final GoRouter router;

void main() async {
  await setupFirebase();
  setupRouter();
  setupDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressIndicatorNotifier()),
        ChangeNotifierProvider(create: (_) => TripsNotifier()),
      ],

      child: const MyApp(),
    ),
  );
}

void setupDependencies() {
  for (final provider in [AppDependencyProvider(), CoreDependencyProvider()]) {
    provider.registerDependencies();
  }
}

void setupRouter() {
  router = CoreRouter([AppRoutes()]).buildRouter();
}

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) => child!),
            OverlayEntry(builder: (context) => const ProgressIndicatorWidget()),
          ],
        );
      },
    );
  }
}
