import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/utils/formatter.dart';

final weeklyWorkoutSummaryModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyWorkoutSummaryModel(),
);

class WeeklyWorkoutSummaryModel with ChangeNotifier {
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<String?> _weeklyWorkedOutMuscles = [];

  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<String?> get weeklyWorkedOutMuscles => _weeklyWorkedOutMuscles;

  void init() {
    final DateTime now = DateTime.now();

    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    _dates = _dates.reversed.toList();

    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );
  }

  void setData(List<RoutineHistory?> routineHistories, String locale) {
    List<String?> _muscleWorked = [];
    Map<DateTime, List<RoutineHistory?>> _mapData = {
      for (final date in _dates)
        date: routineHistories
            .where((e) => e!.workoutDate.toUtc() == date)
            .toList()
    };

    if (routineHistories.isNotEmpty) {
      _muscleWorked = _mapData.values.map((list) {
        if (list.isNotEmpty) {
          final _todaysMuscleWorked = Formatter.getFirstMainMuscleGroup(
            list.last!.mainMuscleGroup,
            list.last!.mainMuscleGroupEnum,
          );

          return _todaysMuscleWorked;
        } else {
          return null;
        }
      }).toList();
    } else {
      _muscleWorked = List.generate(7, (index) => null).toList();
    }
    _weeklyWorkedOutMuscles = _muscleWorked;
  }
}
