import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../../../../view_models/miniplayer_model.dart';

class NextWorkoutSetButton extends StatelessWidget {
  final double? iconSize;
  final MiniplayerModel model;

  const NextWorkoutSetButton({
    this.iconSize = 48,
    required this.model,
  });
  void _skipNext(
    BuildContext context, {
    required RoutineWorkout routineWorkout,
  }) {
    // set isWorkoutPaused false
    model.setIsWorkoutPaused(false);

    // increase current index by 1
    model.incrementCurrentIndex();

    // workout set Index by 1
    model.incrementWorkoutSetIndex();

    // set Workout Set
    model.setWorkoutSet(routineWorkout.sets[model.workoutSetIndex]);

    model.setRestTime(
      Duration(seconds: model.currentWorkoutSet!.restTime ?? 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routineWorkout = model.currentRoutineWorkout!;
    final workoutSet = model.currentWorkoutSet;

    final isLastSet = (workoutSet != null)
        ? model.workoutSetIndex == routineWorkout.sets.length - 1
        : true;

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toNextSet,
      child: IconButton(
        iconSize: iconSize!,
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(Icons.skip_next_rounded),
        onPressed: (isLastSet)
            ? null
            : () => _skipNext(
                  context,
                  routineWorkout: routineWorkout,
                ),
      ),
    );
  }
}
