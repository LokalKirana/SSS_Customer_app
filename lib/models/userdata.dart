import 'package:flutter/material.dart';

class UserData {
  final String name;
  final int phone;
  final String imgUrl;
  final String locality;
  final String country;

  UserData({
    @required this.name,
    @required this.phone,
    @required this.imgUrl,
    @required this.locality,
    @required this.country,
  });
}
