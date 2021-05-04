import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/ui/widgets/auth_faculty_items.dart';
import 'package:hse_coffee/ui/widgets/button_continue.dart';

class HomePersonScreen extends StatefulWidget {
  final bool withBack;

  static const String routeName = "/home/person";
  final User user;

  HomePersonScreen(this.user, {this.withBack: true});

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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        child: CachedNetworkImage(
                          alignment: Alignment.bottomLeft,
                          fit: BoxFit.cover,
                          imageUrl: Api.getImageUrlByUser(user),
                          errorWidget: (context, url, dynamic) =>
                              new Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 12, left: 12, bottom: 0),
                        child: Text(
                          user.getFullName(),
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          DataRes.getFacultyName(user.faculty) +
                              ", ${user.course} курс",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      user.aboutMe.isEmpty
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "\"${user.aboutMe.replaceAll("\n\n", "\n")}\"",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Nunito",
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      const Divider(height: 24, thickness: 2),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DataCard("images/icons/tg.png", user.getTelegram()),
                            DataCard("images/icons/vk.png", user.getVk()),
                            DataCard("images/icons/inst.png", user.getInst()),
                          ],
                        ),
                      ),
                      widget.withBack
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 32),
                              child: ButtonContinue(
                                  textButton: "Вернуться назад",
                                  onPressed: () => Navigator.pop(context)))
                          : Container()
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
