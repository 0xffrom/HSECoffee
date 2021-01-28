import 'dart:core';
import 'package:flutter/material.dart';

// Такое же виджет, как и SplashScreen, только передаём ему ещё и заголовок
class HomeScreen extends StatefulWidget {
  static const String routeName = "/Home";

  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Формирование состояния виджета
class _HomeScreenState extends State<HomeScreen> {

  // В отличии от SplashScreen добавляем AppBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home page',),
          ],
        ),
      ),
    );
  }
}