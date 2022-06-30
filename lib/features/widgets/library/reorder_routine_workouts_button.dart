import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/features/screens/reorder_routine_workouts_screen.dart';
import 'package:workout_player/styles/text_styles.dart';

class ReorderRoutineWorkoutsButton extends StatelessWidget {
  final Routine routine;
  final List<RoutineWorkout?> list;

  const ReorderRoutineWorkoutsButton({
    Key? key,
    required this.routine,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ReorderRoutineWorkoutsScreen.show(
        context,
        routine: routine,
        routineWorkouts: list,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.current.editRoutineWorkoutOrder,
              style: TextStyles.body2Grey,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.reorder_rounded,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
