import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  String name;
  String value;

  Contact(this.name, this.value);

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);

  static Contact createVk(String login){
    return Contact("vk", login);
  }

  static Contact createTelegram(String login){
    return Contact("tg", login);
  }

  static Contact createInstagram(String login){
    return Contact("inst", login);
  }
}
