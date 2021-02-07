import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/router_auth.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/widgets/button_continue.dart';
import 'header.dart';

import 'package:hse_coffee/widgets/dialog_loading.dart';

class AuthCodeScreen extends StatefulWidget {
  static const String routeName = "/auth/code";

  @override
  _AuthCodeScreen createState() => _AuthCodeScreen();
}

class _AuthCodeScreen extends State<AuthCodeScreen> {
  int count;
  bool _block;
  DateTime _blockTime;

  final globalKey = GlobalKey<ScaffoldState>();
  final textFieldKey = GlobalKey<FormState>();
  AnimationController rotationController;

  @override
  void initState() {
    count = 0;
    _block = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dialogLoading = DialogLoading(context: this.context);

    String code;
    final ScreenAuthCodeArguments args =
        ModalRoute.of(context).settings.arguments;

    void callSnackBar(String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    void errorSnackBar() {
      callSnackBar('Ошибка! Попробуйте повторить запрос позже.');
    }

    void _onRetry() {
      if (count >= 1) {
        _blockTime = DateTime.now().add(Duration(minutes: 3));
        _block = true;
        count = 0;
      }

      if (_block) {
        if (DateTime.now().isAfter(_blockTime)) {
          _block = false;
        } else {
          Duration ostDate = _blockTime.difference(DateTime.now());
          globalKey.currentState.showSnackBar(SnackBar(
              content: Text(
                  "Не спешите! Подождите ${ostDate.inMinutes} минут(ы) и ${ostDate.inSeconds % 60} секунд(ы).")));
        }
        return;
      }

      count++;
      dialogLoading.show();
      Api.sendCode(args.email)
          .then((value) => {
                dialogLoading.stop(),
                if (value.statusCode == 200)
                  {callSnackBar("Код был успешно выслан на почту повторно!")}
                else
                  {
                    count--,
                    errorSnackBar(),
                  }
              })
          .catchError((Object object) =>
              {count--, dialogLoading.stop(), errorSnackBar()});
    }

    Future<void> _onPressed() async {
      if (textFieldKey.currentState.validate()) {
        dialogLoading.show();
        Api.confirmCode(code, args.email)
            .then((value) => {
                  dialogLoading.stop(),
                  if (value.isSuccess())
                    {
                      Api.getUser().then((value) => {
                            UserStorage.instance.user = value.getData(),
                            RouterHelper.routeByUser(context, value.getData())
                          })
                    }
                  else
                    {
                      callSnackBar(
                          "К сожалению, код неверный или произошла ошибка.")
                    }
                })
            .catchError(
                (Object object) => {dialogLoading.stop(), errorSnackBar()});
      }
    }

    bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

    bool _isValidCodeForm(String code) {
      if (code == null || code.isEmpty) {
        return false;
      }

      if (code.length != 6) return false;

      for (int i = 0; i < code.length; i++) {
        if (!isDigit(code, i)) {
          return false;
        }
      }

      return true;
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) => SingleChildScrollView(
                reverse: true,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                      Header(title: "Код"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                        child: Form(
                            key: textFieldKey,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.blueAccent,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: _onRetry,
                                  icon: Icon(Icons.refresh),
                                ),
                                hintText: 'Введите код письма',
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
                                labelText: 'Код',
                              ),
                              validator: (input) => _isValidCodeForm(input)
                                  ? null
                                  : "Код состоит только из 6-ти цифр.",
                              onChanged: (String value) {
                                code = value;
                              },
                              onEditingComplete: _onPressed,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                            "Введите код, который пришёл на Ваш почтовый ящик ${args.email}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(81, 81, 81, 1),
                            )),
                      ),
                      ButtonContinue(onPressed: _onPressed)
                    ]))));
  }
}

class ScreenAuthCodeArguments {
  final String email;

  ScreenAuthCodeArguments(this.email);
}
