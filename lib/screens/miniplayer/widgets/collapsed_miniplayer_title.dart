import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/miniplayer/provider/workout_miniplayer_provider.dart';

import '../../../constants.dart';
import '../../../format.dart';

class CollapsedMiniplayerTitle extends ConsumerWidget {
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;

  const CollapsedMiniplayerTitle({
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = kHeadline5,
  });
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routine = miniplayerProvider.selectedRoutine!;
    final workoutSet = miniplayerProvider.currentWorkoutSet;
    // final routine = watch(selectedRoutineProvider).state!;
    // final workoutSet = watch(currentWorkoutSetProvider).state;

    if (workoutSet != null) {
      if (workoutSet.isRest) {
        // final timer = watch(miniplayerTimerControllerProvider).state.getTime();
        final restTime = workoutSet.restTime;
        final title = '${S.current.rest}: $restTime ${S.current.seconds}';

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horzPadding!,
            vertical: vertPadding!,
          ),
          child: Text(title, style: textStyle),
        );
      } else {
        final unit = Format.unitOfMass(routine.initialUnitOfMass);
        final formattedWeights = '${Format.weights(workoutSet.weights!)} $unit';
        final reps = '${workoutSet.reps} ${S.current.x}';
        final title = '$formattedWeights   •   $reps';

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horzPadding!,
            vertical: vertPadding!,
          ),
          child: Text(title, style: textStyle),
        );
      }
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
