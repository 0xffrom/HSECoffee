import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/data/User.dart';
import 'package:hse_coffee/widgets/ButtonContinue.dart';
import 'Header.dart';

class AuthNameScreen extends StatefulWidget {
  static const String routeName = "/Auth/name";

  @override
  _AuthNameScreen createState() => _AuthNameScreen();
}

class _AuthNameScreen extends State<AuthNameScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  final textFieldKey = GlobalKey<FormState>();
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void callSnackBar(String text) {
      globalKey.currentState.showSnackBar(SnackBar(content: Text(text)));
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) =>
                Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Меня зовут"),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                    child: Form(
                        key: textFieldKey,
                        child: TextField(hintText: "Введите своё имя", labelText: "Имя")),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                    child: Form(
                        child: TextField(hintText: "Введите свою фамилию", labelText: "Фамилия")),
                  ),
                  ButtonContinue()
                ])));
  }
}

class ScreenAuthNameArguments {
  final User user;

  ScreenAuthNameArguments(this.user);
}

class TextField extends StatelessWidget {
  final String hintText;
  final String labelText;

  TextField({Key key, this.hintText, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 2,
            color: Colors.blueAccent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        labelText: labelText,
      ),
    );
  }
}
