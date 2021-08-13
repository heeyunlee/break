import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/classes/combined/progress_tab_class.dart';
import 'package:workout_player/classes/routine_history.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/utils/formatter.dart';

final weeklyWeightsBarChartModelProvider =
    ChangeNotifierProvider.family<WeeklyWeightsBarChartModel, ProgressTabClass>(
  (ref, data) => WeeklyWeightsBarChartModel(
    routineHistories: data.routineHistories,
    user: data.user,
  ),
);

class WeeklyWeightsBarChartModel with ChangeNotifier {
  final List<RoutineHistory> routineHistories;
  final User user;

  WeeklyWeightsBarChartModel({
    required this.routineHistories,
    required this.user,
  });

  num _weightsLiftedMaxY = 10000;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<double> _relativeYs = [];
  int? _touchedIndex;
  double? _interval = 10.0;
  bool _goalExists = false;

  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<double> get relativeYs => _relativeYs;
  int? get touchedIndex => _touchedIndex;
  double? get interval => _interval;
  bool get goalExists => _goalExists;
  List<double> get randomListOfYs => [7, 8, 10, 5.6, 9, 10, 8.5];

  void init() {
    /// SET DATES
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

    /// Set Ys
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

      final largest = [
        ...listOfYs,
        user.dailyProteinGoal ?? 0,
      ].reduce(math.max);

      if (largest == 0) {
        _weightsLiftedMaxY = 20000;

        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largest / 1000).ceil() * 1000;
        _weightsLiftedMaxY = roundedLargest.toDouble() + 1000;

        listOfYs.forEach((element) {
          relatives.add(element / _weightsLiftedMaxY * 10);
        });
      }
      _relativeYs = relatives;

      /// Set Interval
      if (user.dailyWeightsGoal != null) {
        _interval = user.dailyWeightsGoal! / _weightsLiftedMaxY * 10;
      } else {
        _interval = 10.00;
      }
    } else {
      _relativeYs = [];
    }

    _goalExists = user.dailyWeightsGoal != null;
  }

  String getTooltipText(double y) {
    final weights = (y / 1.05 / 10 * _weightsLiftedMaxY).round();
    final formattedWeights = Formatter.numWithDecimal(weights);
    final unit = Formatter.unitOfMass(
      user.unitOfMass,
      user.unitOfMassEnum,
    );

    return '$formattedWeights $unit';
  }

  String getSideTiles(double value) {
    final toOriginalNumber = (value / 10 * _weightsLiftedMaxY).round();
    final formatted = NumberFormat.compact().format(toOriginalNumber);
    final unit = Formatter.unitOfMass(
      user.unitOfMass,
      user.unitOfMassEnum,
    );

    return '$formatted $unit';
  }

  void onTouchCallback(BarTouchResponse barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! PointerUpEvent &&
        barTouchResponse.touchInput is! PointerExitEvent) {
      _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
    } else {
      _touchedIndex = -1;
    }
    notifyListeners();
  }
}
