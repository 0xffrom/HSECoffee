import 'package:hse_coffee/data/faculty.dart';
import 'package:hse_coffee/data/degree.dart';
import 'package:smart_select/smart_select.dart';

class DataRes {
  static String getFacultyName(Faculty faculty) {
    if (choicesFaculties.firstWhere((element) => element.value == faculty) ==
        null) {
      return "";
    }

    return choicesFaculties
        .firstWhere((element) => element.value == faculty)
        .title;
  }

  static final choicesDegrees = <S2Choice<Degree>>[
    S2Choice<Degree>(value: Degree.BACHELOR, title: "Бакалавриат"),
    S2Choice<Degree>(value: Degree.MAGISTRACY, title: "Магистратура"),
    S2Choice<Degree>(value: Degree.POSTGRADUATE, title: "Аспирантура"),
    S2Choice<Degree>(value: Degree.SPECIALTY, title: "Специалитет"),
  ];

  static final choicesFaculties = <S2Choice<Faculty>>[
    S2Choice<Faculty>(value: Faculty.BANK, title: "Банковский институт"),
    S2Choice<Faculty>(
        value: Faculty.JURISPRUDENCE,
        title: "Высшая школа юрисиспруденции и администрирования"),
    S2Choice<Faculty>(value: Faculty.BUSINESS, title: "Высшая школа бизнеса"),
    S2Choice<Faculty>(
        value: Faculty.STATISTIC,
        title: "Институт статистических исследований и экономики знаний"),
    S2Choice<Faculty>(value: Faculty.LYCEUM, title: "Лицей НИУ ВШЭ"),
    S2Choice<Faculty>(value: Faculty.ELECTRONIC, title: "МИЭМ"),
    S2Choice<Faculty>(
        value: Faculty.MIEF,
        title: "Международный институт экономики и финансов"),
    S2Choice<Faculty>(
        value: Faculty.BIOLOGY, title: "Факультет биологии и биотехнологии"),
    S2Choice<Faculty>(
        value: Faculty.HUMANITARIAN, title: "Факультет гуманитарных наук"),
    S2Choice<Faculty>(
        value: Faculty.CITY,
        title: "Факультет городского и регионального развития"),
    S2Choice<Faculty>(
        value: Faculty.GEOGRAPHY,
        title: "Факультет географии и геоинформационных технологий"),
    S2Choice<Faculty>(
        value: Faculty.MEDIA, title: "Факультет коммуникация, медиа и дизайна"),
    S2Choice<Faculty>(
        value: Faculty.COMPUTER, title: "Факультет компьютерных наук"),
    S2Choice<Faculty>(value: Faculty.MATH, title: "Факультет математики"),
    S2Choice<Faculty>(
        value: Faculty.WORLD_ECONOMY,
        title: "Факультет мировой экономики и мировой политики"),
    S2Choice<Faculty>(value: Faculty.LAWYER, title: "Факультет права"),
    S2Choice<Faculty>(
        value: Faculty.SOCIAL, title: "Факультет социальных наук"),
    S2Choice<Faculty>(value: Faculty.PHYSICS, title: "Факультет физики"),
    S2Choice<Faculty>(value: Faculty.CHEMICAL, title: "Факультет химии"),
    S2Choice<Faculty>(
        value: Faculty.ECONOMY, title: "Факультет экономических наук"),
    S2Choice<Faculty>(
        value: Faculty.LANGUAGE, title: "Школа иностранных языков"),
  ];
}
