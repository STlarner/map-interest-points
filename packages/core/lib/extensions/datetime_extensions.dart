import "package:intl/intl.dart";

extension DateFormatting on DateTime {
  String get ddMMM => format("dd MMM");
  String get eEEEMMMd => format("EEEE, MMM d");

  static DateTime? fromIsoString(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
