import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  final Function mapImage;

  MapScreen({
    this.initialLocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
    this.mapImage,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _googleMapController;
  TextEditingController _controller = TextEditingController();
  String searchAddr;
  LatLng selectedPlace;
  String selectedPlaceAddr;
  Marker _marker;

  @override
  void initState() {
    final Marker marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(
        widget.initialLocation.latitude,
        widget.initialLocation.longitude,
      ),
    );
    _marker = marker;
    super.initState();
  }

  void onMapCreated(controller) {
    setState(() {
      _googleMapController = controller;
    });
  }

  void searchAndNavigate() {
    print('Maoselect');
    if (searchAddr.length > 0) {
      Geolocator().placemarkFromAddress(searchAddr).then((result) {
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              result[0].position.latitude,
              result[0].position.longitude,
            ),
            zoom: 16,
          ),
        ));
        final Marker marker = Marker(
          markerId: MarkerId('1'),
          position: LatLng(
            result[0].position.latitude,
            result[0].position.longitude,
          ),
        );
        setState(() {
          _marker = marker;
        });
      });
    }
  }

  void getClickedPosition(LatLng position) {
    final Marker marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
    );
    setState(() {
      selectedPlace = position;
      _marker = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Map'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.of([_marker != null ? _marker : null]),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.initialLocation.latitude,
                  widget.initialLocation.longitude,
                ),
                zoom: 16,
              ),
              onTap: (postion) {
                getClickedPosition(postion);
              },
            ),
            Positioned(
              top: 20,
              right: 15,
              left: 15,
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter Address',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                        ),
                        onChanged: (val) => setState(
                          () => searchAddr = val,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchAndNavigate,
                      iconSize: 30.0,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: IconButton(
                iconSize: 90,
                color: Theme.of(context).primaryColor,
                splashColor: Colors.red,
                splashRadius: 40,
                icon: Icon(Icons.add_circle),
                onPressed: selectedPlace == null
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        widget.mapImage(selectedPlace);
                      },
              ),
            )
          ],
        ));
  }
}
