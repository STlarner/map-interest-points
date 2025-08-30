enum Severity { debug, info, warning, error, network }

abstract class LogProvider {
  void log(String message, Severity severity);
}
