import 'package:flutter/material.dart';

class DialogLoading {
  static const String _Default_Text = "Загружаю...";
  final BuildContext context;
  final String text;

  DialogLoading({@required this.context, this.text});

  void show() {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(strokeWidth: 3.0),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(text == null ? _Default_Text : text)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void stop() {
    Navigator.pop(context);
  }
}
