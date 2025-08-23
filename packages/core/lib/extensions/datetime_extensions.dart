import "package:intl/intl.dart";

extension DateFormatting on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String get ddMMM => DateFormat("dd MMM").format(this);
}
