import "package:cloud_firestore/cloud_firestore.dart";
import "package:core/core.dart";

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
    return TripModel(
      id: json["id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      imagePath: json["image_path"] as String?,
      startDate: DateFormatting.fromIsoString(json["start_date"] as String)!,
      endDate: DateFormatting.fromIsoString(json["end_date"] as String)!,
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
