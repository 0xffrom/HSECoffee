import 'package:hse_coffee/data/meet_status.dart';
import 'package:hse_coffee/data/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meet.g.dart';

@JsonSerializable()
class Meet {
  User user1;
  User user2;

  MeetStatus meetStatus;
  DateTime createdDate;
  DateTime expiresDate;

  Meet(this.user1, this.user2, this.meetStatus, this.createdDate,
      this.expiresDate);

  factory Meet.fromJson(Map<String, dynamic> json) => _$MeetFromJson(json);


  Map<String, dynamic> toJson() => _$MeetToJson(this);
}
