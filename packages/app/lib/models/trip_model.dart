import "package:cloud_firestore/cloud_firestore.dart";

import "interest_point_model.dart";

class TripModel {
  TripModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imagePath,
  });

  factory TripModel.fromJson({required Map<String, dynamic> json}) {
    final start = DateTime.parse(json["start_date"] as String);
    final end = DateTime.parse(json["end_date"] as String);
    return TripModel(
      id: json["id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      imagePath: json["image_path"] as String?,
      startDate: DateTime(start.year, start.month, start.day),
      endDate: DateTime(end.year, end.month, end.day),
    );
  }

  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final DateTime startDate;
  final DateTime endDate;

  String get days => (endDate.difference(startDate).inDays + 1).toString();

  List<InterestPointModel> interestPoints = [];

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "image_path": imagePath,
      "start_date": Timestamp.fromDate(startDate),
      "end_date": Timestamp.fromDate(endDate),
    };
  }
}
