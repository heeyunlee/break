import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/workout_set.dart';

import '../provider/workout_miniplayer_provider.dart';

class PauseOrPlayButton extends ConsumerWidget {
  final double iconSize;

  const PauseOrPlayButton({
    this.iconSize = 56,
  });

  Future<void> _pausePlay({
    required WorkoutSet workoutSet,
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required CountDownController countDownController,
  }) async {
    if (!isWorkoutPaused.isWorkoutPaused) {
      isWorkoutPaused.toggleBoolValue();
      if (workoutSet.isRest) countDownController.pause();
    } else {
      isWorkoutPaused.toggleBoolValue();
      if (workoutSet.isRest) countDownController.resume();
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final countdownController = watch(miniplayerTimerControllerProvider).state;
    final workoutSet = watch(currentWorkoutSetProvider).state!;

    return Tooltip(
      verticalOffset: -56,
      message: (isWorkoutPaused.isWorkoutPaused)
          ? S.current.pauseWorkout
          : S.current.resumeWorkout,
      child: IconButton(
        color: Colors.white,
        onPressed: () => _pausePlay(
          workoutSet: workoutSet,
          isWorkoutPaused: isWorkoutPaused,
          countDownController: countdownController,
        ),
        iconSize: iconSize,
        icon: (!isWorkoutPaused.isWorkoutPaused)
            ? Icon(Icons.pause_rounded)
            : Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
