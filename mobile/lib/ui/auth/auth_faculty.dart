import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/degree.dart';
import 'package:hse_coffee/ui/widgets/edu_fields.dart';
import 'header.dart';

import 'package:hse_coffee/ui/widgets/button_continue.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import '../../router_auth.dart';

class AuthFacultyScreen extends StatefulWidget {
  static const String routeName = "/ui/auth/faculty";

  @override
  _AuthFacultyScreen createState() => _AuthFacultyScreen();
}

class _AuthFacultyScreen extends State<AuthFacultyScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

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
    EducationFields _educationFields = EducationFields();

    final dialogLoading = DialogLoading(context: this.context);
    void callSnackBar(String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    void errorSnackBar() {
      callSnackBar('Ошибка! Попробуйте повторить запрос позже.');
    }

    void _onButtonClick() {
      Faculty currentFaculty = _educationFields.state.faculty;
      Degree currentDegree = _educationFields.state.degree;
      double course = _slider.state.currentSliderValue;

      if (currentFaculty == null || currentFaculty == Faculty.NONE) {
        callSnackBar("Пожалуйста, выберите свою образовательную программу!");
      } else if (currentDegree == null || currentDegree == Degree.NONE) {
        callSnackBar("Пожалуйста, выберите акадимическую степень!");
      } else {
        UserStorage.instance.user.faculty = currentFaculty;
        UserStorage.instance.user.degree = currentDegree;
        UserStorage.instance.user.course = course.toInt();

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
                    padding: const EdgeInsets.all(8.0),
                    child: _educationFields,
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
