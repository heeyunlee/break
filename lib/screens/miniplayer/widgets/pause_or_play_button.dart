import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';

import '../provider/workout_miniplayer_provider.dart';

class PauseOrPlayButton extends ConsumerWidget {
  final double? iconSize;

  const PauseOrPlayButton({
    this.iconSize = 56,
  });

  Future<void> _pausePlay(
    BuildContext context,
    ScopedReader watch, {
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required CountDownController circularCountDownController,
  }) async {
    // final workoutSet = watch(currentWorkoutSetProvider).state;
    final workoutSet =
        watch(miniplayerProviderNotifierProvider).currentWorkoutSet;

    if (workoutSet != null) {
      if (!isWorkoutPaused.isWorkoutPaused) {
        isWorkoutPaused.toggleBoolValue();
        if (workoutSet.isRest) circularCountDownController.pause();
      } else {
        isWorkoutPaused.toggleBoolValue();
        if (workoutSet.isRest) circularCountDownController.resume();
      }
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final circularCountdownController =
        watch(miniplayerTimerControllerProvider).state;

    return Tooltip(
      verticalOffset: -56,
      message: (isWorkoutPaused.isWorkoutPaused)
          ? S.current.pauseWorkout
          : S.current.resumeWorkout,
      child: IconButton(
        color: Colors.white,
        onPressed: () => _pausePlay(
          context,
          watch,
          isWorkoutPaused: isWorkoutPaused,
          circularCountDownController: circularCountdownController,
        ),
        iconSize: iconSize!,
        icon: (!isWorkoutPaused.isWorkoutPaused)
            ? Icon(Icons.pause_rounded)
            : Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
