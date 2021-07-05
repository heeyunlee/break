import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/screens/miniplayer/miniplayer_model.dart';

import '../../../styles/constants.dart';

class MiniplayerSubtitle extends StatelessWidget {
  final double? horizontalPadding;
  final TextStyle? textStyle;
  final MiniplayerModel model;

  const MiniplayerSubtitle({
    this.horizontalPadding,
    this.textStyle,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Intl.getCurrentLocale();

    final routineWorkout = model.currentRoutineWorkout!;

    final translatedTitle = routineWorkout.translated;
    final title = (translatedTitle.isEmpty)
        ? routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? routineWorkout.translated[locale]
            : routineWorkout.workoutTitle;

    final String miniplayerTitle = '${routineWorkout.index}. $title';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 24),
      child: Text(miniplayerTitle, style: textStyle ?? kHeadline6Grey),
    );
  }
}
