import 'package:workout_player/classes/measurement.dart';
import 'package:workout_player/classes/nutrition.dart';
import 'package:workout_player/classes/routine_history.dart';
import 'package:workout_player/classes/user.dart';

import '../steps.dart';

class ProgressTabClass {
  final User user;
  final List<RoutineHistory> routineHistories;
  final List<Nutrition> nutritions;
  final List<Measurement> measurements;
  final List<RoutineHistory> selectedDayRoutineHistories;
  final List<Nutrition> selectedDayNutritions;
  final Steps? steps;

  const ProgressTabClass({
    required this.user,
    required this.routineHistories,
    required this.nutritions,
    required this.measurements,
    required this.selectedDayRoutineHistories,
    required this.selectedDayNutritions,
    required this.steps,
  });
}
