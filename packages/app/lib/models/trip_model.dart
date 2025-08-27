import "package:cloud_firestore/cloud_firestore.dart";

class TripModel {
  TripModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imagePath,
  });

  factory TripModel.fromJson({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return TripModel(
      id: id,
      title: json["title"] as String,
      description: json["description"] as String,
      imagePath: json["image_path"] as String?,
      startDate: (json["start_date"] as Timestamp).toDate(),
      endDate: (json["end_date"] as Timestamp).toDate(),
    );
  }

  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final DateTime startDate;
  final DateTime endDate;

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
