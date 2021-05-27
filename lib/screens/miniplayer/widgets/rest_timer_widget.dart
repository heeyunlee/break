import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../../../constants.dart';
import '../provider/workout_miniplayer_provider.dart';

class RestTimerWidget extends ConsumerWidget {
  void _timerOnComplete(
    BuildContext context, {
    required CountDownController countdownController,
    required MiniplayerIndexNotifier miniplayerIndex,
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required List<RoutineWorkout> routineWorkouts,
    required RoutineWorkout routineWorkout,
    required MiniplayerProviderNotifier miniplayerNotifier,
  }) {
    debugPrint('timer completed');
    if (miniplayerIndex.currentIndex <= miniplayerIndex.routineLength) {
      debugPrint('workout set is not last');

      final routineWorkoutLength = routineWorkouts.length - 1;
      final workoutSetLength = routineWorkout.sets!.length - 1;

      miniplayerIndex.incrementCurrentIndex();
      isWorkoutPaused.setBoolean(false);
      // setState(() {
      //   // _isPaused = false;
      //   // currentIndex++;
      // });
      if (miniplayerIndex.workoutSetIndex < workoutSetLength) {
        miniplayerIndex.incrementWorkoutSetIndex();

        // set Workout Set
        // context.read(currentWorkoutSetProvider).state =
        //     routineWorkout.sets![miniplayerIndex.workoutSetIndex];
        // context.read(miniplayerProviderNotifierProvider).currentWorkoutSet =
        //     routineWorkout.sets![miniplayerIndex.workoutSetIndex];
        miniplayerNotifier.setWorkoutSet(
          routineWorkout.sets![miniplayerIndex.workoutSetIndex],
        );

        final workoutSet =
            context.read(miniplayerProviderNotifierProvider).currentWorkoutSet!;
        // if (context.read(currentWorkoutSetProvider).state!.isRest) {
        //   context.read(restTimerDurationProvider).state = Duration(
        //     seconds:
        //         context.read(currentWorkoutSetProvider).state!.restTime ?? 60,
        //   );
        // }
        if (workoutSet.isRest) {
          context.read(restTimerDurationProvider).state = Duration(
            seconds: workoutSet.restTime ?? 60,
          );
        }
      } else {
        if (miniplayerIndex.routineWorkoutIndex < routineWorkoutLength) {
          miniplayerIndex.setWorkoutSetIndex(0);
          miniplayerIndex.incrementRWIndex();

          // set RW
          // context.read(currentRoutineWorkoutProvider).state =
          //     routineWorkouts[miniplayerIndex.routineWorkoutIndex];
          // context
          //         .read(miniplayerProviderNotifierProvider)
          //         .currentRoutineWorkout =
          //     routineWorkouts[miniplayerIndex.workoutSetIndex];
          miniplayerNotifier.setRoutineWorkout(
            routineWorkouts[miniplayerIndex.workoutSetIndex],
          );

          // final newRoutineWorkout =
          //     context.read(currentRoutineWorkoutProvider).state!;
          final newRoutineWorkout = context
              .read(miniplayerProviderNotifierProvider)
              .currentRoutineWorkout!;

          // set Workout Set
          // context.read(currentWorkoutSetProvider).state =
          //     newRoutineWorkout.sets![miniplayerIndex.workoutSetIndex];
          // context.read(miniplayerProviderNotifierProvider).currentWorkoutSet =
          //     newRoutineWorkout.sets![miniplayerIndex.workoutSetIndex];
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
    final miniplayerIndex = watch(miniplayerIndexProvider);
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routineWorkouts = miniplayerProvider.selectedRoutineWorkouts!;
    final routineWorkout = miniplayerProvider.currentRoutineWorkout!;

    final miniplayerNotifier =
        watch(miniplayerProviderNotifierProvider.notifier);

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
                context,
                countdownController: countdownController,
                miniplayerIndex: miniplayerIndex,
                isWorkoutPaused: isWorkoutPaused,
                routineWorkouts: routineWorkouts,
                routineWorkout: routineWorkout,
                miniplayerNotifier: miniplayerNotifier,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
