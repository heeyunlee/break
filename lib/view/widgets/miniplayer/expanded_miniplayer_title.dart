import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../../../view_models/miniplayer_model.dart';

class ExpandedMiniplayerTitle extends StatelessWidget {
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;
  final MiniplayerModel model;

  const ExpandedMiniplayerTitle({
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = TextStyles.headline5,
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    final workoutSet = model.currentWorkoutSet;

    if (workoutSet != null) {
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
