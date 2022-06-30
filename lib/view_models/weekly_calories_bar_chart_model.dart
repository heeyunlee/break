import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/utils/formatter.dart';

final weeklyCaloriesBarChartModelProvider = ChangeNotifierProvider.family<
    WeeklyCaloriesBarChartModel, ProgressTabClass>(
  (ref, data) => WeeklyCaloriesBarChartModel(
    nutritions: data.nutritions,
    user: data.user,
  ),
);

class WeeklyCaloriesBarChartModel with ChangeNotifier {
  final List<Nutrition> nutritions;
  final User user;

  WeeklyCaloriesBarChartModel({
    required this.nutritions,
    required this.user,
  });

  num _caloriesMaxY = 2000;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<double> _relativeYs = [];
  int? _touchedIndex;
  double? _interval = 10;
  bool _goalExists = false;

  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<double> get relativeYs => _relativeYs;
  int? get touchedIndex => _touchedIndex;
  double? get interval => _interval;
  bool get goalExists => _goalExists;
  List<double> get randomListOfYs => [10, 10, 8, 10, 5, 5, 9];

  void init() {
    /// INIT Dates
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

    /// INIT Relative Ys
    Map<DateTime, List<Nutrition>> mapData;
    List<num> listOfYs = [];
    final List<double> relatives = [];

    final List<Nutrition> carbsList =
        nutritions.where((e) => e.calories != null).toList();

    if (carbsList.isNotEmpty) {
      mapData = {
        for (var item in _dates)
          item: carbsList.where((e) => e.loggedDate.toUtc() == item).toList()
      };

      listOfYs = mapData.values.map((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          for (final nutrition in list) {
            sum += nutrition.calories!;
          }
        }

        return sum;
      }).toList();

      final largest =
          [...listOfYs, user.dailyCalorieConsumptionGoal ?? 0].reduce(math.max);

      if (largest == 0) {
        _caloriesMaxY = 200;

        relatives.addAll(listOfYs.map((e) => 0));

        // for (final _ in listOfYs) {
        //   relatives.add(0);
        // }
      } else {
        final roundedLargest = (largest / 10).ceil() * 10;

        _caloriesMaxY = roundedLargest.toDouble() + 10;

        for (final y in listOfYs) {
          relatives.add(y / _caloriesMaxY * 10);
        }
      }
      _relativeYs = relatives;

      /// Set Interval
      if (user.dailyCalorieConsumptionGoal != null) {
        _interval = user.dailyCalorieConsumptionGoal! / _caloriesMaxY * 10;
      } else {
        _interval = 10.00;
      }
    } else {
      _relativeYs = [];
    }

    _goalExists = user.dailyCalorieConsumptionGoal != null;
  }

  String getTooltipText(double y) {
    final amount = (y / 1.05 / 10 * _caloriesMaxY).round();
    final formattedWeights = Formatter.numWithoutDecimal(amount);

    return '$formattedWeights kcal';
  }

  String getSideTiles(double value) {
    final toOriginalNumber = (value / 10 * _caloriesMaxY).round();

    return '$toOriginalNumber kcal';
  }

  void onTouchCallback(FlTouchEvent event, BarTouchResponse? barTouchResponse) {
    if (barTouchResponse?.spot != null && event is! FlTapUpEvent) {
      _touchedIndex = barTouchResponse?.spot!.touchedBarGroupIndex;
    } else {
      _touchedIndex = -1;
    }

    notifyListeners();
  }
}
