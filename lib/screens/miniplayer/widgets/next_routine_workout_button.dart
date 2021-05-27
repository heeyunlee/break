import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../provider/workout_miniplayer_provider.dart';

class NextWRoutineorkoutButton extends ConsumerWidget {
  void _skipRoutineWorkout(
    BuildContext context,
    ScopedReader watch, {
    required List<RoutineWorkout> routineWorkouts,
    // required RoutineWorkout routineWorkout,
    required MiniplayerIndexNotifier miniplayerIndex,
    // required IsWorkoutPausedNotifier isWorkoutPaused,
    // required MiniplayerProviderNotifier miniplayerNotifier,
  }) {
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routineWorkout = miniplayerProvider.currentRoutineWorkout!;
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final miniplayerNotifier =
        watch(miniplayerProviderNotifierProvider.notifier);

    // new Index = current index - workout set index + set.length
    if (miniplayerIndex.currentIndex < miniplayerIndex.routineLength) {
      final workoutSetLength = routineWorkout.sets!.length - 1;
      miniplayerIndex.setCurrentIndex(miniplayerIndex.currentIndex -
          miniplayerIndex.workoutSetIndex +
          workoutSetLength +
          1);
    }

    // set workout index to 0
    miniplayerIndex.setWorkoutSetIndex(0);
    // increase RW Index by 1
    miniplayerIndex.incrementRWIndex();
    // set is Workout Paused to false
    isWorkoutPaused.setBoolean(false);

    miniplayerNotifier.setRoutineWorkout(
        routineWorkouts[miniplayerIndex.routineWorkoutIndex]);

    // sets from new Routine Workout
    final sets = context
        .read(miniplayerProviderNotifierProvider)
        .currentRoutineWorkout!
        .sets!;

    if (sets.isNotEmpty) {
      miniplayerNotifier.setWorkoutSet(sets[0]);

      final currentWorkoutSet =
          context.read(miniplayerProviderNotifierProvider).currentWorkoutSet!;
      if (currentWorkoutSet.isRest) {
        context.read(restTimerDurationProvider).state = Duration(
          seconds: currentWorkoutSet.restTime ?? 90,
        );
      } else {
        context.read(restTimerDurationProvider).state = Duration();
      }
    } else {
      miniplayerNotifier.setWorkoutSet(null);
      context.read(restTimerDurationProvider).state = Duration();
    }

    debugPrint('current Index is ${miniplayerIndex.currentIndex}');
    debugPrint(
        'routineWorkout Index is ${miniplayerIndex.routineWorkoutIndex}');
    debugPrint('Workout Set Index is ${miniplayerIndex.workoutSetIndex}');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routineWorkouts = miniplayerProvider.selectedRoutineWorkouts!;
    // final routineWorkout = miniplayerProvider.currentRoutineWorkout!;
    // final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final miniplayerIndex = watch(miniplayerIndexProvider);
    // final miniplayerNotifier =
    //     watch(miniplayerProviderNotifierProvider.notifier);
    final isLastRoutineWorkout =
        miniplayerIndex.routineWorkoutIndex == routineWorkouts.length - 1;

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousWorkout,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(CupertinoIcons.forward_end_alt_fill),
        onPressed: (isLastRoutineWorkout)
            ? null
            : () => _skipRoutineWorkout(
                  context, watch,
                  routineWorkouts: routineWorkouts,
                  // routineWorkout: routineWorkout,
                  // isWorkoutPaused: isWorkoutPaused,
                  miniplayerIndex: miniplayerIndex,
                  // miniplayerNotifier: miniplayerNotifier,
                ),
      ),
    );
  }
}
