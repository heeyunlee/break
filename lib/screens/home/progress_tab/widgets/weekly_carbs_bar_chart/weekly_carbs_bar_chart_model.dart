import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/classes/combined/progress_tab_class.dart';
import 'package:workout_player/classes/nutrition.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/classes/enum/unit_of_mass.dart';

final weeklyCarbsBarChartModelProvider =
    ChangeNotifierProvider.family<WeeklyCarbsBarChartModel, ProgressTabClass>(
  (ref, data) => WeeklyCarbsBarChartModel(
    nutritions: data.nutritions,
    user: data.user,
  ),
);

class WeeklyCarbsBarChartModel with ChangeNotifier {
  final List<Nutrition> nutritions;
  final User user;

  WeeklyCarbsBarChartModel({
    required this.nutritions,
    required this.user,
  });

  num _carbsMaxY = 200;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<double> _relativeYs = [];
  int? _touchedIndex;
  double? _interval = 1;
  bool _goalExists = false;

  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<double> get relativeYs => _relativeYs;
  int? get touchedIndex => _touchedIndex;
  double? get interval => _interval;
  bool get goalExists => _goalExists;
  List<double> get randomListOfYs => [6.5, 10, 5.3, 10, 2, 5, 8.2];

  void init() {
    logger.d('init in nutritionChart called');

    /// INIT Dates
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

    /// INIT Relative Ys
    Map<DateTime, List<Nutrition>> _mapData;
    List<num> _listOfYs = [];
    List<double> _relatives = [];

    List<Nutrition> carbsList =
        nutritions.where((e) => e.carbs != null).toList();

    if (carbsList.isNotEmpty) {
      _mapData = {
        for (var item in _dates)
          item: carbsList.where((e) => e.loggedDate.toUtc() == item).toList()
      };

      _mapData.values.forEach((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          list.forEach((nutrition) {
            sum += nutrition.carbs!;
          });
        }

        _listOfYs.add(sum);
      });
      final largest =
          [..._listOfYs, user.dailyProteinGoal ?? 0].reduce(math.max);

      if (largest == 0) {
        _carbsMaxY = 200;

        _listOfYs.forEach((element) {
          _relatives.add(0);
        });
      } else {
        final roundedLargest = (largest / 10).ceil() * 10;

        _carbsMaxY = roundedLargest.toDouble() + 10;

        _listOfYs.forEach((element) {
          _relatives.add(element / _carbsMaxY * 10);
        });
      }
      _relativeYs = _relatives;

      // /// Set Interval
      // if (user.dailyProteinGoal != null) {
      //   _interval = user.dailyProteinGoal! / _carbsMaxY * 10;
      // } else {
      //   _interval = 1.00;
      // }
    } else {
      _relativeYs = [];
    }

    _goalExists = false;
  }

  String getTooltipText(double y) {
    final amount = (y / 1.05 / 10 * _carbsMaxY).round();
    final formattedWeights = Formatter.proteins(amount);
    final unit = (user.unitOfMassEnum != null)
        ? user.unitOfMassEnum!.gram
        : Formatter.unitOfMassGram(user.unitOfMass);

    return '$formattedWeights $unit';
  }

  String getSideTiles(double value) {
    final toOriginalNumber = (value / 10 * _carbsMaxY).round();
    final unit = (user.unitOfMassEnum != null)
        ? user.unitOfMassEnum!.gram
        : Formatter.unitOfMass(user.unitOfMass);

    return '$toOriginalNumber $unit';
  }

  void onTouchCallback(BarTouchResponse barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! PointerExitEvent &&
        barTouchResponse.touchInput is! PointerUpEvent) {
      _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
    } else {
      _touchedIndex = -1;
    }

    notifyListeners();
  }
}
