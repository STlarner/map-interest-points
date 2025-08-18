enum Severity { debug, info, warning, error }

abstract class LogProvider {
  void log(String message, Severity severity);
}
