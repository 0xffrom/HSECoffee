import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hse_coffee/business_logic/Api.dart';
import 'package:hse_coffee/business_logic/UserStorage.dart';
import 'package:hse_coffee/data/gender.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/widgets/ButtonContinue.dart';
import '../RouterHelper.dart';
import 'header.dart';

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
    final _toggleButtonState = _ToggleButtonState();

    bool _isValidInput() {
      if (_toggleButtonState.isSelected.contains(true)) {
        return true;
      }

      callSnackBar("Выберите, пожалуйста, свой пол!");
      return false;
    }

    void _onButtonClick() {
      if (_isValidInput()) {
        UserStorage.instance.user.gender =
            _toggleButtonState.isSelected[0] ? Gender.MALE : Gender.FEMALE;

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
                  ToggleButton(_toggleButtonState),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 80.0, vertical: 10.0),
                      child: Text(
                        "Прежде чем продолжить, выберите, пожалуйста, свой пол.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromRGBO(81, 81, 81, 1),
                        ),
                      )),
                  ButtonContinue(onPressed: _onButtonClick),
                ])));
  }
}

class ToggleButton extends StatefulWidget {
  final _ToggleButtonState buttonState;
  final Function onPressed;

  ToggleButton(this.buttonState, {Key key, this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return buttonState;
  }
}

class _ToggleButtonState extends State {
  final isSelected = <bool>[false, false];
  static const String FirstButtonText = "Мужской";
  static const String SecondButtonText = "Женский";

  void onClicked(int index) {
    if(isSelected[index])
      return;

    setState(() {
        bool state = isSelected[index];
        isSelected[index] = !state;
        for (int i = 0; i < isSelected.length; i++) {
          if (i != index) {
            isSelected[i] = state;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 10.0),
          child: _TButton(
            FirstButtonText,
            () => onClicked(0),
            isClicked: isSelected[0],
          )),
      Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
          child: _TButton(
            SecondButtonText,
            () => onClicked(1),
            isClicked: isSelected[1],
          )),
    ]);
  }
}

class _TButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;
  final bool isClicked;

  _TButton(this._text, this._onPressed, {this.isClicked});

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 240.0,
      height: 50.0,
      child: isClicked
          ? _ClickedButton(_text, _onPressed)
          : _NotClickedButton(_text, _onPressed),
    );
  }
}

class _ClickedButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;

  _ClickedButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        _text,
        style: TextStyle(fontSize: 16.0),
      ),
      style: OutlinedButton.styleFrom(
        primary: Color.fromRGBO(20, 92, 212, 1),
        side: BorderSide(color: Color.fromRGBO(20, 102, 212, 1), width: 2),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32))),
      ),
      onPressed: () {
        _onPressed();
      },
    );
  }
}

class _NotClickedButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;

  _NotClickedButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        _text,
        style: TextStyle(fontSize: 16.0),
      ),
      style: OutlinedButton.styleFrom(
        primary: Color.fromRGBO(81, 81, 81, 1),
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32))),
      ),
      onPressed: () {
        _onPressed();
      },
    );
  }
}
