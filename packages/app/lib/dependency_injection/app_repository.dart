import "package:core/core.dart";

import "../models/trip_model.dart";

class AppRepository {
  AppRepository();

  Future<List<TripModel>> getAllTrips() async {
    final data = await GetIt.I<NetworkManager>().get("/trips");
    final listData = data as List<dynamic>;
    return listData
        .map((trip) => TripModel.fromJson(json: trip as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }
}
