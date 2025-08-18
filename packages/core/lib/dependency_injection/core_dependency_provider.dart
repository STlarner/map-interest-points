import "package:get_it/get_it.dart";

import "../logger/core_log_provider.dart";
import "../logger/log_provider.dart";
import "dependency_provider.dart";

class CoreDependencyProvider extends DependencyProvider {
  @override
  void registerDependencies() {
    GetIt.I.registerSingleton<LogProvider>(CoreLogProvider());
  }
}
