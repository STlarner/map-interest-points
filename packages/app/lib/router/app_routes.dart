import "package:core/core.dart";

import "../ui/screens/login_screen/login_screen.dart";
import "../ui/screens/map_screen/map_screen.dart";

class AppRoutes implements RouteProvider {
  @override
  List<GoRoute> get routes => [
    GoRoute(name: "login", path: "/", builder: (context, state) => const LoginScreen()),
    GoRoute(name: "map", path: "/map", builder: (context, state) => const MapScreen()),
  ];
}
