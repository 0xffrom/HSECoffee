// ignore: must_be_immutable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/contact.dart';
import 'package:hse_coffee/data/degree.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/gender.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/ui/auth/auth_faculty.dart';
import 'package:hse_coffee/ui/auth/auth_gender.dart';
import 'package:hse_coffee/ui/widgets/CapsuleWidget.dart';
import 'package:hse_coffee/ui/widgets/auth_faculty_items.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';

class Settings extends StatelessWidget {
  final nameKey = GlobalKey<FormState>();

  Function floatingButtonPress;
  TextEditingController _firstNameFieldController;
  TextEditingController _lastNameFieldController;
  TextEditingController _vkFieldController;
  TextEditingController _tgFieldController;
  DropDown<DropDownState<Faculty>> _facultyDropDown;
  DropDown<DropDownState<Degree>> _degreeDropDown;
  SliderCourse _slider;
  _ToggleButton _toggleButton;

  final User _currentUser;

  Settings(this._currentUser) {
    // Init elements by user instance
    _slider = SliderCourse(
        state: SliderState(currentSliderValue: _currentUser.course.toDouble()));

    _degreeDropDown = DropDown<DropDownState<Degree>>(
        state: DropDownState<Degree>(
            hint: ((DataRes.degrees
                .firstWhere(
                    (element) => element.value == _currentUser.degree)
                .child as GestureDetector)
                .child as Text)
                .data,
            value: _currentUser.degree,
            items: DataRes.degrees));

    _facultyDropDown = DropDown<DropDownState<Faculty>>(
        state: DropDownState<Faculty>(
            hint: ((DataRes.faculties
                .firstWhere(
                    (element) => element.value == _currentUser.faculty)
                .child as GestureDetector)
                .child as Text)
                .data,
            value: _currentUser.faculty,
            items: DataRes.faculties));

    if (_currentUser.contacts.map((e) => e.name).contains("tg")) {
      _tgFieldController = TextEditingController(
          text: _currentUser.contacts
              .firstWhere((element) => element.name == "tg")
              .value);
    }

    if (_currentUser.contacts.map((e) => e.name).contains("vk")) {
      _vkFieldController = TextEditingController(
          text: _currentUser.contacts
              .firstWhere((element) => element.name == "vk")
              .value);
    }

    _lastNameFieldController =
        TextEditingController(text: _currentUser.lastName);

    _firstNameFieldController =
        TextEditingController(text: _currentUser.firstName);

    var male = _currentUser.gender == Gender.MALE;
    var female = _currentUser.gender == Gender.FEMALE;

    _toggleButton =
        _ToggleButton(buttonState: _ToggleButtonState(List.of({male, female})));
  }

  @override
  Widget build(BuildContext context) {
    void callSnackBar(String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    void callErrorSnackBar() {
      callSnackBar('Ошибка! Попробуйте повторить запрос позже.');
    }

    bool isContinue = true;

    void _onPressed() {
      if (!isContinue) {
        callSnackBar("Не спешите!");
        return;
      }

      isContinue = false;
      Timer(Duration(seconds: 3), () {
        isContinue = true;
      });

      if (nameKey.currentState.validate()) {
        User newUser = getUserByUi();

        DialogLoading dialogLoading = DialogLoading(context: context);

        dialogLoading.show();
        Api.setUser(newUser)
            .then((value) => {
          dialogLoading.stop(),
          if (value.isSuccess())
            UserStorage.instance.user = newUser
          else
            callErrorSnackBar()
        })
            .catchError(
                (object) => {callErrorSnackBar(), dialogLoading.stop()});
      }
    }

    floatingButtonPress = _onPressed;

    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(7.5),
          child: CapsuleWidget(
            label: 'Мои данные'.toUpperCase(),
            ribbonHeight: 12,
          )),
      Form(
          key: nameKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: TextField(
                  controller: _firstNameFieldController,
                  hintText: "Введите своё имя",
                  labelText: "Имя",
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
                child: TextField(
                    controller: _lastNameFieldController,
                    hintText: "Введите свою фамилию",
                    labelText: "Фамилия"),
              ),
              Padding(padding: EdgeInsets.all(7.5), child: _toggleButton),
              Padding(
                  padding: EdgeInsets.all(7.5),
                  child: CapsuleWidget(
                    label: 'Мои контакты'.toUpperCase(),
                    ribbonHeight: 12,
                  )),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: TextField(
                      controller: _vkFieldController,
                      hintText: "Введите свой VK-логин",
                      labelText: "VK",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 7.0, 30.0, 0.0),
                    child: TextField(
                        controller: _tgFieldController,
                        hintText: "Введите свой Telegram-логин",
                        labelText: "Telegram"),
                  )
                ],
              ),
            ],
          )),
      Padding(
          padding: EdgeInsets.all(7.5),
          child: CapsuleWidget(
            label: 'Обучение'.toUpperCase(),
            ribbonHeight: 12,
          )),
      Padding(
        padding: EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 0.0),
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
    ]);
  }

  User getUserByUi() {
    User newUser = UserStorage.instance.user;

    newUser.firstName = _firstNameFieldController.text;
    newUser.lastName = _lastNameFieldController.text;
    newUser.contacts = Set.of({
      Contact("vk", _vkFieldController.text),
      Contact("tg", _tgFieldController.text)
    });

    List<bool> isSelected = _toggleButton.buttonState.isSelected;
    if (isSelected.length == 2) {
      isSelected[0]
          ? newUser.gender = Gender.MALE
          : newUser.gender = Gender.FEMALE;
    } else {
      newUser.gender = Gender.NONE;
    }

    newUser.degree = _degreeDropDown.state.value;
    newUser.faculty = _facultyDropDown.state.value;
    newUser.course = _slider.state.currentSliderValue.toInt();
    return newUser;
  }
}

class _ToggleButton extends StatefulWidget {
  final _ToggleButtonState buttonState;
  final Function onPressed;

  _ToggleButton({Key key, this.onPressed, this.buttonState}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return buttonState;
  }
}

class _ToggleButtonState extends State {
  var isSelected = <bool>[false, false];
  static const String FirstButtonText = "Мужской";
  static const String SecondButtonText = "Женский";

  _ToggleButtonState(this.isSelected);

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
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TButton(
                FirstButtonText,
                    () => onClicked(0),
                isClicked: isSelected[0],
              ),
              TButton(
                SecondButtonText,
                    () => onClicked(1),
                isClicked: isSelected[1],
              ),
            ]));
  }
}

class TextField extends StatelessWidget {
  static const int MinLengthName = 2;
  static const int MaxLengthName = 15;

  final String hintText;
  final String labelText;
  final TextEditingController controller;

  TextField({Key key, this.hintText, this.labelText, this.controller})
      : super(key: key);

  bool _isValidName(String text) {
    return text != null &&
        text.length > MinLengthName &&
        text.length < MaxLengthName;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: this.controller,
      validator: (input) =>
      _isValidName(input) ? null : "Пожалуйста, заполните корректно поле!",
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 2,
            color: Colors.blue,
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
