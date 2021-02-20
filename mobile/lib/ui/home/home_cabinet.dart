import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';

import 'home_cabinet_header.dart';
import 'home_cabinet_settings.dart';

class HomeCabinetScreen extends StatefulWidget {
  static const String routeName = "/home/lk";

  @override
  _HomeCabinetScreen createState() => _HomeCabinetScreen();
}

class _HomeCabinetScreen extends State<HomeCabinetScreen> {
  Header _header = Header(UserStorage.instance.user);
  Settings _settings = Settings(UserStorage.instance.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.assignment_turned_in_outlined),
              onPressed: () {
                if (_settings.floatingButtonPress != null)
                  _settings.floatingButtonPress();
              },
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Builder(
            builder: (context) => SingleChildScrollView(
                  reverse: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[_header, _settings],
                  ),
                )));
  }
}
