import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/miniplayer/provider/workout_miniplayer_provider.dart';

import '../../../constants.dart';

class ExpandedMiniplayerTitle extends ConsumerWidget {
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;

  const ExpandedMiniplayerTitle({
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = kHeadline5,
  });
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final routine = watch(selectedRoutineProvider).state!;
    final workoutSet = watch(currentWorkoutSetProvider).state;

    if (workoutSet != null) {
      // final timerController = watch(miniplayerTimerControllerProvider).state;
      // final secondsLeft = timerController.getTime();
      // final restTime = '${workoutSet.restTime} ${S.current.seconds}';
      // final unit = Format.unitOfMass(routine.initialUnitOfMass);
      // final formattedWeights = '${Format.weights(workoutSet.weights!)} $unit';
      // final reps = '${workoutSet.reps} ${S.current.x}';

      final setTitle = (workoutSet.isRest)
          ? S.current.rest
          : '${S.current.set} ${workoutSet.setIndex}';

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horzPadding!,
          vertical: vertPadding!,
        ),
        child: Text(setTitle, style: textStyle),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horzPadding!,
          vertical: vertPadding!,
        ),
        child: Text(S.current.noWorkoutSetTitle, style: textStyle),
      );
    }
  }
}
