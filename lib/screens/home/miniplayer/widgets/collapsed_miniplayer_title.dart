import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import '../miniplayer_model.dart';

class CollapsedMiniplayerTitle extends StatelessWidget {
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;
  final MiniplayerModel model;

  const CollapsedMiniplayerTitle({
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = TextStyles.headline5,
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    final routine = model.selectedRoutine!;
    final workoutSet = model.currentWorkoutSet;

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
        final unit = Formatter.unitOfMass(
          routine.initialUnitOfMass,
          routine.unitOfMassEnum,
        );
        final formattedWeights =
            '${Formatter.numWithDecimal(workoutSet.weights!)} $unit';
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
