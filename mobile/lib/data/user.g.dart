// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    gender: _$enumDecodeNullable(_$GenderEnumMap, json['gender']),
    degree: _$enumDecodeNullable(_$DegreeEnumMap, json['degree']),
    faculty: _$enumDecodeNullable(_$FacultyEnumMap, json['faculty']),
    contacts: (json['contacts'] as List)
        ?.map((e) =>
            e == null ? null : Contact.fromJson(e as Map<String, dynamic>))
        ?.toSet(),
    course: json['course'] as int,
    photoUri: json['photoUri'] as String,
    aboutMe: json['aboutMe'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': _$GenderEnumMap[instance.gender],
      'degree': _$DegreeEnumMap[instance.degree],
      'faculty': _$FacultyEnumMap[instance.faculty],
      'contacts': instance.contacts?.map((e) => e?.toJson())?.toList(),
      'course': instance.course,
      'photoUri': instance.photoUri,
      'aboutMe': instance.aboutMe
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

const _$GenderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
  Gender.NONE: 'NONE',
};

const _$DegreeEnumMap = {
  Degree.NONE: 'NONE',
  Degree.BACHELOR: 'BACHELOR',
  Degree.MAGISTRACY: 'MAGISTRACY',
  Degree.SPECIALTY: 'SPECIALTY',
  Degree.POSTGRADUATE: 'POSTGRADUATE',
};

const _$FacultyEnumMap = {
  Faculty.LYCEUM: 'LYCEUM',
  Faculty.MATH: 'MATH',
  Faculty.ECONOMY: 'ECONOMY',
  Faculty.ELECTRONIC: 'ELECTRONIC',
  Faculty.COMPUTER: 'COMPUTER',
  Faculty.BUSINESS: 'BUSINESS',
  Faculty.LAWYER: 'LAWYER',
  Faculty.JURISPRUDENCE: 'JURISPRUDENCE',
  Faculty.HUMANITARIAN: 'HUMANITARIAN',
  Faculty.SOCIAL: 'SOCIAL',
  Faculty.MEDIA: 'MEDIA',
  Faculty.WORLD_ECONOMY: 'WORLD_ECONOMY',
  Faculty.MIEF: 'MIEF',
  Faculty.PHYSICS: 'PHYSICS',
  Faculty.CITY: 'CITY',
  Faculty.CHEMICAL: 'CHEMICAL',
  Faculty.BIOLOGY: 'BIOLOGY',
  Faculty.GEOGRAPHY: 'GEOGRAPHY',
  Faculty.LANGUAGE: 'LANGUAGE',
  Faculty.STATISTIC: 'STATISTIC',
  Faculty.BANK: 'BANK',
  Faculty.NONE: 'NONE',
};
