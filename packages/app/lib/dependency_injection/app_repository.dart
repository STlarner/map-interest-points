import "dart:convert";

import "package:core/core.dart";

import "../models/interest_point_model.dart";
import "../models/nominatim_osm_search_model.dart";
import "../models/trip_model.dart";

class AppRepository {
  AppRepository();

  late final NetworkManager _networkManager = GetIt.I<NetworkManager>();

  Future<List<TripModel>> getAllTrips() async {
    final data = await _networkManager.get("/trips");
    final listData = data as List<dynamic>;
    return listData
        .map((trip) => TripModel.fromJson(json: trip as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Future<List<InterestPointModel>> getInterestPoints(TripModel trip) async {
    final data = await _networkManager.get("/trips/${trip.id}/interest_points");
    final listData = data as List<dynamic>;
    return listData
        .map(
          (interestPoint) => InterestPointModel.fromJson(
            interestPoint as Map<String, dynamic>,
          ),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<List<NominatimOsmSearchModel>> mapSearch(String query) async {
    _networkManager.overrideBaseUrl = "https://nominatim.openstreetmap.org";
    final data = await _networkManager.get(
      "/search",
      queryParams: {
        "q": query,
        "format": "json",
        "limit": 10,
        "addressdetails": 1,
        "accept-language": "en",
      },
    );
    final listData = data as List<dynamic>;
    return listData
        .map(
          (place) =>
              NominatimOsmSearchModel.fromJson(place as Map<String, dynamic>),
        )
        .toList();
  }

  Future<InterestPointModel> addInterestPoint(
    TripModel trip,
    InterestPointModel interestPoint,
  ) async {
    final data = await _networkManager.post(
      "/trips/${trip.id}/interest_points",
      body: interestPoint.toJson(),
    );
    return InterestPointModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> updateInterestPoint(
    TripModel trip,
    InterestPointModel interestPoint,
  ) async {
    final data = await _networkManager.patch(
      "/trips/${trip.id}/interest_points/${interestPoint.id}",
      body: interestPoint.toJson(),
    );
    return data;
  }

  Future<void> deleteInterestPoint(
    TripModel trip,
    InterestPointModel interestPoint,
  ) async {
    final data = await _networkManager.delete(
      "/trips/${trip.id}/interest_points/${interestPoint.id}",
    );
    return data;
  }

  Future<void> setInterestPointsVisited(
    TripModel trip,
    List<InterestPointModel> interestPoints,
  ) async {
    final body = interestPoints.map((e) => e.toJson()).toList();
    final data = await _networkManager.patch(
      "/trips/${trip.id}/interest_points/visited",
      body: body,
    );
    return data;
  }
}
