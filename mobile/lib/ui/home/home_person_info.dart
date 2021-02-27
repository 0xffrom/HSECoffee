import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/ui/widgets/auth_faculty_items.dart';
import 'package:hse_coffee/ui/widgets/button_continue.dart';

class HomePersonScreen extends StatefulWidget {
  static const String routeName = "/home/person";
  final User user;

  HomePersonScreen(this.user);

  @override
  _HomePersonScreen createState() => _HomePersonScreen(user);
}

class _HomePersonScreen extends State<HomePersonScreen> {
  final User user;

  _HomePersonScreen(this.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) => SingleChildScrollView(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            Api.getImageUrlByUser(UserStorage.instance.user),
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, dynamic) =>
                            new Icon(Icons.error),
                      ),
                      user.aboutMe.isEmpty ? Container() : Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 3),
                        child: Text(
                          user.getFullName(),
                          style: TextStyle(fontSize: 28, fontFamily: "Nunito"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          DataRes.getFacultyName(user.faculty) +
                              ", ${user.course} курс",
                          style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      user.aboutMe == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "О себе: ${user.aboutMe}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Nunito",
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DataCard("images/icons/tg.png", user.getTelegram()),
                            DataCard("images/icons/vk.png", user.getVk()),
                            DataCard("images/icons/inst.png", user.getInst()),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 32),
                          child: ButtonContinue(textButton: "Вернуться назад", onPressed: () => Navigator.pop(context)))
                    ],
                  ),
                )));
  }
}

class DataCard extends StatelessWidget {
  final String _text;
  final String _assetPath;
  final double sizeIco;
  final Function onTap;

  DataCard(this._assetPath, this._text, {this.sizeIco: 32.0, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (_text.isEmpty) return Container();
    return GestureDetector(
      onTap: onTap == null ? () => print("null func") : onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          child: Center(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(_assetPath,
                        width: sizeIco, height: sizeIco),
                  ),
                  Text(
                    _text,
                    textAlign: TextAlign.left,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
