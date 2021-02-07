import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hse_coffee/business_logic/api.dart';
import 'package:hse_coffee/business_logic/user_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hse_coffee/widgets/button_continue.dart';
import '../router_auth.dart';
import 'header.dart';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:hse_coffee/widgets/dialog_loading.dart';

class AuthPhotoScreen extends StatefulWidget {
  static const String routeName = "/auth/photo";

  @override
  _AuthPhotoScreen createState() => _AuthPhotoScreen();
}

class _AuthPhotoScreen extends State<AuthPhotoScreen> {
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final globalKey = GlobalKey<ScaffoldState>();

  void callSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _sendImage() {
    var dialogLoading = DialogLoading(context: context);

    dialogLoading.show();
    Api.setPhoto(UserStorage.instance.user, _image).then((value) => {
          if (value.isSuccess())
            {
              Api.getUser().then((value) => {
                    UserStorage.instance.user = value.getData(),
                    RouterHelper.routeByUser(context, value.getData())
                  })
            }
          else
            {callSnackBar("К сожалению, не удалось загрузить фотографию.")}
        });
    dialogLoading.stop();
  }

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
      _sendImage();
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Pick from Gallery"),
              onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text("Take a picture"),
              onTap: () {
                getImage(ImageSource.camera);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onButtonClick() {
      print(_image);
    }

    return Scaffold(
        key: globalKey,
        body: Builder(
            builder: (context) =>
                Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Header(
                      title: "Фотография",
                      image: CircleAvatar(
                        radius: 80,
                        child: _image == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: CachedNetworkImage(
                                  imageUrl: Api.getImageUrl() +
                                      UserStorage.instance.user.photoUri,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, dynamic) =>
                                      new Icon(Icons.error),
                                ),
                              )
                            : null,
                        backgroundImage:
                            _image != null ? FileImage(_image) : null,
                      )),
                  GradientButton(
                    child: Text("Продолжить", style: TextStyle(fontSize: 16.0)),
                    callback: () {
                      _showPickOptionsDialog(context);
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
                  ),
                  ButtonContinue(onPressed: _onButtonClick)
                ])));
  }
}
