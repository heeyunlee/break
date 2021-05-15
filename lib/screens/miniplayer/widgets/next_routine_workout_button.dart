import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../workout_miniplayer_provider.dart';

class NextWRoutineorkoutButton extends ConsumerWidget {
  void _skipRoutineWorkout(
    BuildContext context, {
    required List<RoutineWorkout> routineWorkouts,
    required RoutineWorkout routineWorkout,
    required MiniplayerIndexNotifier miniplayerIndex,
    required IsWorkoutPausedNotifier isWorkoutPaused,
  }) {
    // new Index = current index - workout set index + set.length
    final workoutSetLength = routineWorkout.sets!.length - 1;
    miniplayerIndex.setCurrentIndex(miniplayerIndex.currentIndex -
        miniplayerIndex.workoutSetIndex +
        workoutSetLength +
        1);

    // set workout index to 0
    miniplayerIndex.setWorkoutSetIndex(0);
    // increase RW Index by 1
    miniplayerIndex.incrementRWIndex();
    // set is Workout Paused to false
    isWorkoutPaused.setBoolean(false);

    // change current rw to next one
    context.read(currentRoutineWorkoutProvider).state =
        routineWorkouts[miniplayerIndex.routineWorkoutIndex];

    // sets from new Routine Workout
    final sets = context.read(currentRoutineWorkoutProvider).state!.sets!;
    if (sets.isNotEmpty) {
      print('workout set exists');
      context.read(currentWorkoutSetProvider).state = sets[0];
      final currentWorkoutSet = context.read(currentWorkoutSetProvider).state!;
      if (currentWorkoutSet.isRest) {
        context.read(restTimerDurationProvider).state = Duration(
          seconds: currentWorkoutSet.restTime ?? 90,
        );
      }
    } else {
      context.read(currentWorkoutSetProvider).state = null;
    }

    debugPrint('current Index is ${miniplayerIndex.currentIndex}');
    debugPrint(
        'routineWorkout Index is ${miniplayerIndex.routineWorkoutIndex}');
    debugPrint('Workout Set Index is ${miniplayerIndex.workoutSetIndex}');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final routineWorkouts = watch(selectedRoutineWorkoutsProvider).state!;
    final routineWorkout = watch(currentRoutineWorkoutProvider).state!;
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final miniplayerIndex = watch(miniplayerIndexProvider);

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
                  context,
                  routineWorkouts: routineWorkouts,
                  routineWorkout: routineWorkout,
                  isWorkoutPaused: isWorkoutPaused,
                  miniplayerIndex: miniplayerIndex,
                ),
      ),
    );
  }
}
