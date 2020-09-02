import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'themes/default_theme.dart';
import './home.dart';

void main() async => {
      WidgetsFlutterBinding.ensureInitialized(),

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]), // To turn off landscape mode

      runApp(SSSCustomer())
    };

class SSSCustomer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DefaultTheme.themeData,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
