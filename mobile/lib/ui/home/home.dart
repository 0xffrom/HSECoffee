import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/meet.dart';
import 'package:hse_coffee/data/meet_status.dart';
import 'package:hse_coffee/ui/home/home_meets.dart';
import 'package:hse_coffee/ui/home/home_person_info.dart';

import 'home_cabinet.dart';
import 'home_find_start.dart';
import 'home_loading.dart';

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

  _HomeScreenState() {
    Timer(Duration(seconds: 3), () {
      _updByMeet(null);
    });

    wait();
  }

  void wait() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      _updByMeet(timer);
    });
  }

  void callSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void callErrorSnackBar() {
    callSnackBar('Ошибка! Попробуйте повторить запрос позже.');
  }

  void _updByMeet(Timer timer) {
    Api.getMeet()
        .then((value) => {
              if (value.isSuccess())
                {
                  _navigateByMeet(value.getData()),
                  if (value.getData().meetStatus == MeetStatus.ACTIVE)
                    {
                      timer.cancel(),
                      Timer(
                          Duration(
                              milliseconds:
                                  value.getData().expiresDate.microsecond -
                                      DateTime.now().millisecond), () {
                        wait();
                      })
                    }
                }
            })
        .timeout(Duration(seconds: 15))
        .catchError((obj) => print(obj.toString()));
  }

  final List<Widget> _widgetOptions = <Widget>[
    HomeLoadingScreen(),
    HomeMeetsScreen(),
    HomeCabinetScreen()
  ];

  Widget getScreenByMeet(Meet meet, MeetStatus meetStatus) {
    if (meetStatus == MeetStatus.NONE || meetStatus == MeetStatus.FINISHED) {
      return HomeFindScreen(_navigateByMeetStatus);
    } else if (meetStatus == MeetStatus.SEARCH) {
      return HomeLoadingScreen(
          withCancel: true, navigatorFunc: _navigateByMeetStatus);
    } else if (meetStatus == MeetStatus.ACTIVE && meet != null) {
      var user = UserStorage().user.email == meet.user1.email
          ? meet.user2
          : meet.user1;
      return HomePersonScreen(user, withBack: false);
    }

    return HomeLoadingScreen();
  }

  void _navigateByMeet(Meet meet) {
    _widgetOptions[0] = getScreenByMeet(meet, meet.meetStatus);

    if (_selectedIndex == 0) {
      _onItemTapped(0);
    }
  }

  void _navigateByMeetStatus(MeetStatus meetStatus) {
    _widgetOptions[0] = getScreenByMeet(null, meetStatus);

    if (_selectedIndex == 0) {
      _onItemTapped(0);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
        selectedItemColor: Color.fromRGBO(67, 100, 248, 0.98),
        onTap: _onItemTapped,
      ),
    );
  }
}
