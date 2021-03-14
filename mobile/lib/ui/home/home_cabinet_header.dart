import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:hse_coffee/ui/widgets/dialog_loading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HeaderState extends State<Header> {
  User currentUser;

  HeaderState({this.currentUser});

  void callSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void callErrorSnackBar() {
    callSnackBar('Ошибка! Попробуйте повторить запрос позже.');
  }

  Future _sendImage() {
    return Api.setPhoto(UserStorage.instance.user, _image).then((value) => {
          if (value.isSuccess())
            {
              Api.getUser().then((value) => {
                    if (value.isSuccess())
                      {
                        UserStorage.instance.user = value.getData(),
                        currentUser = value.getData(),
                        setState(() {}),
                      }
                  })
            }
          else
            {callSnackBar("К сожалению, не удалось загрузить фотографию.")}
        });
  }

  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original
          ],
          maxWidth: 800);

      setState(() {
        //
      });
      var dialogLoading = DialogLoading(context: context);
      dialogLoading.show();
      _sendImage().then((value) => dialogLoading.stop());
    }
  }

  void showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Выбрать из галерии"),
              onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text("Сделать фотографию"),
              onTap: () {
                getImage(ImageSource.camera);
              },
            )
          ],
        ),
      ),
    );
  }

  void onTap() {
    showPickOptionsDialog(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset("images/header/cloud.png"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: new GestureDetector(
              onTap: () => onTap(),
              child: Stack(
                children: <Widget>[
                  new Container(
                      margin: EdgeInsets.only(top: 30, bottom: 15),
                      width: 220.0,
                      height: 220.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new CachedNetworkImageProvider(
                                  Api.getImageUrlByUser(currentUser),
                              )))),
                  new Container(
                      margin: EdgeInsets.only(top: 30, bottom: 15),
                      width: 220.0,
                      height: 220.0,
                      child: Icon(Icons.add, color: Colors.white54, size: 64))
                ],
              )),
        )
      ],
    );
  }
}

class Header extends StatefulWidget {
  final User _currentUser;

  Header(this._currentUser, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HeaderState(currentUser: _currentUser);
  }
}
