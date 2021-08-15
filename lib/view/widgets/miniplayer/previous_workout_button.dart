import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../../view_models/miniplayer_model.dart';

class PreviousWorkoutButton extends StatelessWidget {
  final MiniplayerModel model;

  const PreviousWorkoutButton({Key? key, required this.model})
      : super(key: key);

  Future<void> _previousWorkout(BuildContext context) async {
    final routineWorkouts = model.selectedRoutineWorkouts!;

    // set isWorkoutPaused to false
    model.setIsWorkoutPaused(false);

    // new index = currentIndex - workoutIndex - workoutSetLength
    final workoutSetLength = model.currentIndex -
        model.workoutSetIndex -
        routineWorkouts[model.routineWorkoutIndex - 1]!.sets.length;

    // set current index
    model.setCurrentIndex(workoutSetLength);

    // set Workout Set Index
    model.setWorkoutSetIndex(0);

    // set RW Index
    model.decrementRoutineWorkoutIndex();

    // set Routine Workout
    model.setRoutineWorkout(
      routineWorkouts[model.routineWorkoutIndex],
    );

    // set Workout Set
    final routineWorkout = model.currentRoutineWorkout!;

    if (routineWorkout.sets.isNotEmpty) {
      model.setWorkoutSet(routineWorkout.sets[model.workoutSetIndex]);

      final workoutSet = model.currentWorkoutSet!;

      // set Duration
      if (workoutSet.isRest) {
        model.setRestTime(Duration(seconds: workoutSet.restTime ?? 0));
      }
    } else {
      model.setMiniplayerValues(workoutSet: null);
      model.setRestTime(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousWorkout,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(CupertinoIcons.backward_end_alt_fill),
        onPressed: (model.routineWorkoutIndex == 0)
            ? null
            : () => _previousWorkout(context),
      ),
    );
  }
}
