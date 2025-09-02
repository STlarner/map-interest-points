import "package:core/core.dart";
import "package:flutter/material.dart";

import "../dependency_injection/app_repository.dart";
import "../models/trip_model.dart";
import "async_state.dart";

class TripDetailNotifier extends ChangeNotifier {
  TripDetailNotifier({required this.trip}) {
    fetchInterestPoints();
  }

  final TripModel trip;
  AsyncStatus interestPointsStatus = AsyncStatus.initial;

  Future<void> fetchInterestPoints() async {
    interestPointsStatus = AsyncStatus.loading;
    GetIt.I<AppRepository>()
        .getInterestPoints(trip)
        .then((interestPoints) {
          interestPointsStatus = AsyncStatus.success;
          trip.interestPoints = interestPoints;
          notifyListeners();
        })
        .catchError((_) {
          interestPointsStatus = AsyncStatus.error;
        });
  }
}
