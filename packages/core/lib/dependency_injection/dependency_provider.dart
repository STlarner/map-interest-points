/// A type that each package will implement to provide its singleton dependencies.
abstract class DependencyProvider {
  void registerDependencies();
}
