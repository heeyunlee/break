import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../../../../view_models/miniplayer_model.dart';

class NextWRoutineorkoutButton extends StatelessWidget {
  final MiniplayerModel model;

  const NextWRoutineorkoutButton({Key? key, required this.model})
      : super(key: key);

  void _skipRoutineWorkout(
    BuildContext context, {
    required List<RoutineWorkout?> routineWorkouts,
  }) {
    final routineWorkout = model.currentRoutineWorkout!;

    if (model.currentIndex < model.setsLength) {
      final workoutSetLength = routineWorkout.sets.length - 1;
      model.setCurrentIndex(
          model.currentIndex - model.workoutSetIndex + workoutSetLength + 1);
    }

    // set workout index to 0
    model.setWorkoutSetIndex(0);

    // increase RW Index by 1
    model.incrementRoutineWorkoutIndex();

    // set is Workout Paused to false
    model.setIsWorkoutPaused(false);

    model.setRoutineWorkout(routineWorkouts[model.routineWorkoutIndex]);

    // sets from new Routine Workout
    final sets = model.currentRoutineWorkout!.sets;

    if (sets.isNotEmpty) {
      model.setWorkoutSet(sets[0]);

      final currentWorkoutSet = model.currentWorkoutSet!;

      if (currentWorkoutSet.isRest) {
        model.setRestTime(Duration(
          seconds: currentWorkoutSet.restTime ?? 90,
        ));
      } else {
        model.setRestTime(null);
      }
    } else {
      model.setWorkoutSet(null);
      model.setRestTime(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineWorkouts = model.selectedRoutineWorkouts!;
    final isLastRoutineWorkout =
        model.routineWorkoutIndex == routineWorkouts.length - 1;

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousWorkout,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(CupertinoIcons.forward_end_alt_fill),
        onPressed: (isLastRoutineWorkout)
            ? null
            : () => _skipRoutineWorkout(
                  context,
                  routineWorkouts: routineWorkouts,
                ),
      ),
    );
  }
}
