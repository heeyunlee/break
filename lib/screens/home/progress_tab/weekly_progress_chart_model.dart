import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final weeklyProgressChartModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyProgressChartModel(),
);

class WeeklyProgressChartModel extends ChangeNotifier {
  // num _nutritionMaxY = 150;
  num _weightsChartMaxY = 20000;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  // List<double> _relativeList = [];

  // num get nutritionMaxY => _nutritionMaxY;
  num get weightsChartMaxY => _weightsChartMaxY;
  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  // List<double> get relativeList => _relativeList;

  void setDaysOfTheWeek() {
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

  // void setNutritionMaxY(num value) {
  //   _nutritionMaxY = value;
  // }

  void setWeightsChartMaxY(num value) {
    _weightsChartMaxY = value;
  }

  // Future<void> setRelativeList(List<Nutrition>? list) async {
  //   Map<DateTime, List<Nutrition>> _mapData;
  //   List<num> listOfYs = [];
  //   if (list != null) {
  //     _mapData = {
  //       for (var item in _dates)
  //         item: list.where((e) => e.loggedDate.toUtc() == item).toList()
  //     };

  //     _mapData.values.forEach((list) {
  //       num sum = 0;

  //       if (list.isNotEmpty) {
  //         list.forEach((nutrition) {
  //           sum += nutrition.proteinAmount;
  //         });
  //       }

  //       listOfYs.add(sum);
  //     });
  //     final largest = listOfYs.reduce(math.max);

  //     if (largest == 0) {
  //       // _maxY = 150;
  //       // setMaxY(150);
  //       _maxY = 150;

  //       listOfYs.forEach((element) {
  //         _relativeList.add(0);
  //       });
  //     } else {
  //       final roundedLargest = (largest / 10).ceil() * 10;
  //       if (roundedLargest < 150) {
  //         _maxY = 160;
  //       } else {
  //         _maxY = roundedLargest.toDouble();
  //       }
  //       // model.setMaxY(roundedLargest.toDouble());
  //       // _maxY = roundedLargest.toDouble();
  //       listOfYs.forEach((element) {
  //         _relativeList.add(element / _maxY * 10);
  //       });
  //     }
  //   }
  //   print(_maxY);
  //   // notifyListeners();
  // }
}
