import 'contact.dart';
import 'faculty.dart';
import 'gender.dart';
import 'degree.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String email;
  String firstName;
  String lastName;
  Gender gender;
  Degree degree;
  Faculty faculty;
  Set<Contact> contacts;
  int course;
  String photoUri;

  User(
      {this.email,
      this.firstName,
      this.lastName,
      this.gender,
      this.degree,
      this.faculty,
      this.contacts,
      this.course,
      this.photoUri});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
