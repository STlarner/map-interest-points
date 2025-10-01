import "package:core/core.dart";
import "package:flutter/material.dart";
import "package:latlong2/latlong.dart";

import "../dependency_injection/app_repository.dart";
import "../models/interest_point_model.dart";
import "../models/nominatim_osm_search_model.dart";
import "../models/trip_day_model.dart";
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
  List<TripDayModel> tripDays = [];

  /// cancellable to sync dirty interest points with backend
  CancelableOperation<void>? syncDirtyPointsCancelable;

  /// loading status of search API (OSM provider or similar)
  AsyncStatus mapSearchStatus = AsyncStatus.initial;

  /// search query for the map and search screen
  String? mapSearchQuery;

  /// search results for the map and search screen
  List<NominatimOsmSearchModel> mapSearchResults = [];

  /// fetches interest points from the trip
  Future<void> fetchInterestPoints() async {
    interestPointsStatus = AsyncStatus.loading;
    notifyListeners();
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
          notifyListeners();
        });
  }

  /// groups interest points by day
  void mapInterestPointsByDay() {
    tripDays = trip.interestPoints.fold<List<TripDayModel>>([], (
      result,
      interestPoint,
    ) {
      TripDayModel? tripDay;
      try {
        tripDay = result.firstWhere((item) => item.date == interestPoint.date);
        tripDay.interestPoints.add(interestPoint);
        return result;
      } catch (e) {
        tripDay = TripDayModel(
          day: interestPoint.date.difference(trip.startDate).inDays + 1,
          date: interestPoint.date,
          interestPoints: [interestPoint],
        );
        result.add(tripDay);
      }

      return result;
    })..sort((a, b) => a.day.compareTo(b.day));
  }

  void updateInterestPoints() {
    mapInterestPointsByDay();
    notifyListeners();
  }

  void deleteInterestPoint(InterestPointModel interestPoint) {
    trip.interestPoints.remove(interestPoint);
    mapInterestPointsByDay();
    notifyListeners();
  }

  void setInterestPointVisited(InterestPointModel interestPoint, bool visited) {
    interestPoint.dirty = true;
    interestPoint.visited = visited;
    syncDirtyInterestPoints();
  }

  Future<void> syncDirtyInterestPoints() async {
    GetIt.I<LogProvider>().log(
      "Started syncing dirty points...",
      Severity.debug,
    );

    final dirtyInterestPoints = trip.interestPoints.where(
      (interestPoint) => interestPoint.dirty,
    );
    await syncDirtyPointsCancelable?.cancel();

    syncDirtyPointsCancelable = CancelableOperation.fromFuture(
      Future.delayed(const Duration(seconds: 3)),
    );

    syncDirtyPointsCancelable?.then((_) {
      // TODO(Lo): chiamata API per sincronizzare selezione dei punti di interesse
      GetIt.I<LogProvider>().log(
        "Finished syncing dirty points",
        Severity.debug,
      );
    });
  }

  /// adds a draft interest point from map search or long press
  void addDraftInterestPoint(InterestPointModel interestPoint) {
    draftInterestPoint = interestPoint;
    notifyListeners();
  }

  /// clears the draft interest point
  void clearDraftInterestPoint() {
    draftInterestPoint = null;
    notifyListeners();
  }

  /// add a draft interest point to the trip, doesn't clear the draft
  /// Note: it also updates the id of the draft interest point with the one returned by the server
  void promoteDraftInterestPointToExisting(String id) {
    draftInterestPoint!.id = id;
    trip.interestPoints.add(draftInterestPoint!);
    trip.interestPoints.sort((a, b) => a.date.compareTo(b.date));
    mapInterestPointsByDay();
    notifyListeners();
  }

  LatLng getMapInitialCenter() {
    if (trip.interestPoints.isEmpty) {
      return const LatLng(40.7128, -74.0060);
    }

    if (selectedInterestPoint != null) {
      return selectedInterestPoint!.coordinates.latLng;
    }

    return trip.interestPoints.first.coordinates.latLng;
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
      date: trip.startDate,
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
