import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../workout_miniplayer_provider.dart';

class RestTimerWidget extends ConsumerWidget {
  void _timerOnComplete(
    BuildContext context,
    ScopedReader watch, {
    required CountDownController countdownController,
    // required MiniplayerIndexNotifier miniplayerIndex,
    // required IsWorkoutPausedNotifier isWorkoutPaused,
    // required List<RoutineWorkout?> routineWorkouts,
    // required RoutineWorkout routineWorkout,
    // required MiniplayerProviderNotifier miniplayerNotifier,
  }) {
    debugPrint('timer completed');

    final miniplayerIndex = watch(miniplayerIndexProvider);
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final isWorkoutPaused = watch(isWorkoutPausedProvider);

    if (miniplayerIndex.currentIndex <= miniplayerIndex.routineLength) {
      final miniplayerNotifier = watch(
        miniplayerProviderNotifierProvider.notifier,
      );

      // Find length of routine workout
      final routineWorkouts = miniplayerProvider.selectedRoutineWorkouts!;
      final routineWorkoutLength = routineWorkouts.length - 1;

      // Find length of workout set
      final routineWorkout = miniplayerProvider.currentRoutineWorkout!;
      final workoutSetLength = routineWorkout.sets!.length - 1;

      miniplayerIndex.incrementCurrentIndex();
      isWorkoutPaused.setBoolean(false);

      // If workout set is NOT last
      if (miniplayerIndex.workoutSetIndex < workoutSetLength) {
        miniplayerIndex.incrementWorkoutSetIndex();

        miniplayerNotifier.setWorkoutSet(
          routineWorkout.sets![miniplayerIndex.workoutSetIndex],
        );

        final workoutSet =
            context.read(miniplayerProviderNotifierProvider).currentWorkoutSet!;

        if (workoutSet.isRest) {
          context.read(restTimerDurationProvider).state = Duration(
            seconds: workoutSet.restTime ?? 60,
          );
        }
      } else {
        // If workout set is LAST && Routine Workout is NOT last
        if (miniplayerIndex.routineWorkoutIndex < routineWorkoutLength) {
          miniplayerIndex.setWorkoutSetIndex(0);
          miniplayerIndex.incrementRWIndex();

          miniplayerNotifier.setRoutineWorkout(
            routineWorkouts[miniplayerIndex.routineWorkoutIndex],
          );

          final newRoutineWorkout = context
              .read(miniplayerProviderNotifierProvider)
              .currentRoutineWorkout!;

          miniplayerNotifier.setWorkoutSet(
            newRoutineWorkout.sets![miniplayerIndex.workoutSetIndex],
          );

          final workoutSet = context
              .read(miniplayerProviderNotifierProvider)
              .currentWorkoutSet!;

          if (workoutSet.isRest) {
            context.read(restTimerDurationProvider).state = Duration(
              seconds: workoutSet.restTime ?? 60,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final countdownController = watch(miniplayerTimerControllerProvider).state;
    final timer = watch(restTimerDurationProvider).state;
    // final miniplayerIndex = watch(miniplayerIndexProvider);
    // final isWorkoutPaused = watch(isWorkoutPausedProvider);
    // final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    // final routineWorkouts = miniplayerProvider.selectedRoutineWorkouts!;
    // final routineWorkout = miniplayerProvider.currentRoutineWorkout!;

    // final miniplayerNotifier =
    //     watch(miniplayerProviderNotifierProvider.notifier);

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: Container(
          width: size.width - 56,
          height: size.width - 56,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CircularCountDownTimer(
              textStyle: kHeadline2,
              controller: countdownController,
              width: 280,
              height: 280,
              duration: timer!.inSeconds,
              fillColor: Colors.grey[600]!,
              ringColor: Colors.red,
              isReverse: true,
              strokeWidth: 8,
              onComplete: () => _timerOnComplete(
                context, watch,
                countdownController: countdownController,
                // miniplayerIndex: miniplayerIndex,
                // isWorkoutPaused: isWorkoutPaused,
                // routineWorkouts: routineWorkouts,
                // routineWorkout: routineWorkout,
                // miniplayerNotifier: miniplayerNotifier,
              ),
            ),
          ),
        ),
      ),
    );
  }
}