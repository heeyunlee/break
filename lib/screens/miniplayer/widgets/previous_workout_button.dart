import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../provider/workout_miniplayer_provider.dart';

class PreviousWorkoutButton extends ConsumerWidget {
  Future<void> _previousWorkout(
    BuildContext context, {
    required List<RoutineWorkout> routineWorkouts,
    required RoutineWorkout routineWorkout,
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required MiniplayerIndexNotifier miniplayerIndex,
    required MiniplayerProviderNotifier miniplayerNotifier,
  }) async {
    // set isWorkoutPaused to false
    isWorkoutPaused.setBoolean(false);

    // new index = currentIndex - workoutIndex - workoutSetLength
    final workoutSetLength = miniplayerIndex.currentIndex -
        miniplayerIndex.workoutSetIndex -
        routineWorkouts[miniplayerIndex.routineWorkoutIndex - 1].sets!.length;

    // set current index
    miniplayerIndex.setCurrentIndex(workoutSetLength);

    // set Workout Set Index
    miniplayerIndex.setWorkoutSetIndex(0);

    // set RW Index
    miniplayerIndex.decrementRWIndex();

    // set Routine Workout
    // context.read(currentRoutineWorkoutProvider).state =
    //     routineWorkouts[miniplayerIndex.routineWorkoutIndex];
    // context.read(miniplayerProviderNotifierProvider).currentRoutineWorkout =
    //     routineWorkouts[miniplayerIndex.routineWorkoutIndex];
    miniplayerNotifier.setRoutineWorkout(
      routineWorkouts[miniplayerIndex.routineWorkoutIndex],
    );

    // set Workout Set
    final routineWorkout =
        context.read(miniplayerProviderNotifierProvider).currentRoutineWorkout!;

    if (routineWorkout.sets!.isNotEmpty) {
      // context.read(miniplayerProviderNotifierProvider).currentWorkoutSet =
      //     routineWorkout.sets![miniplayerIndex.workoutSetIndex];
      miniplayerNotifier.setWorkoutSet(
        routineWorkout.sets![miniplayerIndex.workoutSetIndex],
      );

      // context.read(currentWorkoutSetProvider).state = context
      //     .read(currentRoutineWorkoutProvider)
      //     .state!
      //     .sets![miniplayerIndex.workoutSetIndex];

      final workoutSet =
          context.read(miniplayerProviderNotifierProvider).currentWorkoutSet!;

      // set Duration
      if (workoutSet.isRest) {
        context.read(restTimerDurationProvider).state = Duration(
          // seconds: context.read(currentWorkoutSetProvider).state!.restTime ?? 0,
          seconds: workoutSet.restTime ?? 0,
        );
      }
    } else {
      // context.read(currentWorkoutSetProvider).state = null;
      // context.read(miniplayerProviderNotifierProvider).currentWorkoutSet = null;
      // context.read(restTimerDurationProvider).state = null;
      miniplayerNotifier.initiate(workoutSet: null);
      context.read(restTimerDurationProvider).state = null;
    }

    print('current Index is ${miniplayerIndex.currentIndex}');
    print('routineWorkout Index is ${miniplayerIndex.routineWorkoutIndex}');
    print('Workout Set Index is ${miniplayerIndex.workoutSetIndex}');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final routineWorkouts = context
        .read(miniplayerProviderNotifierProvider)
        .selectedRoutineWorkouts;

    final routineWorkout =
        context.read(miniplayerProviderNotifierProvider).currentRoutineWorkout;
    // final routineWorkouts = context.read(selectedRoutineWorkoutsProvider).state;
    // final routineWorkout = context.read(currentRoutineWorkoutProvider).state;
    final isWorkoutPaused = context.read(isWorkoutPausedProvider);
    final miniplayerIndex = context.read(miniplayerIndexProvider);

    final miniplayerNotifier =
        watch(miniplayerProviderNotifierProvider.notifier);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousWorkout,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(CupertinoIcons.backward_end_alt_fill),
        onPressed: (miniplayerIndex.routineWorkoutIndex == 0)
            ? null
            : () => _previousWorkout(
                  context,
                  routineWorkouts: routineWorkouts!,
                  routineWorkout: routineWorkout!,
                  isWorkoutPaused: isWorkoutPaused,
                  miniplayerIndex: miniplayerIndex,
                  miniplayerNotifier: miniplayerNotifier,
                ),
      ),
    );
  }
}
