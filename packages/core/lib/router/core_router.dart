import "package:go_router/go_router.dart";

/// A type that each package will implement to provide its routes.
abstract class RouteProvider {
  List<RouteBase> get routes;
}

class CoreRouter {
  CoreRouter(this._providers);
  final List<RouteProvider> _providers;

  GoRouter buildRouter() {
    final allRoutes = <RouteBase>[];

    for (final provider in _providers) {
      allRoutes.addAll(provider.routes);
    }

    return GoRouter(routes: allRoutes);
  }
}
