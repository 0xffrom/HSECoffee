import 'package:flutter/cupertino.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class ButtonContinue extends StatelessWidget {
  String textButton = "Продолжить";
  ButtonContinue({Key key, this.onPressed}) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      child: Text(textButton, style: TextStyle(fontSize: 16.0)),
      callback: () {
        onPressed();
      },
      increaseWidthBy: 150.0,
      increaseHeightBy: 10,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(0, 82, 212, 1),
            Color.fromRGBO(49, 94, 252, 1),
            Color.fromRGBO(111, 177, 252, 1)
          ]),
      shadowColor:
      Gradients.backToFuture.colors.last.withOpacity(0.25),
    );
  }
}
