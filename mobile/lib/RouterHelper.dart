import 'package:flutter/cupertino.dart';
import 'auth/authFaculty.dart';
import 'package:hse_coffee/auth/authGender.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/gender.dart';

import 'auth/authName.dart';
import 'data/user.dart';

class RouterHelper {
  static routeByUser(BuildContext context, User user) {
    if (user.firstName == null ||
        user.lastName == null ||
        user.firstName.isEmpty ||
        user.lastName.isEmpty) {
      Navigator.of(context).pushNamed(AuthNameScreen.routeName);
    }
    else if(user.gender == null || user.gender == Gender.NONE){
      Navigator.of(context).pushNamed(AuthGenderScreen.routeName);
    }
    else if(user.faculty == null || user.faculty == Faculty.NONE || user.course == null || user.course == 0){
      Navigator.of(context).pushNamed(AuthFacultyScreen.routeName);
    }
    else {
      Navigator.of(context).pushNamed(AuthFacultyScreen.routeName);
    }
  }
}
