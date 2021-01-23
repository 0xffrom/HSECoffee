import 'contact.dart';
import 'faculty.dart';
import 'gender.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String email;
  String firstName;
  String lastName;
  Gender gender;
  Faculty faculty;
  List<Contact> contacts;
  int course;
  String photoUri;

  User(
      {this.email,
      this.firstName,
      this.lastName,
      this.gender,
      this.faculty,
      this.contacts,
      this.course,
      this.photoUri});

/*
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        firstName: json['firstName'],
        secondName: json['secondName'],
        sex: Sex.values
            .firstWhere((f) => f.toString() == json['sex'], orElse: () => null),
        faculty: Faculty.values.firstWhere(
            (f) => f.toString() == json['faculty'],
            orElse: () => null),
        contacts: new List<Contact>.from(json['contacts']),
        course: json['course'],
        photoUri: json['photoUri']);
  }
*/

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);


  Map<String, dynamic> toJson() => _$UserToJson(this);
}
