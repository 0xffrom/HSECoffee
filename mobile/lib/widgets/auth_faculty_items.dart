import 'package:flutter/material.dart';
import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/degree.dart';

class DataRes {
  static final List<DropdownMenuItem<Faculty>> faculties = [
    DropdownMenuItem(
        child: GestureDetector(child: Text("Банковский институт")),
        value: Faculty.BANK),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text("Высшая школа юрисиспруденции и администрирования")),
        value: Faculty.JURISPRUDENCE),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Высшая школа бизнеса")),
        value: Faculty.BUSINESS),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text(
                "Институт статистических исследований и экономики знаний")),
        value: Faculty.STATISTIC),
    DropdownMenuItem(
      child: GestureDetector(child: Text("Лицей НИУ ВШЭ")),
      value: Faculty.LYCEUM,
    ),
    DropdownMenuItem(
        child: GestureDetector(child: Text("МИЭМ")), value: Faculty.ELECTRONIC),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text("Международный институт экономики и финансов")),
        value: Faculty.MIEF),
    DropdownMenuItem(
        child:
            GestureDetector(child: Text("Факультет биологии и биотехнологии")),
        value: Faculty.BIOLOGY),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет гуманитарных наук")),
        value: Faculty.HUMANITARIAN),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text("Факультет городского и регионального развития")),
        value: Faculty.CITY),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text("Факультет географии и геоинформационных технологий")),
        value: Faculty.GEOGRAPHY),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text("Факультет коммуникация, медиа и дизайна")),
        value: Faculty.MEDIA),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет компьютерных наук")),
        value: Faculty.COMPUTER),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет математики")),
        value: Faculty.MATH),
    DropdownMenuItem(
        child: GestureDetector(
            child: Text("Факультет мировой экономики и мировой политики")),
        value: Faculty.WORLD_ECONOMY),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет права")),
        value: Faculty.LAWYER),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет социальных наук")),
        value: Faculty.SOCIAL),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет физики")),
        value: Faculty.PHYSICS),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет химии")),
        value: Faculty.CHEMICAL),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Факультет экономических наук")),
        value: Faculty.ECONOMY),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Школа иностранных языков")),
        value: Faculty.LANGUAGE),
  ];

  static final List<DropdownMenuItem<Degree>> degrees = [
    DropdownMenuItem(
        child: GestureDetector(child: Text("Бакалавриат")),
        value: Degree.BACHELOR),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Магистратура")),
        value: Degree.MAGISTRACY),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Аспирантура")),
        value: Degree.POSTGRADUATE),
    DropdownMenuItem(
        child: GestureDetector(child: Text("Специалитет")),
        value: Degree.SPECIALTY)
  ];
}
