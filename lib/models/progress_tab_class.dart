import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';

class ProgressTabClass {
  final User user;
  final List<RoutineHistory> routineHistories;
  final List<Nutrition> nutritions;
  final List<Measurement> measurements;
  final List<RoutineHistory> selectedDayRoutineHistories;
  final List<Nutrition> selectedDayNutritions;

  const ProgressTabClass({
    required this.user,
    required this.routineHistories,
    required this.nutritions,
    required this.measurements,
    required this.selectedDayRoutineHistories,
    required this.selectedDayNutritions,
  });
}
