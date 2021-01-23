import 'package:flutter/foundation.dart';

import 'Contact.dart';
import 'Faculty.dart';
import 'Sex.dart';

class User {
  String email;
  String firstName;
  String secondName;
  Sex sex;
  Faculty faculty;
  List<Contact> contacts;
  int course;
  String photoUri;

  User(
      {this.email,
      this.firstName,
      this.secondName,
      this.sex,
      this.faculty,
      this.contacts,
      this.course,
      this.photoUri});

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
        email: json['email'],
        firstName: json['firstName'],
        secondName: json['secondName'],
        sex: Sex.values.firstWhere((f)=> f.toString() == json['sex'], orElse: () => null),
        faculty: Faculty.values.firstWhere((f)=> f.toString() == json['faculty'], orElse: () => null),
        contacts: new List<Contact>.from(json['contacts']),
        course: json['course'],
        photoUri: json['photoUri']);
  }
}
