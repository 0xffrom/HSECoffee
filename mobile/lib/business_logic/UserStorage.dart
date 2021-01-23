import 'package:hse_coffee/data/user.dart';

class UserStorage {
  User _user;

  User get user{
    if (_user == null) {
      throw Exception("Get null user");
    }
    return _user;
  }

  set user(User user) {
    if (user == null) {
      throw Exception("Set null user");
    }
    _user = user;
  }

  static final UserStorage instance = UserStorage._internal();

  factory UserStorage() {
    return instance;
  }

  UserStorage._internal();
}
