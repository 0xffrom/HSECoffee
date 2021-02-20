import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/degree.dart';
import '../widgets/circular_drop_down.dart';
import 'header.dart';

import 'package:hse_coffee/ui/widgets/button_continue.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import '../../router_auth.dart';
import '../widgets/auth_faculty_items.dart';

class AuthFacultyScreen extends StatefulWidget {
  static const String routeName = "/ui/auth/faculty";

  @override
  _AuthFacultyScreen createState() => _AuthFacultyScreen();
}

class _AuthFacultyScreen extends State<AuthFacultyScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  final _facultyDropDown = DropDown<DropDownState<Faculty>>(
      state: DropDownState<Faculty>(
          hint: "Моя образовательная программа",
          value: Faculty.NONE,
          items: DataRes.faculties));

  final _degreeDropDown = DropDown<DropDownState<Degree>>(
      state: DropDownState<Degree>(
          hint: "Академическая степень",
          value: Degree.NONE,
          items: DataRes.degrees));

  final _slider = SliderCourse(state: SliderState(currentSliderValue: 1.0));

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

    void _onButtonClick() {
      Faculty currentFaculty = _facultyDropDown.state.value;
      Degree currentDegree = _degreeDropDown.state.value;
      double course = _slider.state.currentSliderValue;

      if (currentFaculty == Faculty.NONE) {
        callSnackBar("Пожалуйста, выберите свою образовательную программу!");
      } else if (currentDegree == Degree.NONE) {
        callSnackBar("Пожалуйста, выберите акадимическую степень!");
      } else {
        UserStorage.instance.user.faculty = currentFaculty;
        UserStorage.instance.user.degree = currentDegree;
        UserStorage.instance.user.course = course.toInt();

        dialogLoading.show();

        Api.setUser(UserStorage.instance.user).then((value) => {
              if (value.isSuccess())
                RouterHelper.routeByUser(context, UserStorage.instance.user)
              else
                callSnackBar("Произошла ошибка! Попробуйте позже.")
            });

        dialogLoading.stop();
        return;
      }
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) => SingleChildScrollView(
                reverse: true,
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(title: "Образовательная\nпрограмма"),
                  Padding(
                    padding: EdgeInsets.fromLTRB(45.0, 30.0, 45.0, 10.0),
                    child: _facultyDropDown,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 0),
                    child: _degreeDropDown,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Text("Курс: "), _slider],
                    ),
                  ),
                  ButtonContinue(onPressed: _onButtonClick)
                ]))));
  }
}

class DropDown<T extends State<StatefulWidget>> extends StatefulWidget {
  final T state;

  DropDown({@required this.state});

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class DropDownState<T> extends State<DropDown> {
  T value;
  String hint;
  List<DropdownMenuItem<T>> items;

  DropDownState(
      {@required this.value, @required this.hint, @required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircularDropDownMenu(
          dropDownMenuItem: items,
          onChanged: (value) {
            setState(() {
              this.value = value;
              this.hint = ((items
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

class SliderCourse extends StatefulWidget {
  final SliderState state;

  SliderCourse({this.state, Key key}) : super(key: key);

  @override
  SliderState createState() => state;
}

class SliderState extends State<SliderCourse> {
  bool isInit = false;
  double currentSliderValue = 1;

  SliderState({this.currentSliderValue});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: currentSliderValue,
      min: 1,
      max: 6,
      divisions: 5,
      label: currentSliderValue.round().toString() + " курс",
      onChanged: (double value) {
        isInit = true;
        setState(() {
          currentSliderValue = value;
        });
      },
    );
  }
}
