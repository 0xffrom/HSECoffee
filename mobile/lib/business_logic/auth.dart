import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  static final String emailKey = "email";
  static final String accessTokenKey = "accessToken";
  static final String refreshTokenKey = "refreshToken";

  static Future<void> saveDataByJson(String email, String json) async {
    Map<String, dynamic> jsonMap = jsonDecode(json);

    print("Данные сохранены. email = [$email], "
        "accessToken = [${jsonMap["accessToken"]}], "
        "refreshToken = [${jsonMap["refreshToken"]}]");

    var storage = FlutterSecureStorage();

    storage.write(key: emailKey, value: email);
    storage.write(key: accessTokenKey, value: jsonMap["accessToken"]);
    storage.write(key: refreshTokenKey, value: jsonMap["refreshToken"]);
  }

  static Future<Map<String, String>> getData() async {
    return FlutterSecureStorage().readAll();
  }

  static Future<String> getFingerprint() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  static Future<String> getAccessToken() async {
    return (await Auth.getData())[Auth.accessTokenKey];
  }

  static Future<String> getEmail() async {
    return (await Auth.getData())[Auth.emailKey];
  }

  static Future<String> getRefreshToken() async {
    return (await Auth.getData())[Auth.refreshTokenKey];
  }
}
