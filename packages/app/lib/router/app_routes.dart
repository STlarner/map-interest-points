import "package:core/core.dart";
import "package:flutter/material.dart";
import "../ui/screens/home_screen/home_screen.dart";
import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/sign_up_screen/sign_up_screen.dart";
import "../ui/screens/splash_screen/splash_screen.dart";

enum AppRoute {
  splash("/"),
  login("/login"),
  signUp("/login/sign-up"),
  home("/tabs/home"),
  myPlans("/tabs/my-plans");

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
      pageBuilder: (context, state) => const NoTransitionPage(child: LoginScreen()),
      routes: [GoRoute(path: "sign-up", builder: (context, state) => const SignUpScreen())],
    ),
    GoRoute(
      name: "sign-up",
      path: AppRoute.signUp.path,
      builder: (context, state) => const SignUpScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        GetIt.I<LogProvider>().log("Rebuilding navigation shell", Severity.debug);

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              GetIt.I<LogProvider>().log("Switching to index $index", Severity.debug);
              navigationShell.goBranch(index, initialLocation: true);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Plans"),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.home.path,
              pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.myPlans.path,
              pageBuilder: (context, state) => const NoTransitionPage(child: Text("My Plans")),
            ),
          ],
        ),
      ],
    ),
  ];
}
