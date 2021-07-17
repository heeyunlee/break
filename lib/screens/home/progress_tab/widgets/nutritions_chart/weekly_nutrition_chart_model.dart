import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';

final weeklyNutritionChartModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyNutritionChartModel(),
);

class WeeklyNutritionChartModel with ChangeNotifier {
  num _nutritionMaxY = 150;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<double> _relativeYs = [];

  num get nutritionMaxY => _nutritionMaxY;
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

  Future<void> setRelativeList(List<Nutrition>? list, User user) async {
    Map<DateTime, List<Nutrition>> _mapData;
    List<num> _listOfYs = [];
    List<double> _relatives = [];

    if (list != null) {
      if (list.isNotEmpty) {
        _mapData = {
          for (var item in _dates)
            item: list.where((e) => e.loggedDate.toUtc() == item).toList()
        };

        _mapData.values.forEach((list) {
          num sum = 0;

          if (list.isNotEmpty) {
            list.forEach((nutrition) {
              sum += nutrition.proteinAmount;
            });
          }

          _listOfYs.add(sum);
        });
        final largest =
            [..._listOfYs, user.dailyProteinGoal ?? 0].reduce(math.max);

        if (largest == 0) {
          _nutritionMaxY = 150;

          _listOfYs.forEach((element) {
            _relatives.add(0);
          });
        } else {
          final roundedLargest = (largest / 10).ceil() * 10;

          _nutritionMaxY = roundedLargest.toDouble() + 10;

          _listOfYs.forEach((element) {
            _relatives.add(element / _nutritionMaxY * 10);
          });
        }
        _relativeYs = _relatives;
      }
    }
  }
}
