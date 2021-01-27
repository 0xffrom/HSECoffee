import 'package:flutter/material.dart';
import 'package:hse_coffee/auth/authCode.dart';
import 'package:hse_coffee/auth/authEmail.dart';
import 'package:hse_coffee/auth/authName.dart';
import 'package:hse_coffee/auth/authGender.dart';
import 'package:hse_coffee/splash/Splash.dart';

import 'auth/authFaculty.dart';
import 'home/Home.dart';

// Запуск приложения
void main() => runApp(MyApp());

// Основной виджет приложения
class MyApp extends StatelessWidget {

  // Формируем маршрутизацию приложения
  final routes = <String, WidgetBuilder>{
    AuthFacultyScreen.routeName: (BuildContext context) => AuthFacultyScreen(),
    AuthNameScreen.routeName: (BuildContext context) => AuthNameScreen(),
    AuthCodeScreen.routeName: (BuildContext context) => AuthCodeScreen(),
    AuthEmailScreen.routeName: (BuildContext context) => AuthEmailScreen(),
    AuthGenderScreen.routeName: (BuildContext context) => AuthGenderScreen(),
    HomeScreen.routeName: (BuildContext context) => HomeScreen(title: 'HSECoffee')
  };

  // Необходимо переопределить метод строительства инстанса виджета
  @override
  Widget build(BuildContext context) {
    // Это будет приложение с поддержкой Material Design
    return MaterialApp(
      title: 'HSEcoffee',
      // в котором будет Splash Screen с указанием следующего маршрута
      home: SplashScreen(nextRoute: '/auth/email'),
      // передаём маршруты в приложение
      routes: routes,
    );
  }
}