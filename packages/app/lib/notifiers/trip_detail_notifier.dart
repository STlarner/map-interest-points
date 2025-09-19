import "package:core/core.dart";
import "package:flutter/material.dart";

import "../dependency_injection/app_repository.dart";
import "../models/interest_point_model.dart";
import "../models/nominatim_osm_search_model.dart";
import "../models/trip_model.dart";
import "async_state.dart";

class TripDetailNotifier extends ChangeNotifier {
  TripDetailNotifier({required this.trip}) {
    fetchInterestPoints();
  }

  /// trip that is enriched with interest points
  final TripModel trip;

  /// loading status of interest points in the trip
  AsyncStatus interestPointsStatus = AsyncStatus.initial;

  /// draft interest point that is being added on the map by search or long press
  InterestPointModel? draftInterestPoint;

  /// selected interest point that is being displayed on the map, it can be the draft or an existing one
  InterestPointModel? selectedInterestPoint;

  /// interest points grouped by day
  Map<DateTime, List<InterestPointModel>> interestPointsByDay = {};

  /// loading status of search API (OSM provider or similar)
  AsyncStatus mapSearchStatus = AsyncStatus.initial;

  /// search query for the map and search screen
  String? mapSearchQuery;

  /// search results for the map and search screen
  List<NominatimOsmSearchModel> mapSearchResults = [];

  /// fetches interest points from the trip
  Future<void> fetchInterestPoints() async {
    interestPointsStatus = AsyncStatus.loading;
    GetIt.I<AppRepository>()
        .getInterestPoints(trip)
        .then((interestPoints) {
          interestPointsStatus = AsyncStatus.success;
          trip.interestPoints = interestPoints
            ..sort((a, b) => a.date.compareTo(b.date));
          mapInterestPointsByDay();
          notifyListeners();
        })
        .catchError((_) {
          interestPointsStatus = AsyncStatus.error;
        });
  }

  /// groups interest points by day
  void mapInterestPointsByDay() {
    interestPointsByDay = trip.interestPoints
        .fold<Map<DateTime, List<InterestPointModel>>>({}, (
          result,
          interestPoint,
        ) {
          final date = DateTime(
            interestPoint.date.year,
            interestPoint.date.month,
            interestPoint.date.day,
          );

          result.putIfAbsent(date, () => []).add(interestPoint);
          return result;
        });
  }

  /// adds a draft interest point from map search or long press
  void addDraftInterestPoint(InterestPointModel interestPoint) {
    draftInterestPoint = interestPoint;
    notifyListeners();
  }

  void clearDraftInterestPoint() {
    draftInterestPoint = null;
    notifyListeners();
  }

  /// searches for interest points in the map
  Future<void> mapSearch(String query) async {
    mapSearchStatus = AsyncStatus.loading;
    notifyListeners();
    mapSearchQuery = query;
    try {
      final result = await GetIt.I<AppRepository>().mapSearch(query);
      mapSearchResults = result;
      mapSearchStatus = AsyncStatus.success;
    } catch (e) {
      mapSearchResults = [];
      mapSearchStatus = AsyncStatus.error;
    }
    notifyListeners();
  }

  /// clears the search query and results
  void clearMapSearch() {
    mapSearchQuery = "";
    mapSearchResults = [];
    mapSearchStatus = AsyncStatus.initial;
    notifyListeners();
  }

  /// builds an interest point from a search result
  InterestPointModel buildInterestPoint(NominatimOsmSearchModel model) {
    return InterestPointModel(
      id: "draft",
      title: model.name!,
      description: model.address!.formattedAddress,
      date: DateTime.now(),
      coordinates: Coordinates(latitude: model.lat, longitude: model.lon),
    );
  }

  /// selects an interest point from an existing one on the map, after a search query or after along press
  void selectInterestPoint(InterestPointModel interestPoint) {
    selectedInterestPoint = interestPoint;
    notifyListeners();
  }

  /// clears the selected interest point
  void clearSelectedInterestPoint() {
    selectedInterestPoint = null;
    notifyListeners();
  }
}
