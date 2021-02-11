import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';

class HomeCabinetScreen extends StatefulWidget {
  static const String routeName = "/home/lk";

  @override
  _HomeCabinetScreen createState() => _HomeCabinetScreen();
}

class _HomeCabinetScreen extends State<HomeCabinetScreen> {
  int count;

  final globalKey = GlobalKey<ScaffoldState>();
  final textFieldKey = GlobalKey<FormState>();
  AnimationController rotationController;

  @override
  void initState() {
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

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) => SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DecoratedBox(
                        // add this
                        child: new Column(
                          children: <Widget>[
                            new Container(
                                margin: EdgeInsets.only(top: 30, bottom: 15),
                                width: 190.0,
                                height: 190.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            Api.getImageByUser(
                                                UserStorage.instance.user))))),
                            new Text(
                              UserStorage.instance.user.firstName +
                                  " " +
                                  UserStorage.instance.user.lastName,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: new Text(
                                  UserStorage.instance.user.email,
                                  style: new TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(45),
                                bottomRight: Radius.circular(45)),
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color.fromRGBO(0, 82, 212, 1),
                                  Color.fromRGBO(49, 94, 252, 1),
                                  Color.fromRGBO(111, 177, 252, 1)
                                ])),
                      ),
                    ],
                  ),
                )));
  }
}

class ScreenAuthCodeArguments {
  final String email;

  ScreenAuthCodeArguments(this.email);
}
