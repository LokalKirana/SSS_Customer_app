import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import './providers/auth.dart';
import './screens/login_screen.dart';
import './screens/otp_screen.dart';
import './screens/current_location_screen.dart';
import './screens/user_location_screen.dart';

import 'themes/default_theme.dart';
import 'screens/home_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) {
          authData.tryAutoLogin();
          return MaterialApp(
            title: 'Flutter Demo',
            theme: DefaultTheme.themeData,
            home: authData.isAuth
                ? authData.isRegistered ? HomeScreen() : CurrentLocation()
                : authData.userPhone == null
                    ? LoginScreen()
                    : OtpConfirmScreen(),
            routes: {
              LocationScreen.routeName: (_) => LocationScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
