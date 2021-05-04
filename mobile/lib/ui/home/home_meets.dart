import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/meet.dart';
import 'package:hse_coffee/ui/auth/header.dart';

import 'home_person_info.dart';

class HomeMeetsScreen extends StatefulWidget {
  static const String routeName = "/home/meets";

  @override
  _HomeMeetsScreen createState() => _HomeMeetsScreen();
}

class _HomeMeetsScreen extends State<HomeMeetsScreen> {
  List<Meet> _meets;

  @override
  void initState() {
    super.initState();

    loadMeets();
  }

  void loadMeets() {
    Api.getMeets().then((value) => {
          if (value.isSuccess()) {_meets = value.getData(), setState(() {})}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Column(mainAxisSize: MainAxisSize.max, children: [
        Header(title: "История встреч"),
        if (_meets == null)
          Center(child: CircularProgressIndicator())
        else if (_meets.isNotEmpty)
          SingleChildScrollView(
              child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            crossAxisCount: 2,
            children: List.generate(_meets.length, (index) {
              return Center(child: MeetCard(_meets[index]));
            }),
          ))
        else
          Expanded(
            child: Center(
              child: Text(
                "У Вас ещё не было встреч.\n"
                " Самое время начать поиск!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.0, fontFamily: "Nunito"),
              ),
            ),
          ),
      ]),
    ));
  }
}

class MeetCard extends StatelessWidget {
  final Meet meet;

  MeetCard(this.meet, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user =
        UserStorage().user.email == meet.user1.email ? meet.user2 : meet.user1;
    var date = meet.createdDate.toLocal();

    void onTap() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePersonScreen(user)),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              ),
            ],
          ),
          child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 110,
                    child: CachedNetworkImage(
                        imageUrl: Api.getImageUrlByUser(user),
                        fit: BoxFit.cover),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 2, bottom: 1, right: 12, left: 12),
                      child: Center(
                          child: Text(
                        user.firstName + " " + user.lastName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Nunito"),
                      ))),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Icon(
                                Icons.person,
                                color: Colors.blueAccent,
                                size: 12,
                              )),
                          Text(
                            "${date.day}.${date.month.toString().length == 1 ? "0" + date.month.toString() : date.month}.${date.year}",
                            style: TextStyle(fontSize: 10.0),
                          )
                        ],
                      ))
                ],
              ))),
    );
  }
}
