import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../miniplayer_model.dart';

class PreviousWorkoutSetButton extends StatelessWidget {
  final MiniplayerModel model;

  const PreviousWorkoutSetButton({Key? key, required this.model})
      : super(key: key);

  Future<void> _skipPrevious(
    BuildContext context,
    MiniplayerModel model,
  ) async {
    final routineWorkout = model.currentRoutineWorkout!;

    // set isWorkoutPaused to false
    model.setIsWorkoutPaused(false);

    // decrease current index by 1
    model.decrementCurrentIndex();

    model.decrementWorkoutSetIndex();

    model.setWorkoutSet(
      routineWorkout.sets[model.workoutSetIndex],
    );

    model.setRestTime(
      Duration(seconds: model.currentWorkoutSet!.restTime ?? 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousSet,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        iconSize: 48,
        icon: Icon(Icons.skip_previous_rounded),
        onPressed: (model.currentIndex > 1 && model.workoutSetIndex != 0)
            ? () => _skipPrevious(context, model)
            : null,
      ),
    );
  }
}
