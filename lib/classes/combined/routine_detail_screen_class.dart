import '../routine.dart';
import '../routine_workout.dart';
import '../user.dart';

class RoutineDetailScreenClass {
  final User? user;
  final Routine? routine;
  final List<RoutineWorkout>? routineWorkouts;

  const RoutineDetailScreenClass({
    required this.user,
    required this.routine,
    required this.routineWorkouts,
  });
}
