class NominatimOsmSearchModel {
  NominatimOsmSearchModel({
    required this.placeId,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.name,
    required this.displayName,
    required this.address,
  });

  factory NominatimOsmSearchModel.fromJson(Map<String, dynamic> json) {
    return NominatimOsmSearchModel(
      placeId: (json["place_id"] as num).toInt(),
      osmType: json["osm_type"] as String,
      osmId: (json["osm_id"] as num).toInt(),
      lat: double.parse(json["lat"] as String),
      lon: double.parse(json["lon"] as String),
      name: json["name"] as String?,
      displayName: json["display_name"] as String,
      address: json["address"] != null
          ? NominatimAddress.fromJson(json["address"] as Map<String, dynamic>)
          : null,
    );
  }
  final int placeId;
  final String osmType;
  final int osmId;
  final double lat;
  final double lon;
  final String? name;
  final String displayName;
  final NominatimAddress? address;
}

class NominatimAddress {
  NominatimAddress({
    this.road,
    this.suburb,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory NominatimAddress.fromJson(Map<String, dynamic> json) {
    return NominatimAddress(
      road: json["road"] as String?,
      suburb: json["suburb"] as String?,
      city: json["city"] as String?,
      state: json["state"] as String?,
      postcode: json["postcode"] as String?,
      country: json["country"] as String?,
      countryCode: json["country_code"] as String?,
    );
  }
  final String? road;
  final String? suburb;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final String? countryCode;

  String get formattedAddress {
    final parts = [
      road,
      suburb,
      city,
      state,
      postcode,
      country,
    ].where((e) => e != null && e.isNotEmpty).toList();
    return parts.join(", ");
  }
}
