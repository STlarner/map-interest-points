import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../notifiers/trips_notifier.dart";
import "../ui/screens/home_screen/home_screen.dart";
import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/my_trips_screen/my_trips_screen.dart";
import "../ui/screens/sign_up_screen/sign_up_screen.dart";
import "../ui/screens/splash_screen/splash_screen.dart";
import "../ui/widgets/floating_bottom_navigation_bar.dart";

enum AppRoute {
  splash("/"),
  login("/login"),
  signUp("/login/sign-up"),
  home("/tabs/home"),
  myTrips("/tabs/my-trips");

  const AppRoute(this.path);

  final String path;
}

class AppRoutes implements RouteProvider {
  @override
  List<RouteBase> get routes => [
    GoRoute(
      name: "splash",
      path: AppRoute.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      name: "login",
      path: AppRoute.login.path,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoginScreen()),
      routes: [
        GoRoute(
          path: "sign-up",
          builder: (context, state) => const SignUpScreen(),
        ),
      ],
    ),

    GoRoute(
      name: "sign-up",
      path: AppRoute.signUp.path,
      builder: (context, state) => const SignUpScreen(),
    ),

    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        context.read<TripsNotifier>().fetchAllUserTrips();
        return NoTransitionPage(
          child: Scaffold(
            body: navigationShell,
            bottomNavigationBar: FloatingBottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(index, initialLocation: true);
              },
              onCenterButtonTap: () => GetIt.I<LogProvider>().log(
                "Center Button Tapped",
                Severity.debug,
              ),
            ),
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.home.path,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.myTrips.path,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MyTripsScreen()),
            ),
          ],
        ),
      ],
    ),
  ];
}
