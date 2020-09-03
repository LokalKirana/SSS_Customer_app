import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../models/place.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function getSelectedAddress;

  LocationInput({@required this.getSelectedAddress});
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  PlaceDetails _selectedPlace;

  Future<PlaceDetails> getPlaceDetails(
    double latitude,
    double longitude,
  ) async {
    final placeList =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    final place = placeList[0];
    final PlaceDetails details = PlaceDetails(
      latitude: latitude,
      longitude: longitude,
      road: place.name,
      subLocality: place.subLocality,
      subAdministrativeArea: place.subAdministrativeArea,
      locality: place.locality,
      administrativeArea: place.administrativeArea,
      country: place.country,
      postalCode: place.postalCode,
    );
    return details;
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
    );
    this.setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.getSelectedAddress(
      PlaceLocation(
        latitude: locData.latitude,
        longitude: locData.longitude,
      ),
    );
  }

  void _getSelectedMapImage(LatLng currentPosition) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.getSelectedAddress(
      PlaceLocation(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
      ),
    );
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
            isSelecting: true,
            initialLocation: _selectedPlace == null
                ? PlaceLocation(
                    latitude: locData.latitude,
                    longitude: locData.longitude,
                  )
                : PlaceLocation(
                    latitude: _selectedPlace.latitude,
                    longitude: _selectedPlace.longitude,
                  ),
            mapImage: _getSelectedMapImage),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  //'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823_960_720.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
