import 'package:flutter/cupertino.dart';

import 'auth/AuthName.dart';
import 'data/User.dart';

class RouterHelper {
  static routeByUser(BuildContext context, User user) {
    if (user.firstName == null ||
        user.secondName == null ||
        user.firstName.isEmpty ||
        user.secondName.isEmpty) {
      Navigator.of(context).pushNamed(AuthNameScreen.routeName,
          arguments: ScreenAuthNameArguments(user));
    } else {
      Navigator.of(context).pushNamed(AuthNameScreen.routeName,
          arguments: ScreenAuthNameArguments(user));
    }
  }
}
