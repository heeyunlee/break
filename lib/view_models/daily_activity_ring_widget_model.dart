import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/utils/formatter.dart';

final dailyActivityRingWidgetModelProvider = ChangeNotifierProvider(
  (ref) => DailyActivityRingWidgetModel(),
);

class DailyActivityRingWidgetModel with ChangeNotifier {
  num _nutritionDailyGoal = 150;
  num _nutritionDailyTotal = 0;
  double _nutritionDailyProgress = 0.0;
  num _liftingDailyGoal = 10000;
  num _weightsLiftedDailyTotal = 0;
  double _weightsLiftedDailyProgress = 0.0;
  String _todaysMuscleWorked = '-';

  num get nutritionDailyGoal => _nutritionDailyGoal;
  num get nutritionDailyTotal => _nutritionDailyTotal;
  double get nutritionDailyProgress => _nutritionDailyProgress;
  num get liftingDailyGoal => _liftingDailyGoal;
  num get weightsLiftedDailyTotal => _weightsLiftedDailyTotal;
  double get weightsLiftedDailyProgress => _weightsLiftedDailyProgress;
  String get todaysMuscleWorked => _todaysMuscleWorked;

  void setDailyGoal(User user) {
    _nutritionDailyGoal = user.dailyProteinGoal ?? 150.0;
    _liftingDailyGoal = user.dailyWeightsGoal ?? 10000;
  }

  void setDailyTotal(
    List<Nutrition> nutritions,
    List<RoutineHistory> routineHistories,
  ) {
    _nutritionDailyTotal = 0;
    _nutritionDailyProgress = 0;
    _weightsLiftedDailyTotal = 0;
    _weightsLiftedDailyProgress = 0;
    _todaysMuscleWorked = '-';

    if (nutritions.isNotEmpty) {
      nutritions.forEach((e) {
        _nutritionDailyTotal += e.proteinAmount.toInt();
      });
      _nutritionDailyProgress = _nutritionDailyTotal / _nutritionDailyGoal;

      if (_nutritionDailyProgress >= 1) {
        _nutritionDailyProgress = 1;
      }
    }

    if (routineHistories.isNotEmpty) {
      routineHistories.forEach((e) {
        _weightsLiftedDailyTotal += e.totalWeights.toInt();
      });

      _weightsLiftedDailyProgress =
          _weightsLiftedDailyTotal / _liftingDailyGoal;

      if (_weightsLiftedDailyProgress >= 1) {
        _weightsLiftedDailyProgress = 1;
      }

      final latest = routineHistories.last;

      _todaysMuscleWorked = Formatter.getFirstMainMuscleGroup(
        latest.mainMuscleGroup,
        latest.mainMuscleGroupEnum,
      );
    }
  }
}
