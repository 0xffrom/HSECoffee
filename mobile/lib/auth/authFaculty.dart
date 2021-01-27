import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/Api.dart';
import 'package:hse_coffee/business_logic/UserStorage.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/widgets/button_continue.dart';
import '../RouterHelper.dart';
import '../widgets/circular_drop_down.dart';
import 'header.dart';
import '../widgets/auth_faculty_items.dart';

class AuthFacultyScreen extends StatefulWidget {
  static const String routeName = "/auth/faculty";

  @override
  _AuthFacultyScreen createState() => _AuthFacultyScreen();
}

class _AuthFacultyScreen extends State<AuthFacultyScreen> {
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
    final _dropDown = _DropDown();

    bool _validate(Faculty faculty){
      return faculty != Faculty.NONE;
    }

    void _onButtonClick() {
      Faculty currentFaculty = _dropDown.state.value;
      if (_validate(currentFaculty)) {
        UserStorage.instance.user.faculty = currentFaculty;

        Api.setUser(UserStorage.instance.user).then((value) => {
              if (value.isSuccess())
                RouterHelper.routeByUser(context, UserStorage.instance.user)
              else
                callSnackBar("Произошла ошибка! Попробуйте позже.")
            });

        return;
      }
      else{
        callSnackBar("Пожалуйста, выберите свою образовательную программу!");
      }
    }



    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) =>
                Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Образовательная\nпрограмма"),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(45.0, 30.0, 45.0, 10.0),
                        child: _dropDown,
                      )
                    ],
                  ),
                  ButtonContinue(onPressed: _onButtonClick)
                ])));
  }
}

class _DropDown extends StatefulWidget {
  final state = _DropDownState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _DropDownState extends State<_DropDown> {
  Faculty value = Faculty.NONE;
  String hint = "Моя образовательная программа";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircularDropDownMenu(
          dropDownMenuItem: FacultyItems.items,
          onChanged: (value) {
            setState(() {
              this.value = value;
              this.hint = ((FacultyItems.items
                          .firstWhere((element) => element.value == value)
                          .child as GestureDetector)
                      .child as Text)
                  .data;
            });
          },
          hintText: hint,
        ),
      ],
    );
  }
}
