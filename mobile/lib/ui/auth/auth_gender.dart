import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/gender.dart';
import 'header.dart';
import 'package:hse_coffee/ui/widgets/button_continue.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import '../../router_auth.dart';

class AuthGenderScreen extends StatefulWidget {
  static const String routeName = "/auth/gender";

  @override
  _AuthGenderScreen createState() => _AuthGenderScreen();
}

class _AuthGenderScreen extends State<AuthGenderScreen> {
  @override
  void initState() {
    super.initState();
  }

  void callSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogLoading = DialogLoading(context: this.context);

    final _toggleButton = ToggleButton();

    bool _isValidInput() {
      if (_toggleButton.buttonState.isSelected.contains(true)) {
        return true;
      }

      callSnackBar("Выберите, пожалуйста, свой пол!");
      return false;
    }

    void _onButtonClick() {
      if (_isValidInput()) {
        UserStorage.instance.user.gender =
            _toggleButton.buttonState.isSelected[0]
                ? Gender.MALE
                : Gender.FEMALE;

        dialogLoading.show();

        Api.setUser(UserStorage.instance.user).then((value) => {
              if (value.isSuccess())
                RouterHelper.routeByUser(context, UserStorage.instance.user)
              else
                callSnackBar("Произошла ошибка! Попробуйте позже.")
            });

        dialogLoading.stop();
      }
    }

    return Scaffold(
        body: Builder(
            builder: (context) => SingleChildScrollView(
                reverse: true,
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Мой пол"),
                  _toggleButton,
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
                ]))));
  }
}

class ToggleButton extends StatefulWidget {
  final _ToggleButtonState buttonState = _ToggleButtonState();
  final Function onPressed;

  ToggleButton({Key key, this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return buttonState;
  }
}

class _ToggleButtonState extends State {
  List<bool> isSelected = <bool>[false, false];
  static const String FirstButtonText = "Мужской";
  static const String SecondButtonText = "Женский";

  _ToggleButtonState();

  void onClicked(int index) {
    if (isSelected[index]) return;

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
          child: TButton(
            FirstButtonText,
            () => onClicked(0),
            isClicked: isSelected[0],
          )),
      Padding(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
          child: TButton(
            SecondButtonText,
            () => onClicked(1),
            isClicked: isSelected[1],
          )),
    ]);
  }
}

class TButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;
  final bool isClicked;

  TButton(this._text, this._onPressed, {this.isClicked});

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 160.0,
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
