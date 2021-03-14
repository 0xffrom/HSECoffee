import 'package:flutter/cupertino.dart';
import 'package:hse_coffee/data/gender.dart';
import 'package:hse_coffee/ui/auth/auth_gender.dart';

class ToggleButtonGender extends StatefulWidget {
  final bool onlySingleChose;
  final ToggleButtonGenderState buttonState;
  final Function onPressed;

  ToggleButtonGender(
      {Key key, this.onPressed, this.buttonState, this.onlySingleChose: true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return buttonState;
  }
}

class ToggleButtonGenderState extends State<ToggleButtonGender> {
  var isSelected = <bool>[false, false];
  static const String FirstButtonText = "Мужской";
  static const String SecondButtonText = "Женский";

  List<Gender> getGenders(){
    List<Gender> genders = List.of({}, growable: true);
    if(isSelected.length >= 1){
      if(isSelected[0]){
        genders.add(Gender.MALE);
      }
      if(isSelected.length >= 2 && isSelected[1]){
        genders.add(Gender.FEMALE);
      }
    }

    return genders;
  }

  ToggleButtonGenderState(this.isSelected);

  void onClicked(int index) {
    if (!widget.onlySingleChose) {
      isSelected[index] = !isSelected[index];

      bool allOff = true;
      for (int i = 0; i < isSelected.length; i++) {
        if (isSelected[i]) {
          allOff = false;
          break;
        }
      }

      if(allOff){
        isSelected[index] = !isSelected[index];
        return;
      }
    } else {
      if (isSelected[index]) return;

      bool state = isSelected[index];
      isSelected[index] = !state;
      for (int i = 0; i < isSelected.length; i++) {
        if (i != index) {
          isSelected[i] = state;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TButton(
              FirstButtonText,
              () => onClicked(0),
              isClicked: isSelected[0],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TButton(
              SecondButtonText,
              () => onClicked(1),
              isClicked: isSelected[1],
            ),
          ),
        ]));
  }
}
