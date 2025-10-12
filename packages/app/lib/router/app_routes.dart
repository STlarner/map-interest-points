import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../notifiers/trip_detail_notifier.dart";
import "../notifiers/trips_notifier.dart";
import "../ui/screens/create_trip_screen/create_trip_screen.dart";
import "../ui/screens/home_screen/home_screen.dart";
import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/map_screen/map_screen.dart";
import "../ui/screens/map_search_screen/map_search_screen.dart";
import "../ui/screens/my_trips_screen/my_trips_screen.dart";
import "../ui/screens/sign_up_screen/sign_up_screen.dart";
import "../ui/screens/splash_screen/splash_screen.dart";
import "../ui/screens/trip_detail_screen/trip_detail_screen.dart";
import "../ui/widgets/floating_bottom_navigation_bar.dart";
import "back_gesture_shell_wrapper.dart";

enum AppRoute {
  splash("splash", "/"),
  login("login", "/login"),
  signUp("sign-up", "/login/sign-up"),
  home("home", "/tabs/home"),
  myTrips("my-trips", "/tabs/my-trips"),
  tripDetail("trip-detail", "trip-detail"),
  map("map", "map"),
  mapSearch("map-search", "map-search"),
  createTrip("create-trip", "/create-trip");

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
    routes: [tripDetailShellRoute],
  );

  late final tripDetailShellRoute = ShellRoute(
    builder: (context, state, child) {
      final tripsNotifier = context.read<TripsNotifier>();
      final selectedTrip = tripsNotifier.selectedTrip;

      if (selectedTrip == null) {
        throw Exception("Selected trip is null");
      }

      return BackGestureShellWrapper(
        child: ChangeNotifierProvider(
          create: (_) => TripDetailNotifier(trip: selectedTrip),
          child: child,
        ),
      );
    },
    routes: [tripDetailRoute],
  );

  late final tripDetailRoute = GoRoute(
    name: AppRoute.tripDetail.name,
    path: AppRoute.tripDetail.path,
    routes: [mapRoute],
    builder: (context, state) => const TripDetailScreen(),
  );

  late final mapRoute = GoRoute(
    name: AppRoute.map.name,
    path: AppRoute.map.path,
    pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const MapScreen(),
      fullscreenDialog: true,
    ),
    routes: [mapSearchRoute],
  );

  late final mapSearchRoute = GoRoute(
    name: AppRoute.mapSearch.name,
    path: AppRoute.mapSearch.path,
    pageBuilder: (context, state) {
      return NoTransitionPage(
        key: state.pageKey,
        child: const MapSearchScreen(),
      );
    },
  );

  late final myTripsRoute = GoRoute(
    name: AppRoute.myTrips.name,
    path: AppRoute.myTrips.path,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: MyTripsScreen()),
  );

  late final createTripRoute = GoRoute(
    name: AppRoute.createTrip.name,
    path: AppRoute.createTrip.path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const CreateTripScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    ),
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
                    onCenterButtonTap: () =>
                        context.pushNamed(AppRoute.createTrip.name),
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
  List<RouteBase> get routes => [
    splashRoute,
    loginRoute,
    tabRoute,
    createTripRoute,
  ];
}
