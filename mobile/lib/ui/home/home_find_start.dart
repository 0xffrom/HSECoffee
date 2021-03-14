import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/data/degree.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/meet_status.dart';
import 'package:hse_coffee/data/search_params.dart';
import 'package:hse_coffee/ui/auth/header.dart';
import 'package:hse_coffee/ui/widgets/auth_faculty_items.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import 'package:smart_select/smart_select.dart';

import 'package:hse_coffee/ui/widgets/button_continue.dart';
import 'package:hse_coffee/ui/widgets/toggle_button_gender.dart';

class HomeFindScreen extends StatefulWidget {
  final Function(MeetStatus meetStatus) navigatorFunc;

  HomeFindScreen(this.navigatorFunc);

  static const String routeName = "/home/find";

  @override
  _HomeFindScreen createState() => _HomeFindScreen(navigatorFunc);
}

class _HomeFindScreen extends State<HomeFindScreen> {
  final Function(MeetStatus meetStatus) navigatorFunc;

  _HomeFindScreen(this.navigatorFunc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) => Column(
                  children: [
                    Stack(
                      children: [
                        Header(title: "Поиск собеседника"),
                      ],
                    ),
                    Expanded(
                        child: ButtonContinue(
                            textButton: "Найти встречу",
                            onPressed: () => _settingModalBottomSheet(context)))
                  ],
                )));
  }

  void _settingModalBottomSheet(context) {
    final featuresModalWidget = FeaturesModalConfirm();
    final rangeWidget = RangeWidget(_RangeWidgetState(new RangeValues(1, 6)),
        min: 1, max: 6, divisions: 5);
    final _toggleButtonWidget = ToggleButtonGender(
        buttonState: ToggleButtonGenderState([true, true]),
        onlySingleChose: false);

    SearchParams getSearchParams() {
      var genders = _toggleButtonWidget.buttonState.getGenders();
      var faculties = featuresModalWidget.state.faculties;
      var degrees = featuresModalWidget.state.degrees;

      var minCourse =
          rangeWidget.rangeWidgetState.currentRangeValues.start.toInt();
      var maxCourse =
          rangeWidget.rangeWidgetState.currentRangeValues.end.toInt();

      return SearchParams(genders.toSet(), faculties.toSet(), degrees.toSet(),
          minCourse, maxCourse);
    }

    void callSnackBar(String text, BuildContext context) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(behavior: SnackBarBehavior.floating, content: Text(text)));
    }

    void callErrorSnackBar(BuildContext context) {
      callSnackBar('Ошибка! Попробуйте повторить запрос позже.', context);
    }

    bool validate(SearchParams searchParams) {
      print(searchParams.toJson());

      if (searchParams.faculties.isEmpty ||
          searchParams.genders.isEmpty ||
          searchParams.degrees.isEmpty) return false;

      return true;
    }

    void startFind(BuildContext context) {
      var searchParams = getSearchParams();

      if (validate(searchParams)) {
        DialogLoading dialogLoading = DialogLoading(context: context);
        dialogLoading.show();
        Api.search(searchParams)
            .then((value) => {
                  dialogLoading.stop(),
                  if (value.isSuccess())
                    {navigatorFunc(value.getData())}
                  else
                    {
                      callErrorSnackBar(context),
                    }
                })
            .timeout(Duration(seconds: 10))
            .catchError(
                (obj) => {dialogLoading.stop(), callErrorSnackBar(context)});
      } else {
        callSnackBar('Пожалуйста, выберите все параметры поиска!', context);
      }
    }

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled:true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Критерии поиска",
                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(indent: 20),
                SeparatorText("Пол"),
                Padding(
                    padding: EdgeInsets.all(7.5), child: _toggleButtonWidget),
                const Divider(indent: 20),
                SeparatorText("Курс"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: rangeWidget,
                ),
                featuresModalWidget,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonContinue(
                      textButton: "Поиск",
                      onPressed: () =>
                          {Navigator.pop(context), startFind(context)}),
                )
              ],
            ),
          );
        });
  }
}

class SeparatorText extends StatelessWidget {
  final String text;

  SeparatorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontFamily: "Nunito"),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class RangeWidget extends StatefulWidget {
  final double min;
  final double max;
  final int divisions;

  final _RangeWidgetState rangeWidgetState;

  RangeWidget(this.rangeWidgetState,
      {Key key, this.min: 1, this.max: 6, this.divisions: 5})
      : super(key: key);

  @override
  _RangeWidgetState createState() => rangeWidgetState;
}

class _RangeWidgetState extends State<RangeWidget> {
  RangeValues currentRangeValues;

  _RangeWidgetState(this.currentRangeValues);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: currentRangeValues,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      labels: RangeLabels(
        currentRangeValues.start.round().toString(),
        currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          currentRangeValues = values;
        });
      },
    );
  }
}

class FeaturesModalConfirm extends StatefulWidget {
  final state = _FeaturesModalConfirmState();

  @override
  _FeaturesModalConfirmState createState() => state;
}

class _FeaturesModalConfirmState extends State<FeaturesModalConfirm> {
  var faculties = <Faculty>[];
  var degrees = <Degree>[];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SmartSelect<Faculty>.multiple(
        title: 'Образовательные программы',
        value: faculties,
        onChange: (selected) => setState(() => faculties = selected.value),
        choiceItems: DataRes.choicesFaculties,
        modalType: S2ModalType.bottomSheet,
        modalConfirm: true,
        modalValidation: (value) {
          return value.length > 0 ? null : 'Выберите образовательные программы';
        },
        modalHeaderStyle: S2ModalHeaderStyle(
          backgroundColor: Theme.of(context).cardColor,
        ),
        modalActionsBuilder: (context, state) {
          return <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: state.choiceSelector,
            )
          ];
        },
        modalDividerBuilder: (context, state) {
          return const Divider(height: 1);
        },
        modalFooterBuilder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 7.0,
            ),
            child: Row(
              children: <Widget>[
                const Spacer(),
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () => state.closeModal(confirmed: false),
                ),
                const SizedBox(width: 5),
                FlatButton(
                  child: Text('OK (${state.changes.value.length})'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: state.changes.value.isNotEmpty
                      ? () => state.closeModal(confirmed: true)
                      : null,
                ),
              ],
            ),
          );
        },
      ),
      const Divider(indent: 20),
      SmartSelect<Degree>.multiple(
        title: 'Степень образования',
        value: degrees,
        onChange: (selected) => setState(() => degrees = selected.value),
        choiceItems: DataRes.choicesDegrees,
        modalType: S2ModalType.bottomSheet,
        modalConfirm: true,
        modalValidation: (value) {
          return value.length > 0 ? null : 'Выберите степень образования';
        },
        modalHeaderStyle: S2ModalHeaderStyle(
          backgroundColor: Theme.of(context).cardColor,
        ),
        modalActionsBuilder: (context, state) {
          return <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: state.choiceSelector,
            )
          ];
        },
        modalDividerBuilder: (context, state) {
          return const Divider(height: 1);
        },
        modalFooterBuilder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 7.0,
            ),
            child: Row(
              children: <Widget>[
                const Spacer(),
                FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () => state.closeModal(confirmed: false),
                ),
                const SizedBox(width: 5),
                FlatButton(
                  child: Text('OK (${state.changes.value.length})'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: state.changes.value.isNotEmpty
                      ? () => state.closeModal(confirmed: true)
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    ]);
  }
}
