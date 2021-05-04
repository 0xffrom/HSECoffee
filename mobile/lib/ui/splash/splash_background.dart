import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Color.fromRGBO(60, 106, 252, 1);
    canvas.drawPath(mainBackground, paint);
    mainBackground.close();

    var path = Path();

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.5, height * 0.5), radius: height * 0.2));

    paint.color = Color.fromRGBO(112, 144, 253, 100);
    canvas.drawPath(path, paint);

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.1, height), radius: height * 0.2));

    path.addOval(Rect.fromCircle(
        center: Offset(width - width * 0.1, height * 0.8),
        radius: height * 0.3));

    paint.color = Color.fromRGBO(255, 255, 255, 0.2);
    canvas.drawPath(path, paint);

    path.close();

    var parabola = Path();
    parabola.addOval(Rect.fromCircle(
        center: Offset(width * 0.4, -height * 0.3), radius: height * 0.75));

    paint.color = Colors.white;
    canvas.drawPath(parabola, paint);
    parabola.close();
  }

  void drawRandomOvals(
      Canvas canvas, Paint paint, int n, double width, double height) {
    paint.color = Colors.blueAccent;

    for (int i = 0; i < n; i++) {
      var oval = Path();
      oval.addOval(Rect.fromCircle(
          center: Offset(
              width * Random().nextDouble(), height * Random().nextDouble()),
          radius: height * Random().nextDouble() / 15));
      canvas.drawPath(oval, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
