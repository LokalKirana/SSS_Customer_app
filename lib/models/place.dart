import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;

  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
  });
}

class PlaceDetails {
  final double latitude;
  final double longitude;
  final String road;
  final String subLocality;
  final String subAdministrativeArea;
  final String locality;
  final String administrativeArea;
  final String country;
  final String postalCode;

  PlaceDetails({
    @required this.latitude,
    @required this.longitude,
    @required this.road,
    @required this.subLocality,
    @required this.subAdministrativeArea,
    @required this.locality,
    @required this.administrativeArea,
    @required this.country,
    @required this.postalCode,
  });
}
