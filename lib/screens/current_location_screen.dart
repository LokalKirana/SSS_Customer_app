import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../widgets/location_input.dart';
import '../providers/auth.dart';

class CurrentLocation extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _buildingFocusNode = FocusNode();
  FocusNode _landmarkFocusNode = FocusNode();
  PlaceDetails _selectedPlace;
  Map<String, dynamic> _userData = {
    'name': '',
    'email': '',
    'building': '',
    'landmark': '',
  };

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

  void _getSelectedAddress(PlaceLocation currentPosition) {
    getPlaceDetails(
      currentPosition.latitude,
      currentPosition.longitude,
    ).then((placeDetails) {
      this.setState(() {
        _selectedPlace = placeDetails;
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _buildingFocusNode.dispose();
    _landmarkFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Register to continue',
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'name reuqired';
                          }
                          return null;
                        },
                        onSaved: (name) {
                          _userData['name'] = name;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(
                          _emailFocusNode,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _emailFocusNode,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (email) {
                          final emailRegex =
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          if (email.isEmpty) {
                            return 'email reuqired';
                          }
                          if (!RegExp(emailRegex).hasMatch(email)) {
                            return 'invalid Email';
                          }
                          return null;
                        },
                        onSaved: (email) {
                          _userData['email'] = email;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(
                          _buildingFocusNode,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _buildingFocusNode,
                        decoration: InputDecoration(
                            labelText:
                                'Flat/House No/Building Name/Society Name'),
                        validator: (address) {
                          if (address.isEmpty) {
                            return 'Building info is required.';
                          }

                          return null;
                        },
                        onSaved: (address) {
                          _userData['building'] = address;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(
                          _landmarkFocusNode,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _landmarkFocusNode,
                        decoration: InputDecoration(labelText: 'Landmark'),
                        validator: (address) {
                          if (address.isEmpty) {
                            return 'Landmark is required';
                          }

                          return null;
                        },
                        onSaved: (address) {
                          _userData['landmark'] = address;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submitData(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LocationInput(
                        getSelectedAddress: _getSelectedAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: _selectedPlace == null
                            ? Text(
                                'No Place Seleted yet',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${_selectedPlace.road},'),
                                  Text(
                                      '${_selectedPlace.subLocality}, ${_selectedPlace.subAdministrativeArea},'),
                                  Text(
                                      '${_selectedPlace.locality}, ${_selectedPlace.administrativeArea},'),
                                  Text(
                                      '${_selectedPlace.country}. Pin - ${_selectedPlace.postalCode},'),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save'),
              onPressed: _submitData,
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }

  void _submitData() async {
    if (_selectedPlace == null) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invaild'),
          content: Text('Initial Address location not set'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    final userRegistrationData = {
      "UserInfo": {
        "name": _userData['name'],
        "email": _userData['email'],
      },
      "AddressInfo": {
        "type": "default",
        "buildingInfo": _userData['building'],
        "road": "_selectedPlace.road",
        "landmark": _userData['landmark'],
        "subLocality": _selectedPlace.subLocality,
        "sub_adminstrative_area": _selectedPlace.subAdministrativeArea,
        "locality": _selectedPlace.locality,
        "adminstrative_area": _selectedPlace.administrativeArea,
        "country": _selectedPlace.country,
        "postal_code": _selectedPlace.postalCode,
        "latitude": _selectedPlace.latitude,
        "longitude": _selectedPlace.longitude
      }
    };
    await Provider.of<Auth>(context, listen: false)
        .register(userRegistrationData);
  }
}
