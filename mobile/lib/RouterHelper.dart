import 'package:flutter/cupertino.dart';
import 'package:hse_coffee/auth/authGender.dart';
import 'package:hse_coffee/data/gender.dart';

import 'auth/AuthName.dart';
import 'data/user.dart';

class RouterHelper {
  static routeByUser(BuildContext context, User user) {
    if (user.firstName == null ||
        user.lastName == null ||
        user.firstName.isEmpty ||
        user.lastName.isEmpty) {
      Navigator.of(context).pushNamed(AuthNameScreen.routeName);
    }
    if(user.gender == null || user.gender == Gender.NONE){
      Navigator.of(context).pushNamed(AuthGenderScreen.routeName);
    }
    else {
      Navigator.of(context).pushNamed(AuthGenderScreen.routeName);
    }
  }
}
