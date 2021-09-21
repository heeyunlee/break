import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/utils/formatter.dart';

final weeklyCaloriesChartModelProvider = ChangeNotifierProvider(
  (ref) => WeeklyCaloriesChartModel(),
);

class WeeklyCaloriesChartModel with ChangeNotifier {
  int? _touchedIndex;
  num _maxY = 2000;

  int? get touchedIndex => _touchedIndex;
  num get maxY => _maxY;
  List<double> get randomListOfYs => [10, 5, 9.7, 8.8, 9, 5, 10];

  String getTooltipText(User user, double y) {
    final amount = (y / 1.05 / 10 * _maxY).round();
    final formattedWeights = Formatter.numWithDecimal(amount);
    final unit = Formatter.unitOfMassGram(
      user.unitOfMass,
      user.unitOfMassEnum,
    );

    return '$formattedWeights $unit';
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
