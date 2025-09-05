import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../notifiers/trip_detail_notifier.dart";
import "../notifiers/trips_notifier.dart";
import "../ui/screens/home_screen/home_screen.dart";
import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/my_trips_screen/my_trips_screen.dart";
import "../ui/screens/sign_up_screen/sign_up_screen.dart";
import "../ui/screens/splash_screen/splash_screen.dart";
import "../ui/screens/trip_detail_screen/trip_detail_screen.dart";
import "../ui/widgets/floating_bottom_navigation_bar.dart";

enum AppRoute {
  splash("splash", "/"),
  login("login", "/login"),
  signUp("sign-up", "/login/sign-up"),
  home("home", "/tabs/home"),
  myTrips("my-trips", "/tabs/my-trips"),
  tripDetail("trip-detail", "trip/:tripId");

  const AppRoute(this.name, this.path);

  final String path;
  final String name;

  String buildPath(Map<String, String> params) {
    var result = path;
    params.forEach((key, value) {
      result = result.replaceAll(":$key", value);
    });
    return result;
  }
}

class AppRoutes implements RouteProvider {
  late final loginRoute = GoRoute(
    name: AppRoute.login.name,
    path: AppRoute.login.path,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: LoginScreen()),
    routes: [signUpRoute],
  );

  late final signUpRoute = GoRoute(
    name: AppRoute.signUp.name,
    path: AppRoute.signUp.path,
    builder: (context, state) => const SignUpScreen(),
  );

  late final splashRoute = GoRoute(
    name: AppRoute.splash.name,
    path: AppRoute.splash.path,
    builder: (context, state) => const SplashScreen(),
  );

  late final homeRoute = GoRoute(
    name: AppRoute.home.name,
    path: AppRoute.home.path,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: HomeScreen()),
    routes: [tripDetailRoute],
  );

  late final tripDetailRoute = GoRoute(
    name: AppRoute.tripDetail.name,
    path: AppRoute.tripDetail.path,
    builder: (context, state) => ChangeNotifierProvider(
      create: (_) {
        final tripsNotifier = context.read<TripsNotifier>();
        final tripId = state.pathParameters["tripId"];

        if (tripId == null) {
          throw Exception("TripId is null");
        }

        final trip = tripsNotifier.allUserTripsState.data!.firstWhere(
          (trip) => trip.id == tripId,
        );
        return TripDetailNotifier(trip: trip);
      },
      child: const TripDetailScreen(),
    ),
  );

  late final myTripsRoute = GoRoute(
    name: AppRoute.myTrips.name,
    path: AppRoute.myTrips.path,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: MyTripsScreen()),
  );

  late final tabRoute = StatefulShellRoute.indexedStack(
    pageBuilder: (context, state, navigationShell) {
      final hideBottomNavigationBar =
          state.topRoute?.name != AppRoute.home.name &&
          state.topRoute?.name != AppRoute.myTrips.name;

      return NoTransitionPage(
        child: Scaffold(
          extendBody: true,
          body: navigationShell,
          bottomNavigationBar: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: hideBottomNavigationBar
                ? const SizedBox.shrink()
                : FloatingBottomNavigationBar(
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
        ),
      );
    },
    branches: [
      StatefulShellBranch(routes: [homeRoute]),
      StatefulShellBranch(routes: [myTripsRoute]),
    ],
  );

  @override
  List<RouteBase> get routes => [splashRoute, loginRoute, tabRoute];
}
