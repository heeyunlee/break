import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/workout_set.dart';

import '../workout_miniplayer_provider.dart';

class PauseOrPlayButton extends ConsumerWidget {
  Future<void> _pausePlay({
    required WorkoutSet workoutSet,
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required CountDownController countDownController,
  }) async {
    if (!isWorkoutPaused.isWorkoutPaused) {
      isWorkoutPaused.toggleBoolValue();
      if (workoutSet.isRest) countDownController.pause();
      // boolChangeNotifier.toggleBoolValue();
      // await _animationController.forward();
      // if (workoutSet.isRest) _countDownController.pause();
      // setState(() {
      //   _isPaused = !_isPaused;

      //   context.read(isWorkoutPausedProvider).state =
      //       !context.read(isWorkoutPausedProvider).state;
      //   // debugPrint('_isPaused is $_isPaused');
      // });
    } else {
      isWorkoutPaused.toggleBoolValue();
      if (workoutSet.isRest) countDownController.resume();
      // boolChangeNotifier.toggleBoolValue();
      // await _animationController.reverse();
      // if (workoutSet.isRest) _countDownController.resume();
      // setState(() {
      //   _isPaused = !_isPaused;
      //   // debugPrint('_isPaused is $_isPaused');
      // });
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
        iconSize: 56,
        icon: (!isWorkoutPaused.isWorkoutPaused)
            ? Icon(Icons.pause_rounded)
            : Icon(Icons.play_arrow_rounded),

        // icon: Container(
        //   child: AnimatedIcon(
        //     size: size.height * 0.06,
        //     color: Colors.white,
        //     icon: AnimatedIcons.pause_play,
        //     progress: _animationController,
        //   ),
        // ),
      ),
    );
  }
}
