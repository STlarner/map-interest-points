import "package:cloud_firestore/cloud_firestore.dart";

class TripModel {
  TripModel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      title: json["title"] as String,
      description: json["description"] as String,
      startDate: (json["start_date"] as Timestamp).toDate(),
      endDate: (json["end_date"] as Timestamp).toDate(),
    );
  }

  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "start_date": Timestamp.fromDate(startDate),
      "end_date": Timestamp.fromDate(endDate),
    };
  }
}
