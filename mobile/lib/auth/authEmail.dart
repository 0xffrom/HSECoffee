import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hse_coffee/auth/authCode.dart';
import 'package:hse_coffee/auth/header.dart';
import 'package:hse_coffee/business_logic/Api.dart';
import 'package:hse_coffee/widgets/ButtonContinue.dart';

class AuthEmailScreen extends StatefulWidget {
  static const String routeName = "/auth/email";

  @override
  _AuthEmailScreen createState() => _AuthEmailScreen();
}

class _AuthEmailScreen extends State<AuthEmailScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  final textFieldKey = GlobalKey<FormState>();

  List<String> emails;
  bool _block;
  DateTime _blockTime;
  String email;
  int count;

  @override
  void initState() {
    _block = false;
    count = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _nextPage() {
      Navigator.of(context).pushNamed(AuthCodeScreen.routeName,
          arguments: ScreenAuthCodeArguments(email));
    }

    final errorSnackBar =
        SnackBar(content: Text('Ошибка! Попробуйте повторить запрос позже.'));

    void onError(Object error) {
      count--;
      globalKey.currentState.showSnackBar(errorSnackBar);
    }

    void _onPressed() {
      if (_block) {
        if (DateTime.now().isAfter(_blockTime)) {
          _block = false;
        } else {
          Duration ostDate = _blockTime.difference(DateTime.now());
          globalKey.currentState.showSnackBar(SnackBar(
              content: Text(
                  "Не спешите! Подождите ${ostDate.inMinutes} минут(ы) и ${ostDate.inSeconds % 60} секунд(ы).")));
          return;
        }
      }

      if (textFieldKey.currentState.validate()) {
        if (count >= 2) {
          _blockTime = DateTime.now().add(Duration(minutes: 5));
          _block = true;
          count = 0;
        }

        count++;

        Api.sendCode(email)
            .then((value) => {
                  if (value.statusCode == 200)
                    {_nextPage()}
                  else
                    {
                      --count,
                      emails.clear(),
                      globalKey.currentState.showSnackBar(
                          SnackBar(content: Text("Ошибка: ${value.message}")))
                    }
                })
            .catchError(onError);
      }
    }

    bool _isValidEmailForm(String email) {
      if (email == null || email.trim().length < 4) {
        return false;
      }

      return (email.endsWith("@edu.hse.ru") || email.endsWith("@hse.ru"));
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) =>
                Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Моя почта"),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                    child: Form(
                        key: textFieldKey,
                        child: TextFormField(
                          cursorColor: Colors.blueAccent,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'Введите свою корпоративную почту',
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
                            labelText: 'Моя почта',
                          ),
                          validator: (input) => _isValidEmailForm(input)
                              ? null
                              : "Не забудьте @hse.ru или @edu.hse.ru",
                          onChanged: (String value) {
                            email = value;
                          },
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                        "Введите свой корпоративный почтовый ящик, на который придёт письмо с кодом подтверждения.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromRGBO(81, 81, 81, 1),
                        )),
                  ),
                  ButtonContinue(onPressed: _onPressed),
                ])));
  }
}
