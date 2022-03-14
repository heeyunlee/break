import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/top_level_variables.dart';
import 'package:workout_player/utils/formatter.dart';

class WeeklyCaloriesChartModel with ChangeNotifier {
  WeeklyCaloriesChartModel({
    required this.topLevelVariables,
    required this.nutritions,
    required this.user,
  });

  final TopLevelVariables topLevelVariables;
  final List<Nutrition> nutritions;
  final User user;

  int? _touchedIndex;

  int? get touchedIndex => _touchedIndex;

  double getMaxY() {
    final now = DateTime.now();
    final dates = List<DateTime>.generate(7, (index) {
      return DateTime.utc(now.year, now.month, now.day - index);
    }).reversed.toList();

    List<double> _listOfYs;

    if (nutritions.isNotEmpty) {
      Map<DateTime, List<Nutrition>> _mapData = {
        for (var item in dates)
          item: nutritions.where((e) => e.loggedDate.toUtc() == item).toList()
      };

      final listOfYs = _mapData.values.map((list) {
        double sum = 0;

        if (list.isNotEmpty) {
          for (final nutrition in list) {
            sum += (nutrition.calories ?? 0);
          }
        }

        return sum;
      }).toList();

      _listOfYs = listOfYs;
    } else {
      _listOfYs = [2100, 1900, 1500, 1600, 2160, 1620, 2356];
    }

    return _listOfYs.reduce(math.max);
  }

  List<double> listOfYs() {
    // final now = DateTime.now();
    // final dates = List<DateTime>.generate(7, (index) {
    //   return DateTime.utc(now.year, now.month, now.day - index);
    // }).reversed.toList();

    if (nutritions.isNotEmpty) {
      Map<DateTime, List<Nutrition>> _mapData = {
        for (var item in topLevelVariables.thisWeek)
          item: nutritions.where((e) => e.loggedDate.toUtc() == item).toList()
      };

      final listOfYs = _mapData.values.map((list) {
        double sum = 0;

        if (list.isNotEmpty) {
          for (final nutrition in list) {
            sum += (nutrition.calories ?? 0);
          }
        }

        return sum;
      }).toList();

      return listOfYs;
    } else {
      return [2100, 1900, 1500, 1600, 2160, 1620, 2356];
    }
  }

  String getDaysOfTheWeek(int y) {
    /// INIT Dates
    final now = DateTime.now();
    final dates = List<DateTime>.generate(7, (index) {
      return DateTime.utc(now.year, now.month, now.day - index);
    }).reversed.toList();

    final daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(dates[index]),
    );

    return daysOfTheWeek[y];
  }

  String getTooltipText(double y) {
    final amount = (y / 1.05).round();
    final formattedWeights = Formatter.numWithoutDecimal(amount);

    return '$formattedWeights kcal';
  }

  String getSideTiles(double value) {
    // final toOriginalNumber = (value / 10 * _caloriesMaxY).round();

    return '$value kcal';
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
