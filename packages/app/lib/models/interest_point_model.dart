import "package:latlong2/latlong.dart";

class InterestPointModel {
  InterestPointModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.coordinates,
    this.visited = false,
    this.dirty = false,
  });

  factory InterestPointModel.fromJson(Map<String, dynamic> json) {
    return InterestPointModel(
      id: json["id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      date: DateTime.parse(json["date"] as String),
      coordinates: Coordinates.fromJson(
        json["coordinates"] as Map<String, dynamic>,
      ),
      visited: json["visited"] as bool,
    );
  }

  String id;
  String title;
  String description;
  DateTime date;
  Coordinates coordinates;
  bool dirty;
  bool visited;

  Map<String, dynamic> toJson() {
    return {
      "pointId": id,
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "coordinates": coordinates.toJson(),
      "visited": visited,
    };
  }

  @override
  String toString() {
    return "InterestPointModel(id: $id dirty: $dirty visited: $visited title: $title, description: $description, "
        "date: $date, latitude: ${coordinates.latitude}, longitude: ${coordinates.longitude})";
  }
}

class Coordinates {
  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
    );
  }

  final double latitude;
  final double longitude;
  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }
}
