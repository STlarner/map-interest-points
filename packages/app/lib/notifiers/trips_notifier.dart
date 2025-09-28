import "package:core/core.dart";
import "package:flutter/material.dart";

import "../dependency_injection/app_repository.dart";

import "../models/trip_model.dart";
import "async_state.dart";

class TripsNotifier extends ChangeNotifier {
  TripsNotifier();

  TripModel? selectedTrip;
  AsyncStatus tripsStatus = AsyncStatus.initial;
  List<TripModel> trips = [];

  List<TripModel> get upcomingTrips {
    return trips.where((trip) {
      final now = DateTime.now();
      final oneMonthLater = DateTime(now.year, now.month + 1, now.day);

      return trip.startDate.isAfter(now) &&
          trip.startDate.isBefore(oneMonthLater);
    }).toList();
  }

  Future<void> fetchAllUserTrips({bool forceRefresh = false}) async {
    if (tripsStatus == AsyncStatus.success && !forceRefresh) {
      return;
    }

    tripsStatus = AsyncStatus.loading;
    notifyListeners();
    GetIt.I<AppRepository>()
        .getAllTrips()
        .then((trips) {
          this.trips = trips;
          tripsStatus = AsyncStatus.success;
          notifyListeners();
        })
        .catchError((_) {
          tripsStatus = AsyncStatus.error;
          notifyListeners();
        });
  }
}
