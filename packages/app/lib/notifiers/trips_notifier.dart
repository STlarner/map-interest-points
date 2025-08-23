import "package:core/core.dart";
import "package:flutter/material.dart";

import "../dependency_injection/firestore_manager.dart";
import "../dependency_injection/session_manager.dart";
import "../models/trip_model.dart";
import "async_state.dart";

class TripsNotifier extends ChangeNotifier {
  TripsNotifier();

  AsyncState<List<TripModel>> get upcomingTripsState => _upcomingTripsState;
  AsyncState<List<TripModel>> _upcomingTripsState = AsyncState.loading();

  Future<void> getAllUserTrips() async {
    GetIt.I<LogProvider>().log("Getting all user trips...", Severity.info);
    final user = GetIt.I<SessionManager>().user!;
    await GetIt.I<FirestoreManager>()
        .getCollection(collectionPath: "users/${user.uid}/trips")
        .then((collection) {
          final trips = collection
              .map(
                (doc) =>
                    TripModel.fromJson(doc.data()! as Map<String, dynamic>),
              )
              .toList();

          _upcomingTripsState = AsyncState.success(trips);
          notifyListeners();
        })
        .catchError((_) {
          _upcomingTripsState = AsyncState.error("Error getting trips");
          notifyListeners();
        });
  }
}
