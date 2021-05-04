import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CapsuleWidget extends StatelessWidget {
  final Color fillColor;
  final Color textColor;
  final String label;
  final double ribbonHeight;
  final double ribbonRadius;

  const CapsuleWidget({
    Key key,
    this.fillColor = Colors.white24,
    this.textColor = Colors.black,
    @required this.label,
    @required this.ribbonHeight,
    this.ribbonRadius = 1000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: ribbonHeight,
            color: fillColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(ribbonRadius)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: ribbonHeight,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}
