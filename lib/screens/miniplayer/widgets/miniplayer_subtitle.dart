import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/screens/miniplayer/provider/workout_miniplayer_provider.dart';

import '../../../constants.dart';

class MiniplayerSubtitle extends ConsumerWidget {
  final double? horizontalPadding;
  final TextStyle? textStyle;

  const MiniplayerSubtitle({this.horizontalPadding, this.textStyle});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final locale = Intl.getCurrentLocale();
    // final routineWorkout = watch(currentRoutineWorkoutProvider).state!;
    final routineWorkout =
        watch(miniplayerProviderNotifierProvider).currentRoutineWorkout!;

    final translation = routineWorkout.translated;
    final title = (translation.isEmpty)
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
