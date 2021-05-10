import 'dart:convert';
import 'dart:math';
import 'package:hse_coffee/business_logic/auth.dart';
import 'package:hse_coffee/business_logic/event_wrapper.dart';
import 'package:hse_coffee/data/meet.dart';
import 'package:hse_coffee/data/meet_status.dart';
import 'package:hse_coffee/data/search_params.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart' as dio;

class Api {
  static const String _Ip = "http://188.120.233.197";

  static int _number = 0;

  static updateImage() {
    _number = Random().nextInt(99999);
  }

  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static String getImageUrlByUser(User user) {
    return _Ip + "/" + user.photoUri + "?$_number";
  }

  static Future<EventWrapper<bool>> sendCode(String email) async {
    print("/api/code?email=$email");

    final response = await http.post('$_Ip/api/code?email=$email');

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

    final response = await http.post('$_Ip/api/confirm',
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

  static Future<EventWrapper<MeetStatus>> search(
      SearchParams searchParams) async {
    final accessToken = await Auth.getAccessToken();
    print("POST: /api/search/. accessToken = [$accessToken]");

    var jsonEnc = json.encode(searchParams.toJson());

    print(jsonEnc);

    final response = await http.post('$_Ip/api/search/$accessToken',
        body: jsonEnc, headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(
          response.statusCode, _getMeetByResponse(response), "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return search(searchParams);
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<MeetStatus>> cancelSearch() async {
    final accessToken = await Auth.getAccessToken();
    print("DELETE: /api/meet. accessToken = [$accessToken]");

    final response =
        await http.delete('$_Ip/api/meet/$accessToken', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(
          response.statusCode, _getMeetByResponse(response), "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return cancelSearch();
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static MeetStatus _getMeetByResponse(http.Response response) {
    var meetStatus;

    try {
      meetStatus = MeetStatus.values.firstWhere((element) =>
          element.toString().toLowerCase().replaceAll("meetstatus.", "") ==
          response.body.toLowerCase());
    } catch (StateError) {
      print("Ошибка при получении meetStatus из ${response.body}");
      meetStatus = MeetStatus.NONE;
    }

    return meetStatus;
  }

  static Future<EventWrapper<bool>> setUser(User user) async {
    final accessToken = await Auth.getAccessToken();
    print("PUT: /api/user/settings/. accessToken = [$accessToken]");

    var jsonEnc = json.encode(user.toJson());

    print(jsonEnc);

    final response = await http.put('$_Ip/api/user/settings/$accessToken',
        body: jsonEnc, headers: headers);

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
    final accessToken = await Auth.getAccessToken();
    print("POST: api/user/image/. accessToken = [$accessToken]");

    var jsonEnc = json.encode(user.toJson());

    print(jsonEnc);

    dio.FormData formData = new dio.FormData.fromMap(
        {"image": await dio.MultipartFile.fromFile(file.path)});

    final response = await dio.Dio()
        .post("$_Ip/api/user/image/$accessToken", data: formData);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return setPhoto(user, file);
    }

    if (response.data != null)
      return EventWrapper(response.statusCode, null, response.data);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<User>> getUser() async {
    final accessToken = await Auth.getAccessToken();
    print("GET: /api/user. accessToken = [$accessToken]");

    final response = await http.get('$_Ip/api/user/settings/$accessToken');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      var user = User.fromJson(jsonDecode(response.body));

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

  static Future<EventWrapper<Meet>> getMeet() async {
    final accessToken = await Auth.getAccessToken();
    print("GET: /api/meet. accessToken = [$accessToken]");

    final response = await http.get('$_Ip/api/meet/$accessToken');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Meet meet = Meet.fromJson(json.decode(response.body));

      print("GET 200: ${meet.toJson()}");
      return EventWrapper(response.statusCode, meet, "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return getMeet();
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Meet>>> getMeets() async {
    final accessToken = await Auth.getAccessToken();
    print("GET: /api/meets. accessToken = [$accessToken]");

    final response = await http.get('$_Ip/api/meets/$accessToken');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Meet> meets =
          List<Meet>.from(l.map((model) => Meet.fromJson(model)));

      print("GET 200: ${meets.toString()}");
      return EventWrapper(response.statusCode, meets, "Удачно");
    }

    if ((response.statusCode == 403 || response.statusCode == 401) &&
        (await _updateTokens()) == true) {
      return getMeets();
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<bool> _updateTokens() async {
    var email = await Auth.getEmail();
    var refreshToken = await Auth.getRefreshToken();
    var fingerprint = await Auth.getFingerprint();

    print("/api/refresh. "
        "fingerprint = [$fingerprint], "
        "email = [$email], "
        "refreshToken = [$refreshToken]");

    final response = await http.post("$_Ip/api/refresh?", body: {
      "fingerprint": fingerprint,
      "email": email,
      "refreshToken": refreshToken
    });

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      await Auth.saveDataByJson(email, response.body);

      return true;
    }

    return false;
  }
}
