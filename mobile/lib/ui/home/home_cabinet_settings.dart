import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/contact.dart';
import 'package:hse_coffee/data/gender.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/ui/auth/auth_faculty.dart';
import 'package:hse_coffee/ui/widgets/CapsuleWidget.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import 'package:hse_coffee/ui/widgets/edu_fields.dart';
import 'package:hse_coffee/ui/widgets/text_field_wrapper.dart';
import 'package:hse_coffee/ui/widgets/toggle_button_gender.dart';

class Settings extends StatelessWidget {
  final nameKey = GlobalKey<FormState>();

  Function floatingButtonPress;
  TextEditingController _firstNameFieldController;
  TextEditingController _aboutFieldController;
  TextEditingController _lastNameFieldController;
  TextEditingController _vkFieldController;
  TextEditingController _tgFieldController;
  TextEditingController _instFieldController;

  EducationFields _educationFields = EducationFields();

  SliderCourse _slider;
  ToggleButtonGender _toggleButton;

  final User _currentUser;

  Settings(this._currentUser) {
    // Init elements by user instance
    _slider = SliderCourse(
        state: SliderState(currentSliderValue: _currentUser.course.toDouble()));

    _educationFields.state.degree = _currentUser.degree;
    _educationFields.state.faculty = _currentUser.faculty;

    _tgFieldController =
        TextEditingController(text: _currentUser.getTelegram());
    _vkFieldController = TextEditingController(text: _currentUser.getVk());
    _instFieldController = TextEditingController(text: _currentUser.getInst());

    _lastNameFieldController =
        TextEditingController(text: _currentUser.lastName);

    _firstNameFieldController =
        TextEditingController(text: _currentUser.firstName);

    _aboutFieldController = TextEditingController(text: _currentUser.aboutMe);

    var male = _currentUser.gender == Gender.MALE;
    var female = _currentUser.gender == Gender.FEMALE;

    _toggleButton = ToggleButtonGender(
        buttonState: ToggleButtonGenderState(List.of({male, female})));
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
      Form(
          key: nameKey,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(7.5),
                  child: CapsuleWidget(
                    label: 'О себе'.toUpperCase(),
                    ribbonHeight: 12,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: TextFieldWrapper(
                  textInputType: TextInputType.multiline,
                  controller: _aboutFieldController,
                  hintText: "Укажите информацию о себе",
                  labelText: "Мои хобби, интересы, увлечения",
                  maxLines: 4,
                  minLengthName: -1,
                  maxLengthName: 100,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(7.5),
                  child: CapsuleWidget(
                    label: 'Мои данные'.toUpperCase(),
                    ribbonHeight: 12,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: TextFieldWrapper(
                  controller: _firstNameFieldController,
                  hintText: "Введите своё имя",
                  labelText: "Имя",
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
                child: TextFieldWrapper(
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
                    child: TextFieldWrapper(
                        controller: _tgFieldController,
                        hintText: "Введите свой Telegram-логин",
                        iconPath: "images/icons/tg.png",
                        labelText: "Telegram"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 7.0, 30.0, 0.0),
                    child: TextFieldWrapper(
                        controller: _vkFieldController,
                        ignoreValidate: true,
                        hintText: "Введите свой VK-логин",
                        labelText: "VK",
                        iconPath: "images/icons/vk.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 7.0, 30.0, 0.0),
                    child: TextFieldWrapper(
                        controller: _instFieldController,
                        ignoreValidate: true,
                        hintText: "Введите свой Instagram",
                        iconPath: "images/icons/inst.png",
                        labelText: "Instagram"),
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
      _educationFields,
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
    newUser.aboutMe = _aboutFieldController.text;

    newUser.contacts = Set.of({
      Contact.createVk(_vkFieldController.text),
      Contact.createInstagram(_instFieldController.text),
      Contact.createTelegram(_tgFieldController.text)
    });

    List<bool> isSelected = _toggleButton.buttonState.isSelected;
    if (isSelected.length == 2) {
      isSelected[0]
          ? newUser.gender = Gender.MALE
          : newUser.gender = Gender.FEMALE;
    } else {
      newUser.gender = Gender.NONE;
    }

    newUser.degree = _educationFields.state.degree;
    newUser.faculty = _educationFields.state.faculty;
    newUser.course = _slider.state.currentSliderValue.toInt();
    return newUser;
  }
}
