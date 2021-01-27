import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset("images/header/cloud.png"),
        Transform.rotate(
            angle: 0,
            child: Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(30, 51, 123, 0.5),
                    borderRadius: BorderRadius.circular(50)),
                child: SizedBox(height: 175, width: 175))),
        Transform.rotate(
            angle: 90,
            child: Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(30, 51, 123, 0.5),
                    borderRadius: BorderRadius.circular(50)),
                child: SizedBox(height: 125, width: 125))),
        Transform.rotate(
            angle: 90,
            child: Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(30, 51, 123, 0.5),
                    borderRadius: BorderRadius.circular(50)),
                child: SizedBox(height: 75, width: 75))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
