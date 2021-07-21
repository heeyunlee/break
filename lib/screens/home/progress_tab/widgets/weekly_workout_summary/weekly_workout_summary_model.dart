import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/classes/routine_history.dart';

final weeklyWorkoutSummaryModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyWorkoutSummaryModel(),
);

class WeeklyWorkoutSummaryModel with ChangeNotifier {
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<String?> _weeklyWorkedOutMuscles = [];
  List<double> _radiuses = [];

  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<String?> get weeklyWorkedOutMuscles => _weeklyWorkedOutMuscles;
  List<double> get radiuses => _radiuses;

  void init() {
    DateTime now = DateTime.now();

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
    Map<DateTime, List<RoutineHistory?>> _mapData;
    List<String?> _muscleWorked = [];
    List<double> _newRadiuses = [];

    if (routineHistories.isNotEmpty) {
      _mapData = {
        for (var date in _dates)
          date: routineHistories
              .where((e) => e!.workoutDate.toUtc() == date)
              .toList()
      };

      _mapData.values.forEach((list) {
        if (list.isNotEmpty) {
          final _todaysMuscleWorked = MainMuscleGroup.values
              .firstWhere((e) => e.toString() == list.last!.mainMuscleGroup[0])
              .broadGroup!;

          _muscleWorked.add(_todaysMuscleWorked);
        } else {
          _muscleWorked.add(null);
        }
      });
    } else {
      _dates.forEach((_) {
        _muscleWorked.add(null);
        _newRadiuses.add(16.0);
      });
    }
    _weeklyWorkedOutMuscles = _muscleWorked;
    _radiuses = _newRadiuses;
  }
}
