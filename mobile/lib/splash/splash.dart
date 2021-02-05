import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hse_coffee/splash/splash_background.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;

  SplashScreen({this.nextRoute});

  // все подобные виджеты должны создавать своё состояние,
  // нужно переопределять данный метод
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

// Создаём состояние виджета
class _SplashScreenState extends State<SplashScreen> {
  // Инициализация состояния
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    });
  }

  Widget buildCube(double _angle, double _height, double _width) {
    return Transform.rotate(
        angle: _angle,
        child: Center(
            child: Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.15),
                    borderRadius: BorderRadius.circular(40)),
                child: SizedBox(height: _height, width: _width))));
  }

  // Формирование виджета
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
            painter: BluePainter(),
            child: Column(children: <Widget>[
              Container(
                  width: double.infinity,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Добро\nпожаловать\nв ",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.black,
                                fontSize: 52,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "HSEcoffee",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.blueAccent,
                                fontSize: 56,
                                fontWeight: FontWeight.bold))
                      ])))),
              Transform.rotate(
                  angle: 76, child: Image(image: AssetImage('images/bird.png')))
            ])));
  }
}
