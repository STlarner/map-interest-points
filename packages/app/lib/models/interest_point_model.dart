class InterestPointModel {
  InterestPointModel({
    required this.title,
    required this.description,
    required this.date,
    required this.coordinates,
  });

  factory InterestPointModel.fromJson(Map<String, dynamic> json) {
    return InterestPointModel(
      title: json["title"] as String,
      description: json["description"] as String,
      date: DateTime.parse(json["date"] as String),
      coordinates: Coordinates.fromJson(
        json["coordinates"] as Map<String, dynamic>,
      ),
    );
  }

  final String title;
  final String description;
  final DateTime date;
  final Coordinates coordinates;

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "coordinates": coordinates.toJson(),
    };
  }

  @override
  String toString() {
    return "InterestPointModel(title: $title, description: $description, "
        "date: $date, latitude: ${coordinates.latitude}, longitude: ${coordinates.longitude})";
  }
}

class Coordinates {
  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: (json["_latitude"] as num).toDouble(),
      longitude: (json["_longitude"] as num).toDouble(),
    );
  }

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() {
    return {"_latitude": latitude, "_longitude": longitude};
  }
}
