import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_coffee/auth/authCode.dart';
import 'package:hse_coffee/auth/authEmail.dart';
import 'package:hse_coffee/auth/authName.dart';
import 'package:hse_coffee/auth/authGender.dart';
import 'package:hse_coffee/splash/splash.dart';

import 'auth/authFaculty.dart';
import 'home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    AuthFacultyScreen.routeName: (BuildContext context) => AuthFacultyScreen(),
    AuthNameScreen.routeName: (BuildContext context) => AuthNameScreen(),
    AuthCodeScreen.routeName: (BuildContext context) => AuthCodeScreen(),
    AuthEmailScreen.routeName: (BuildContext context) => AuthEmailScreen(),
    AuthGenderScreen.routeName: (BuildContext context) => AuthGenderScreen(),
    HomeScreen.routeName: (BuildContext context) => HomeScreen(title: 'HSECoffee')
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSEcoffee',
      home: SplashScreen(nextRoute: '/auth/email'),
      routes: routes,
    );
  }
}