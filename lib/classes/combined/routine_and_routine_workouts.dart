import '../routine.dart';
import '../routine_workout.dart';

class RoutineAndRoutineWorkouts {
  final Routine? routine;
  final List<RoutineWorkout>? routineWorkouts;

  const RoutineAndRoutineWorkouts({
    required this.routine,
    required this.routineWorkouts,
  });
}
