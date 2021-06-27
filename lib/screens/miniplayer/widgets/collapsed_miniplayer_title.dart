import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../../utils/formatter.dart';

class CollapsedMiniplayerTitle extends ConsumerWidget {
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;

  const CollapsedMiniplayerTitle({
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = TextStyles.headline5,
  });
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final routine = miniplayerProvider.selectedRoutine!;
    final workoutSet = miniplayerProvider.currentWorkoutSet;

    if (workoutSet != null) {
      if (workoutSet.isRest) {
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
        final unit = Formatter.unitOfMass(routine.initialUnitOfMass);
        final formattedWeights =
            '${Formatter.weights(workoutSet.weights!)} $unit';
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
