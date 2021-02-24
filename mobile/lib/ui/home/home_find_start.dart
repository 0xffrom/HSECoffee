import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/ui/auth/header.dart';
import 'package:hse_coffee/ui/home/home_person_info.dart';
import 'package:hse_coffee/ui/widgets/button_continue.dart';

class HomeFindScreen extends StatefulWidget {
  static const String routeName = "/home/find";

  @override
  _HomeFindScreen createState() => _HomeFindScreen();
}

class _HomeFindScreen extends State<HomeFindScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) => Column(
                  children: [
                    Stack(
                      children: [
                        Header(title: "Поиск собеседника"),
                      ],
                    ),
                    Expanded(child: ButtonContinue(textButton: "Найти встречу"))
                  ],
                )));
  }
}
