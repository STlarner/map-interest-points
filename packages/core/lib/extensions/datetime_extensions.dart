import "package:intl/intl.dart";

extension DateTimeUtils on DateTime {
  String get ddMMM => DateFormatUtils.ddMMM.format(this);
  String get eEEEMMMd => DateFormatUtils.eEEEMMMd.format(this);
  String get eEEEdMMMMy => DateFormatUtils.eEEEdMMMMy.format(this);

  static DateTime? fromIsoString(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }
}

extension DateFormatUtils on DateFormat {
  static DateFormat get ddMMM => DateFormat("dd MMM");
  static DateFormat get eEEEMMMd => DateFormat("EEEE, MMM d");
  static DateFormat get eEEEdMMMMy => DateFormat("EEEE, d MMMM y");
}

extension DateStringUtils on String {
  DateTime toDateTime(DateFormat dateFormat) {
    return dateFormat.parseUtc(this);
  }
}
