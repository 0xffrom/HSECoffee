import 'package:hse_coffee/data/faculty.dart';
import 'package:json_annotation/json_annotation.dart';

import 'degree.dart';
import 'gender.dart';

part 'search_params.g.dart';

@JsonSerializable()
class SearchParams {
  Set<Gender> genders;
  Set<Faculty> faculties;
  Set<Degree> degrees;

  int minCourse;
  int maxCourse;

  SearchParams(this.genders,
      this.faculties,
      this.degrees,
      this.minCourse,
      this.maxCourse);

  factory SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);


  Map<String, dynamic> toJson() => _$SearchParamsToJson(this);
}
