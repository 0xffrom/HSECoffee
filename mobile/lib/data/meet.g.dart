// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meet _$MeetFromJson(Map<String, dynamic> json) {
  return Meet(
    json['user1'] == null
        ? null
        : User.fromJson(json['user1'] as Map<String, dynamic>),
    json['user2'] == null
        ? null
        : User.fromJson(json['user2'] as Map<String, dynamic>),
    _$enumDecodeNullable(_$MeetStatusEnumMap, json['meetStatus']),
    json['createdDate'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['createdDate'] as int),
    json['expiresDate'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['expiresDate'] as int),
  );
}

Map<String, dynamic> _$MeetToJson(Meet instance) => <String, dynamic>{
      'user1': instance.user1,
      'user2': instance.user2,
      'meetStatus': _$MeetStatusEnumMap[instance.meetStatus],
      'createdDate': instance.createdDate?.toIso8601String(),
      'expiresDate': instance.expiresDate?.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MeetStatusEnumMap = {
  MeetStatus.ACTIVE: 'ACTIVE',
  MeetStatus.FINISHED: 'FINISHED',
  MeetStatus.SEARCH: 'SEARCH',
  MeetStatus.NONE: 'NONE',
  MeetStatus.ERROR: 'ERROR',
};
