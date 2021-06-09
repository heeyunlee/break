import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../workout_miniplayer_provider.dart';

class NextWorkoutSetButton extends ConsumerWidget {
  final double? iconSize;

  const NextWorkoutSetButton({
    this.iconSize = 48,
  });
  void _skipNext(
    BuildContext context, {
    required MiniplayerIndexNotifier miniplayerIndex,
    required RoutineWorkout routineWorkout,
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required MiniplayerProviderNotifier miniplayerNotifier,
  }) {
    // set isWorkoutPaused false
    isWorkoutPaused.setBoolean(false);

    // increase current index by 1
    miniplayerIndex.incrementCurrentIndex();

    // workout set Index by 1
    miniplayerIndex.incrementWorkoutSetIndex();

    // set Workout Set
    miniplayerNotifier.setWorkoutSet(
      routineWorkout.sets![miniplayerIndex.workoutSetIndex],
    );

    context.read(restTimerDurationProvider).state = Duration(
      seconds: context
              .read(miniplayerProviderNotifierProvider)
              .currentWorkoutSet!
              .restTime ??
          60,
    );

    debugPrint('current Index is ${miniplayerIndex.currentIndex}');
    debugPrint(
        'routineWorkout Index is ${miniplayerIndex.routineWorkoutIndex}');
    debugPrint('Workout Set Index is ${miniplayerIndex.workoutSetIndex}');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerIndex = watch(miniplayerIndexProvider);
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routineWorkout = miniplayerProvider.currentRoutineWorkout!;
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final workoutSet = miniplayerProvider.currentWorkoutSet;
    final miniplayerNotifier =
        watch(miniplayerProviderNotifierProvider.notifier);

    final isLastSet = (workoutSet != null)
        ? miniplayerIndex.workoutSetIndex == routineWorkout.sets!.length - 1
        : true;

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toNextSet,
      child: IconButton(
        iconSize: iconSize!,
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(Icons.skip_next_rounded),
        onPressed: (isLastSet)
            ? null
            : () => _skipNext(
                  context,
                  miniplayerIndex: miniplayerIndex,
                  routineWorkout: routineWorkout,
                  isWorkoutPaused: isWorkoutPaused,
                  miniplayerNotifier: miniplayerNotifier,
                ),
      ),
    );
  }
}
