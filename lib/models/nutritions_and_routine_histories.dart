import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/routine_history.dart';

class NutritionsAndRoutineHistories {
  final List<Nutrition> nutritions;
  final List<RoutineHistory> routineHistories;

  const NutritionsAndRoutineHistories({
    required this.nutritions,
    required this.routineHistories,
  });
}
