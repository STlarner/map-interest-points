import "interest_point_model.dart";

class TripDayModel {
  TripDayModel({
    required this.day,
    required this.date,
    required this.interestPoints,
  });

  int day;
  DateTime date;
  List<InterestPointModel> interestPoints;
}
