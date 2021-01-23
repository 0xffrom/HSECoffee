import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hse_coffee/business_logic/Api.dart';
import 'package:hse_coffee/business_logic/UserStorage.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/widgets/ButtonContinue.dart';
import '../RouterHelper.dart';
import 'Header.dart';

class AuthGenderScreen extends StatefulWidget {
  static const String routeName = "/auth/gender";

  @override
  _AuthGenderScreen createState() => _AuthGenderScreen();
}

class _AuthGenderScreen extends State<AuthGenderScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void callSnackBar(String text) {
    globalKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textFieldsKey = GlobalKey<FormState>();

    void _onButtonClick() {
      // TODO: Реализовать
      if (textFieldsKey.currentState.validate()) {
        Api.setUser(UserStorage.instance.user).then((value) => {
              if (value.isSuccess())
                RouterHelper.routeByUser(context, UserStorage.instance.user)
              else
                callSnackBar("Произошла ошибка! Попробуйте позже.")
            });
      }
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) =>
                Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Мой пол"),
                  ToggleButton(),
                  ButtonContinue(onPressed: _onButtonClick)
                ])));
  }
}

class ToggleButton extends StatelessWidget {
  final isSelected = <bool>[false, false];

  ToggleButton({Key key, this.onPressed}) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: ДОДЕЛАЙ КНОПКИ
    return Column(children: <Widget>[

      GradientButton(
        child: Text("Мужской", style: TextStyle(fontSize: 16.0)),
        callback: () {
          onPressed();
        },
        increaseWidthBy: 150.0,
        increaseHeightBy: 10,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(0, 82, 212, 1),
              Color.fromRGBO(49, 94, 252, 1),
              Color.fromRGBO(111, 177, 252, 1)
            ]),
        shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
      ),
      GradientButton(
        child: Text("Женский", style: TextStyle(fontSize: 16.0)),
        callback: () {
          onPressed();
        },
        increaseWidthBy: 150.0,
        increaseHeightBy: 10,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(0, 82, 212, 1),
              Color.fromRGBO(49, 94, 252, 1),
              Color.fromRGBO(111, 177, 252, 1)
            ]),
        shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
      )
    ]);
  }
}
