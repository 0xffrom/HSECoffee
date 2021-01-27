import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/Api.dart';
import 'package:hse_coffee/business_logic/UserStorage.dart';
import 'package:hse_coffee/widgets/button_continue.dart';
import '../RouterHelper.dart';
import 'header.dart';

class AuthNameScreen extends StatefulWidget {
  static const String routeName = "/auth/name";

  @override
  _AuthNameScreen createState() => _AuthNameScreen();
}

class _AuthNameScreen extends State<AuthNameScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  final firstNameFieldController = TextEditingController();
  final secondNameFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void callSnackBar(String text) {
    globalKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    firstNameFieldController.dispose();
    secondNameFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textFieldsKey = GlobalKey<FormState>();

    void _onButtonClick() {
      if (textFieldsKey.currentState.validate()) {
        UserStorage.instance.user.firstName = firstNameFieldController.text;
        UserStorage.instance.user.lastName = secondNameFieldController.text;

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
                  Header(title: "Меня зовут"),
                  Form(
                      key: textFieldsKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                            child: TextField(
                              controller: firstNameFieldController,
                              hintText: "Введите своё имя",
                              labelText: "Имя",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                            child: TextField(
                                controller: secondNameFieldController,
                                hintText: "Введите свою фамилию",
                                labelText: "Фамилия"),
                          )
                        ],
                      )),
                  ButtonContinue(onPressed: _onButtonClick)
                ])));
  }
}

class TextField extends StatelessWidget {
  static const int MinLengthName = 2;

  final String hintText;
  final String labelText;
  final TextEditingController controller;

  TextField({Key key, this.hintText, this.labelText, this.controller})
      : super(key: key);

  bool _isValidName(String text) {
    return text != null && text.length > MinLengthName;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      validator: (input) =>
          _isValidName(input) ? null : "Пожалуйста, заполните корректно поле!",
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
