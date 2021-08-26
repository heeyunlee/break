import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/measurement.dart';

final weeklyMeasurementsChartModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyMeasurementsChartModel(),
);

class WeeklyMeasurementsChartModel with ChangeNotifier {
  final DateTime _now = DateTime.now();
  double _maxY = 80;
  double _minY = 70;
  double _horizontalInterval = 5;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<Measurement?> _thisWeekData = [];

  DateTime get now => _now;
  double get maxY => _maxY;
  double get minY => _minY;
  double get horizontalInterval => _horizontalInterval;
  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  List<Measurement?> get thisWeekData => _thisWeekData;

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

  //  SET MAX Y
  Future<void> setMaxY(List<Measurement> measurements) async {
    final List<Measurement?> _thisWeekDataS = [];

    if (measurements.isNotEmpty) {
      for (final date in _dates) {
        final measurement = measurements.lastWhereOrNull(
          (element) => element.loggedDate.toUtc() == date,
        );
        if (measurement != null) {
          _thisWeekDataS.add(measurement);
        }
      }

      _thisWeekData = _thisWeekDataS;

      final largest = measurements
          .map<double>((e) => e.bodyWeight!.toDouble())
          .reduce(math.max);

      final lowest = measurements
          .map<double>((e) => e.bodyWeight!.toDouble())
          .reduce(math.min);

      final roundedLargest = (largest / 10).ceil() * 10;
      final roundedLowest = lowest ~/ 10 * 10;
      _maxY = roundedLargest.toDouble();
      _minY = roundedLowest.toDouble();

      if (maxY == minY) {
        _maxY = minY + 10;
        _minY = minY - 10;
        _horizontalInterval = 5;
      } else {
        _horizontalInterval = (maxY - minY) / 4;
      }
    } else {
      _thisWeekData = _thisWeekDataS;
    }
  }

  double? flipNumber(double number) {
    switch (number.toInt()) {
      case 6:
        return 0.toDouble();
      case 5:
        return 1.toDouble();
      case 4:
        return 2.toDouble();
      case 3:
        return 3.toDouble();
      case 2:
        return 4.toDouble();
      case 1:
        return 5.toDouble();
      case 0:
        return 6.toDouble();
    }
  }
}
