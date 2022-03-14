import 'package:intl/intl.dart';

class TopLevelVariables {
  DateTime get now => DateTime.now().toUtc();

  List<DateTime> get thisWeek {
    return List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day - index);
    }).reversed.toList();
  }

  List<int> get thisWeekDays {
    return thisWeek.map((date) => date.day).toList();
  }

  List<String> get thisWeekDaysOfTheWeek {
    final f = DateFormat.E();
    return thisWeek.map((date) => f.format(date)).toList();
  }
}
