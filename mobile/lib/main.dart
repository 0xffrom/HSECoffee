import 'package:flutter/material.dart';
import 'package:hse_coffee/auth/AuthCode.dart';
import 'package:hse_coffee/auth/AuthEmail.dart';
import 'package:hse_coffee/auth/AuthName.dart';
import 'package:hse_coffee/splash/Splash.dart';

import 'home/Home.dart';

// Запуск приложения
void main() => runApp(MyApp());

// Основной виджет приложения
class MyApp extends StatelessWidget {

  // Формируем маршрутизацию приложения
  final routes = <String, WidgetBuilder>{
    AuthNameScreen.routeName: (BuildContext context) => AuthNameScreen(),
    AuthCodeScreen.routeName: (BuildContext context) => AuthCodeScreen(),
    AuthEmailScreen.routeName: (BuildContext context) => AuthEmailScreen(),
    HomeScreen.routeName: (BuildContext context) => HomeScreen(title: 'HSECoffee')
  };

  // Необходимо переопределить метод строительства инстанса виджета
  @override
  Widget build(BuildContext context) {
    // Это будет приложение с поддержкой Material Design
    return MaterialApp(
      title: 'HSEcoffee',
      // в котором будет Splash Screen с указанием следующего маршрута
      home: SplashScreen(nextRoute: '/Auth/email'),
      // передаём маршруты в приложение
      routes: routes,
    );
  }
}