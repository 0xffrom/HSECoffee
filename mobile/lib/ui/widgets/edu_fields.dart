import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hse_coffee/data/degree.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:smart_select/smart_select.dart';

import 'auth_faculty_items.dart';

class EducationFields extends StatefulWidget {
  final state =  _EducationFieldsState();
  @override
  _EducationFieldsState createState() => state;
}

class _EducationFieldsState extends State<EducationFields> {
  Faculty faculty;
  Degree degree;


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SmartSelect<Faculty>.single(
        title: 'Образовательные программы',
        value: faculty,
        onChange: (selected) => setState(() => faculty = selected.value),
        choiceItems: DataRes.choicesFaculties,
        modalType: S2ModalType.fullPage,
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
      ),
      const Divider(indent: 20),
      SmartSelect<Degree>.single(
        title: 'Степень образования',
        value: degree,
        onChange: (selected) => setState(() => degree = selected.value),
        choiceItems: DataRes.choicesDegrees,
        modalType: S2ModalType.fullPage,
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
      ),
    ]);
  }
}
