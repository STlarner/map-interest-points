import "package:core/core.dart";
import "package:flutter/material.dart";

import "../dependency_injection/app_repository.dart";

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
    GetIt.I<AppRepository>()
        .getAllTrips()
        .then((trips) {
          _allUserTripsState = AsyncState.success(trips);
          notifyListeners();
        })
        .catchError((_) {
          _allUserTripsState = AsyncState.error("Error fetching trips");
        });
  }
}
