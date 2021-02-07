import 'dart:convert';
import 'package:hse_coffee/business_logic/auth.dart';
import 'package:hse_coffee/business_logic/event_wrapper.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart' as dio;

class Api {
  // http://10.0.2.2:8081
  static const String ip = "http://188.120.233.197/";

  static const Map<String, String> _JSON_HEADERS = {
    "content-type": "application/json"
  };

  static String getImageUrl(){
    return ip;
  }

  static Future<EventWrapper<bool>> sendCode(String email) async {
    print("/api/code?email=$email");

    final response = await http.post('$ip/api/code?email=$email');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmCode(
      String code, String email) async {
    var fingerprint = await Auth.getFingerprint();

    print(
        "/api/confirm. Email: $email; fingerprint: $fingerprint; code: $code");

    final response = await http.post('$ip/api/confirm',
        body: {"email": email, "fingerprint": fingerprint, "code": code});

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      await Auth.saveDataByJson(email, response.body);
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> setUser(User user) async {
    final accessToken = (await Auth.getData())["access"];
    print("PUT: /api/user. accessToken = [$accessToken]");

    var jsonEnc = json.encode(user.toJson());

    print(jsonEnc);

    final response = await http.put('$ip/api/user/settings/$accessToken', body: jsonEnc, headers: _JSON_HEADERS);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return setUser(user);
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");

  }

  static Future<EventWrapper<bool>> setPhoto(User user, File file) async {
    final accessToken = (await Auth.getData())["access"];
    print("POST: api/user/image/. accessToken = [$accessToken]");

    var jsonEnc = json.encode(user.toJson());

    print(jsonEnc);

    dio.FormData formData = new dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(file.path)
    });

    final response = await dio.Dio().post("$ip/api/user/image/$accessToken", data: formData);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return setUser(user);
    }

    if (response.data != null)
      return EventWrapper(response.statusCode, null, response.data);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");

  }

  static Future<EventWrapper<User>> getUser() async {
    final accessToken = (await Auth.getData())["access"];
    print("GET: /api/user. accessToken = [$accessToken]");

    final response = await http.get('$ip/api/user/settings/$accessToken');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      var user =  User.fromJson(jsonDecode(response.body));

      print("GET 200: ${user.toString()}");
      return EventWrapper(response.statusCode, user, "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return getUser();
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<bool> _updateTokens() async {
    var data = await Auth.getData();
    var fingerprint = await Auth.getFingerprint();

    print("/api/refresh. "
        "fingerprint = [$fingerprint], "
        "email = [${data["email"]}], "
        "refreshToken = [${data["refresh"]}]");

    final response = await http.post("$ip/api/refresh?", body: {
      "fingerprint": fingerprint,
      "email": data["email"],
      "refreshToken": data["refresh"]
    });

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      await Auth.saveDataByJson(data["email"], response.body);

      return true;
    }

    return false;
  }
}
