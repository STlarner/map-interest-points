import "dart:ffi";

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

  final TripModel trip;
  AsyncStatus interestPointsStatus = AsyncStatus.initial;
  InterestPointModel? draftInterestPoint;
  InterestPointModel? selectedInterestPoint;

  AsyncStatus mapSearchStatus = AsyncStatus.initial;
  Map<DateTime, List<InterestPointModel>> interestPointsByDay = {};
  String? mapSearchQuery;
  List<NominatimOsmSearchModel> mapSearchResults = [];

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

  void addDraftInterestPoint(InterestPointModel interestPoint) {
    draftInterestPoint = interestPoint;
    notifyListeners();
  }

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

  void clearMapSearch() {
    mapSearchQuery = "";
    mapSearchResults = [];
    mapSearchStatus = AsyncStatus.initial;
    notifyListeners();
  }

  InterestPointModel buildInterestPoint(NominatimOsmSearchModel model) {
    return InterestPointModel(
      title: model.name!,
      description: model.address!.formattedAddress,
      date: DateTime.now(),
      coordinates: Coordinates(latitude: model.lat, longitude: model.lon),
    );
  }

  void selectInterestPoint(InterestPointModel interestPoint) {
    selectedInterestPoint = interestPoint;
    notifyListeners();
  }

  void clearSelectedInterestPoint() {
    selectedInterestPoint = null;
    notifyListeners();
  }
}
