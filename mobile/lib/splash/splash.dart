import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';

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
        body: Container(
            decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color.fromRGBO(10, 70, 252, 1.0),
                  Color.fromRGBO(151, 183, 250, 1.0)
                ])),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Stack(children: <Widget>[
                  Positioned(
                      top: -150, left: -40, child: buildCube(-45, 300, 300)),
                  Positioned(
                      top: -50, right: 10, child: buildCube(-45, 200, 200))
                ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30.0),
                            child: RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Добро пожаловать в ",
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.black,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "HSEcoffee",
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontSize: 54,
                                      fontWeight: FontWeight.bold))
                            ])))),
                  ],
                ),
                Expanded(
                    child: Stack(children: <Widget>[
                  Positioned(
                      left: -30, bottom: -150, child: buildCube(-45, 300, 300)),
                  Positioned(
                      right: -20,
                      bottom: -170,
                      child: buildCube(-45, 300, 300)),
                ]))
              ],
            )));
  }
}
