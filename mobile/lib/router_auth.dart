import 'package:flutter/cupertino.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/gender.dart';
import 'package:hse_coffee/ui/auth/auth_contacts.dart';
import 'package:hse_coffee/ui/auth/auth_faculty.dart';
import 'package:hse_coffee/ui/auth/auth_gender.dart';
import 'package:hse_coffee/ui/auth/auth_name.dart';
import 'package:hse_coffee/ui/auth/auth_photo.dart';
import 'package:hse_coffee/ui/home/home.dart';
import 'data/user.dart';

class RouterHelper {
  static routeByUser(BuildContext context, User user) {
    // Если пусто имя
    if (user.firstName == null ||
        user.lastName == null ||
        user.firstName.isEmpty ||
        user.lastName.isEmpty) {
      Navigator.of(context).pushReplacementNamed(AuthNameScreen.routeName);
    }
    // Если не выбран пол
    else if(user.gender == null || user.gender == Gender.NONE){
      Navigator.of(context).pushReplacementNamed(AuthGenderScreen.routeName);
    }
    // Если не выбран факультет
    else if(user.faculty == null || user.faculty == Faculty.NONE || user.course == null || user.course == 0){
      Navigator.of(context).pushReplacementNamed(AuthFacultyScreen.routeName);
    }
    // Если не указаны контактные данные
    else if(user.contacts.isEmpty){
      Navigator.of(context).pushReplacementNamed(AuthContactsScreen.routeName);
    }
    // Если нет фотографии
    else if(!user.photoUri.contains(user.email)){
      Navigator.of(context).pushReplacementNamed(AuthPhotoScreen.routeName);
    }
    // Иначе
    else {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }
}
