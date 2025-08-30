import "package:core/core.dart";
import "package:flutter/material.dart";

import "../dependency_injection/firestore_manager.dart";
import "../dependency_injection/session_manager.dart";
import "../models/trip_model.dart";
import "async_state.dart";

class TripsNotifier extends ChangeNotifier {
  TripsNotifier();

  AsyncState<List<TripModel>> get allUserTripsState => _allUserTripsState;
  AsyncState<List<TripModel>> _allUserTripsState = AsyncState.loading();

  AsyncState<List<TripModel>> get upcomingTripsState {
    switch (_allUserTripsState.status) {
      case AsyncStatus.initial:
      case AsyncStatus.loading:
      case AsyncStatus.error:
        return _allUserTripsState;

      case AsyncStatus.success:
        final upcomingTrips = _allUserTripsState.data!.where((trip) {
          final now = DateTime.now();
          final oneMonthLater = DateTime(now.year, now.month + 1, now.day);

          return trip.startDate.isAfter(now) &&
              trip.startDate.isBefore(oneMonthLater);
        }).toList();
        return AsyncState.success(upcomingTrips);
    }
  }

  Future<void> fetchAllUserTrips() async {
    GetIt.I<LogProvider>().log("Getting all user trips...", Severity.info);

    GetIt.I<NetworkManager>().get("/trips").then((data) {
      final listData = data as List<dynamic>;
      final trips =
          listData
              .map(
                (trip) =>
                    TripModel.fromJson(json: trip as Map<String, dynamic>),
              )
              .toList()
            ..sort((a, b) => b.startDate.compareTo(a.startDate));
      _allUserTripsState = AsyncState.success(trips);
      notifyListeners();
    });
  }
}
