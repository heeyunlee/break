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
  List<double> _radiuses = [];

  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<String?> get weeklyWorkedOutMuscles => _weeklyWorkedOutMuscles;
  List<double> get radiuses => _radiuses;

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
    Map<DateTime, List<RoutineHistory?>> _mapData;
    final List<String?> _muscleWorked = [];
    final List<double> _newRadiuses = [];

    if (routineHistories.isNotEmpty) {
      _mapData = {
        for (var date in _dates)
          date: routineHistories
              .where((e) => e!.workoutDate.toUtc() == date)
              .toList()
      };

      // TODO: fix here
      // ignore: avoid_function_literals_in_foreach_calls
      _mapData.values.forEach((list) {
        if (list.isNotEmpty) {
          final _todaysMuscleWorked = Formatter.getFirstMainMuscleGroup(
            list.last!.mainMuscleGroup,
            list.last!.mainMuscleGroupEnum,
          );

          _muscleWorked.add(_todaysMuscleWorked);
        } else {
          _muscleWorked.add(null);
        }
      });
    } else {
      for (final _ in _dates) {
        _muscleWorked.add(null);
        _newRadiuses.add(16.0);
      }
      // _dates.forEach((_) {});
    }
    _weeklyWorkedOutMuscles = _muscleWorked;
    _radiuses = _newRadiuses;
  }
}
