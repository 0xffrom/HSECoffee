import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_coffee/ui/auth/auth_code.dart';
import 'package:hse_coffee/ui/auth/auth_contacts.dart';
import 'package:hse_coffee/ui/auth/auth_email.dart';
import 'package:hse_coffee/ui/auth/auth_faculty.dart';
import 'package:hse_coffee/ui/auth/auth_gender.dart';
import 'package:hse_coffee/ui/auth/auth_name.dart';
import 'package:hse_coffee/ui/auth/auth_photo.dart';
import 'package:hse_coffee/ui/home/home.dart';
import 'package:hse_coffee/ui/splash/splash.dart';
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
    AuthPhotoScreen.routeName: (BuildContext context) => AuthPhotoScreen(),
    AuthContactsScreen.routeName: (BuildContext context) => AuthContactsScreen(),
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
