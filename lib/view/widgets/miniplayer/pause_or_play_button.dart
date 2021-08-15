import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../../view_models/miniplayer_model.dart';

class PauseOrPlayButton extends StatelessWidget {
  final double? iconSize;
  final MiniplayerModel model;

  const PauseOrPlayButton({
    this.iconSize = 56,
    required this.model,
  });

  Future<void> _pausePlay(BuildContext context) async {
    final workoutSet = model.currentWorkoutSet;

    if (workoutSet != null) {
      if (!model.isWorkoutPaused) {
        model.toggleIsWorkoutPaused();
        if (workoutSet.isRest) model.countDownController.pause();
      } else {
        model.toggleIsWorkoutPaused();
        if (workoutSet.isRest) model.countDownController.resume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: -56,
      message: (model.isWorkoutPaused)
          ? S.current.pauseWorkout
          : S.current.resumeWorkout,
      child: IconButton(
        color: Colors.white,
        onPressed: () => _pausePlay(context),
        iconSize: iconSize!,
        icon: (!model.isWorkoutPaused)
            ? Icon(Icons.pause_rounded)
            : Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
