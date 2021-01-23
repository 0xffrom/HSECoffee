import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  String name;
  String value;

  Contact(this.name, this.value);

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);


  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
