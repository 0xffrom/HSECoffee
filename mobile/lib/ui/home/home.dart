import 'dart:core';
import 'package:flutter/material.dart';
import 'package:hse_coffee/ui/home/home_meets.dart';

import 'home_cabinet.dart';
import 'home_find_start.dart';

// Такое же виджет, как и SplashScreen, только передаём ему ещё и заголовок
class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Формирование состояния виджета
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeFindScreen(), HomeMeetsScreen(), HomeCabinetScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // В отличии от SplashScreen добавляем AppBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.find_replace),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Кабинет',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

