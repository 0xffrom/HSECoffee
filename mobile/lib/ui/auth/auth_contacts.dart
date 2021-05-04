import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/contact.dart';
import 'package:hse_coffee/ui/widgets/button_continue.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import '../../router_auth.dart';
import 'header.dart';

class AuthContactsScreen extends StatefulWidget {
  static const String routeName = "auth/contacts";

  @override
  _AuthContactsScreen createState() => _AuthContactsScreen();
}

class _AuthContactsScreen extends State<AuthContactsScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  final telegramFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void callSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    telegramFieldController.dispose();

    super.dispose();
  }

  String tgClean(String tg) {
    return tg.trim().replaceAll("@", "");
  }

  @override
  Widget build(BuildContext context) {
    final dialogLoading = DialogLoading(context: this.context);

    void callSnackBar(String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    void errorSnackBar() {
      callSnackBar('Ошибка! Попробуйте повторить запрос позже.');
    }

    final textFieldsKey = GlobalKey<FormState>();

    void _onButtonClick() {
      if (textFieldsKey.currentState.validate()) {
        UserStorage.instance.user.contacts = HashSet.of({
          Contact.createTelegram(telegramFieldController.text),
        });

        dialogLoading.show();
        Api.setUser(UserStorage.instance.user)
            .then((value) => {
                  if (value.isSuccess())
                    RouterHelper.routeByUser(context, UserStorage.instance.user)
                  else
                    callSnackBar("Произошла ошибка! Попробуйте позже.")
                })
            .timeout(Duration(seconds: 15))
            .catchError(
                (Object object) => {dialogLoading.stop(), errorSnackBar()});
        dialogLoading.stop();
      }
    }

    bool onTelegramValidate(String input) {
      return input != null && input.length > 2;
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) => SingleChildScrollView(
                reverse: true,
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Мои контакты"),
                  Form(
                      key: textFieldsKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 10.0),
                            child: Text(
                              "Прежде чем продолжить, введите, пожалуйста, свой реальный Telegram-логин",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color.fromRGBO(81, 81, 81, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
                            child: TextField(
                              controller: telegramFieldController,
                              hintText: "@login",
                              labelText: "Логин Telegram",
                              validator: onTelegramValidate,
                              incorrectMessage:
                                  "Введите, пожалуйста, свой настоящий логин.",
                            ),
                          )
                        ],
                      )),
                  ButtonContinue(onPressed: _onButtonClick)
                ]))));
  }
}

class TextField extends StatelessWidget {
  static const int MinLengthName = 2;

  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final Function(String value) validator;
  final String incorrectMessage;

  TextField(
      {Key key,
      this.hintText,
      this.labelText,
      this.controller,
      this.validator,
      this.incorrectMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: this.controller,
      validator: (input) => validator(input) ? null : incorrectMessage,
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
