import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';

import '../provider/workout_miniplayer_provider.dart';

class PreviousWorkoutButton extends ConsumerWidget {
  Future<void> _previousWorkout(
    BuildContext context,
    ScopedReader watch, {
    required MiniplayerIndexNotifier miniplayerIndex,
  }) async {
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);

    final routineWorkouts = miniplayerProvider.selectedRoutineWorkouts!;

    final miniplayerNotifier =
        watch(miniplayerProviderNotifierProvider.notifier);

    // set isWorkoutPaused to false
    isWorkoutPaused.setBoolean(false);

    // new index = currentIndex - workoutIndex - workoutSetLength
    final workoutSetLength = miniplayerIndex.currentIndex -
        miniplayerIndex.workoutSetIndex -
        routineWorkouts[miniplayerIndex.routineWorkoutIndex - 1]!.sets!.length;

    // set current index
    miniplayerIndex.setCurrentIndex(workoutSetLength);

    // set Workout Set Index
    miniplayerIndex.setWorkoutSetIndex(0);

    // set RW Index
    miniplayerIndex.decrementRWIndex();

    // set Routine Workout
    miniplayerNotifier.setRoutineWorkout(
      routineWorkouts[miniplayerIndex.routineWorkoutIndex],
    );

    // set Workout Set
    final routineWorkout =
        context.read(miniplayerProviderNotifierProvider).currentRoutineWorkout!;

    if (routineWorkout.sets!.isNotEmpty) {
      miniplayerNotifier.setWorkoutSet(
        routineWorkout.sets![miniplayerIndex.workoutSetIndex],
      );

      final workoutSet =
          context.read(miniplayerProviderNotifierProvider).currentWorkoutSet!;

      // set Duration
      if (workoutSet.isRest) {
        context.read(restTimerDurationProvider).state = Duration(
          seconds: workoutSet.restTime ?? 0,
        );
      }
    } else {
      miniplayerNotifier.initiate(workoutSet: null);
      context.read(restTimerDurationProvider).state = null;
    }

    print('current Index is ${miniplayerIndex.currentIndex}');
    print('routineWorkout Index is ${miniplayerIndex.routineWorkoutIndex}');
    print('Workout Set Index is ${miniplayerIndex.workoutSetIndex}');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerIndex = watch(miniplayerIndexProvider);

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
                  watch,
                  miniplayerIndex: miniplayerIndex,
                ),
      ),
    );
  }
}
