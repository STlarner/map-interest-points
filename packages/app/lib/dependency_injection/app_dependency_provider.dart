import "package:core/core.dart";

import "app_repository.dart";
import "firestore_manager.dart";
import "session_manager.dart";

class AppDependencyProvider extends DependencyProvider {
  @override
  void registerDependencies() {
    GetIt.I.registerSingleton<FirestoreManager>(FirestoreManager());
    GetIt.I.registerSingleton<SessionManager>(SessionManager());
    GetIt.I.registerSingleton<AppRepository>(AppRepository());
  }
}
