import 'package:flutter/material.dart';

class DefaultTheme {
  DefaultTheme();

  static final ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: const Color(0XFFa90aff),
    accentColor: const Color(0XFF3d71eb),
    canvasColor: const Color(0xFF181d2f),
    errorColor: const Color(0xFFA91818),
  );
}
