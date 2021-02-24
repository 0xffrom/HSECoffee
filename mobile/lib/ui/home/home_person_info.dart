import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/ui/auth/header.dart';
import 'package:hse_coffee/ui/widgets/button_continue.dart';

class HomePersonScreen extends StatefulWidget {
  static const String routeName = "/home/person";
  final User user;

  HomePersonScreen(this.user);

  @override
  _HomePersonScreen createState() => _HomePersonScreen(user);
}

class _HomePersonScreen extends State<HomePersonScreen> {
  final User user;

  _HomePersonScreen(this.user);

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
