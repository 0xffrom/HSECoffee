// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchParams _$SearchParamsFromJson(Map<String, dynamic> json) {
  return SearchParams(
    (json['genders'] as List)
        ?.map((e) => _$enumDecodeNullable(_$GenderEnumMap, e))
        ?.toSet(),
    (json['faculties'] as List)
        ?.map((e) => _$enumDecodeNullable(_$FacultyEnumMap, e))
        ?.toSet(),
    (json['degrees'] as List)
        ?.map((e) => _$enumDecodeNullable(_$DegreeEnumMap, e))
        ?.toSet(),
    json['minCourse'] as int,
    json['maxCourse'] as int,
  );
}

Map<String, dynamic> _$SearchParamsToJson(SearchParams instance) =>
    <String, dynamic>{
      'genders': instance.genders?.map((e) => _$GenderEnumMap[e])?.toList(),
      'faculties':
          instance.faculties?.map((e) => _$FacultyEnumMap[e])?.toList(),
      'degrees': instance.degrees?.map((e) => _$DegreeEnumMap[e])?.toList(),
      'minCourse': instance.minCourse,
      'maxCourse': instance.maxCourse,
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

const _$DegreeEnumMap = {
  Degree.NONE: 'NONE',
  Degree.BACHELOR: 'BACHELOR',
  Degree.MAGISTRACY: 'MAGISTRACY',
  Degree.SPECIALTY: 'SPECIALTY',
  Degree.POSTGRADUATE: 'POSTGRADUATE',
};
