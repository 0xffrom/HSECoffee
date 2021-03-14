import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/data/meet_status.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeLoadingScreen extends StatefulWidget {
  final bool withCancel;
  final Function(MeetStatus meetStatus) navigatorFunc;

  static const String routeName = "/home/loading";

  // TODO: false
  HomeLoadingScreen({this.withCancel: false, this.navigatorFunc});

  @override
  _HomeLoadingScreen createState() => _HomeLoadingScreen(withCancel, navigatorFunc);
}

class _HomeLoadingScreen extends State<HomeLoadingScreen> {
  final bool withCancel;
  final Function(MeetStatus meetStatus) navigatorFunc;

  _HomeLoadingScreen(this.withCancel, this.navigatorFunc);

  void callSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(text)));
  }

  void callErrorSnackBar(BuildContext context) {
    callSnackBar('Ошибка! Попробуйте повторить запрос позже.', context);
  }

  @override
  void initState() {
    super.initState();
  }

  _cancelMeet(){
    if(withCancel){
      var dialogLoading = DialogLoading(context: context);
      dialogLoading.show();
      Api.cancelSearch()
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: withCancel ? FloatingActionButton(
          onPressed: _cancelMeet,
          child: Icon(Icons.cancel),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
        ) : null,
        backgroundColor: Color.fromRGBO(67, 100, 248, 0.98),
        body: CustomPaint(
            painter: Painter(),
            child: Center(
              child: Stack(children: [
                Center(
                  child: Image.asset(
                    "images/bird_with_coffee.png",
                    scale: 4,
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width / 2 - 43,
                  bottom: MediaQuery.of(context).size.height / 2 - 130,
                  child: JumpingDotsProgressIndicator(
                    color: Colors.white,
                    numberOfDots: 5,
                    fontSize: 36.0,
                  ),
                ),
              ]),
            )));
  }
}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    Paint paint = Paint();
    var path = Path();

    paint.color = Color.fromRGBO(255, 255, 255, 1.0);

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.25, height * 0.1), radius: height * 0.2));

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.9, height * 0.9), radius: height * 0.3));

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.9, height * 0.9), radius: height * 0.25));

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.9, height * 0.9), radius: height * 0.2));

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.05, height * 0.6), radius: height * 0.16));

    path.addOval(Rect.fromCircle(
        center: Offset(width * 0.95, height * 0.3), radius: height * 0.15));

    canvas.drawPath(path, paint);
    path.close();

    var path2 = Path();
    paint.color = Color.fromRGBO(67, 100, 248, 0.98);

    path2.addOval(Rect.fromCircle(
        center: Offset(width * 0.95, height * 0.95), radius: height * 0.16));
    canvas.drawPath(path2, paint);

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
