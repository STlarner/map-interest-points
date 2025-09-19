// ignore_for_file: avoid_print

import "package:logging/logging.dart";

import "log_provider.dart";

class CoreLogProvider extends LogProvider {
  CoreLogProvider() {
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((record) {
      String icon;
      switch (record.level.name) {
        case "ERROR":
          icon = "🛑";
        case "WARNING":
          icon = "⚠️";
        case "INFO":
          icon = "ℹ️";
        case "DEBUG":
          icon = "🐛";
        case "NETWORK":
          icon = "🌐";
        default:
          icon = "";
      }
      final ts =
          "${record.time.hour.toString().padLeft(2, '0')}:"
          "${record.time.minute.toString().padLeft(2, '0')}:"
          "${record.time.second.toString().padLeft(2, '0')}."
          "${record.time.millisecond.toString().padLeft(3, '0')}";

      // Build final log line
      final logLine =
          "$icon ${record.level.name.padRight(7)} $ts "
          "[${record.loggerName}] ${record.message}";

      print(logLine);
    });
  }

  final logger = Logger("CoreLogProvider");

  @override
  void log(String message, Severity severity) {
    switch (severity) {
      case Severity.debug:
        logger.debug(message);
      case Severity.info:
        logger.info(message);
      case Severity.warning:
        logger.warning(message);
      case Severity.error:
        logger.shout(message);
      case Severity.network:
        logger.network(message);
    }
  }
}

extension NetworkLogging on Logger {
  void network(Object? message, [Object? error, StackTrace? stackTrace]) {
    const Level network = Level("NETWORK", 800);
    log(network, message, error, stackTrace);
  }

  void debug(Object? message, [Object? error, StackTrace? stackTrace]) {
    const Level debug = Level("DEBUG", 500);
    log(debug, message, error, stackTrace);
  }

  void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    const Level error = Level("ERROR", 1200);
    log(error, message, error, stackTrace);
  }
}
