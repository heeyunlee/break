import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../workout_miniplayer_provider.dart';

class PreviousWorkoutSetButton extends ConsumerWidget {
  Future<void> _skipPrevious(
    BuildContext context, {
    required List<RoutineWorkout> routineWorkouts,
    required RoutineWorkout routineWorkout,
    required MiniplayerIndexNotifier miniplayerIndex,
    required IsWorkoutPausedNotifier isWorkoutPaused,
  }) async {
    // set isWorkoutPaused to false
    isWorkoutPaused.setBoolean(false);
    // decrease current index by 1
    miniplayerIndex.decrementCurrentIndex();

    // if (miniplayerIndex.workoutSetIndex != 0) {
    miniplayerIndex.decrementWorkoutSetIndex();

    context.read(currentWorkoutSetProvider).state =
        routineWorkout.sets![miniplayerIndex.workoutSetIndex];
    context.read(restTimerDurationProvider).state = Duration(
      seconds: context.read(currentWorkoutSetProvider).state!.restTime ?? 60,
    );
    // }

    debugPrint('current Index is ${miniplayerIndex.currentIndex}');
    debugPrint(
        'routineWorkout Index is ${miniplayerIndex.routineWorkoutIndex}');
    debugPrint('Workout Set Index is ${miniplayerIndex.workoutSetIndex}');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final routineWorkouts = watch(selectedRoutineWorkoutsProvider).state;
    final routineWorkout = watch(currentRoutineWorkoutProvider).state;
    final miniplayerIndex = watch(miniplayerIndexProvider);
    final isWorkoutPaused = watch(isWorkoutPausedProvider);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousSet,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        iconSize: 48,
        icon: Icon(Icons.skip_previous_rounded),
        onPressed: (miniplayerIndex.currentIndex > 1 &&
                miniplayerIndex.workoutSetIndex != 0)
            ? () => _skipPrevious(
                  context,
                  routineWorkouts: routineWorkouts!,
                  routineWorkout: routineWorkout!,
                  isWorkoutPaused: isWorkoutPaused,
                  miniplayerIndex: miniplayerIndex,
                )
            : null,
      ),
    );
  }
}
