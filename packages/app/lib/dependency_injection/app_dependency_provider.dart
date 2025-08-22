import "package:core/core.dart";

import "firestore_manager.dart";

class AppDependencyProvider extends DependencyProvider {
  @override
  void registerDependencies() {
    GetIt.I.registerSingleton<FirestoreManager>(FirestoreManager());
  }
}
