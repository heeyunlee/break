import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';

final weeklyLiftedWeightsChartModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyLiftedWeightsChartModel(),
);

class WeeklyLiftedWeightsChartModel with ChangeNotifier {
  num _maxY = 150;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<double> _relativeYs = [];

  num get maxY => _maxY;
  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<double> get relativeYs => _relativeYs;

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

  void setData(List<RoutineHistory> routineHistories, User user) {
    Map<DateTime, List<RoutineHistory>> _mapData;
    List<num> listOfYs = [];
    List<double> relatives = [];

    if (routineHistories.isNotEmpty) {
      _mapData = {
        for (var item in _dates)
          item: routineHistories
              .where((e) => e.workoutDate.toUtc() == item)
              .toList()
      };

      _mapData.values.forEach((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          list.forEach((nutrition) {
            sum += nutrition.totalWeights;
          });
        }

        listOfYs.add(sum);
      });

      final largest =
          [...listOfYs, user.dailyProteinGoal ?? 0].reduce(math.max);

      if (largest == 0) {
        _maxY = 20000;

        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else if (user.weightGoal != null) {
        final roundedLargest = (largest / 1000).ceil() * 1000;
        _maxY = roundedLargest.toDouble() + 1000;

        listOfYs.forEach((element) {
          relatives.add(element / _maxY * 10);
        });
      }
      _relativeYs = relatives;
    }
  }
}
