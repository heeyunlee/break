import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';
import 'package:collection/collection.dart';

class MiniplayerTitle extends StatelessWidget {
  const MiniplayerTitle({
    required this.model,
    required this.isExpanded,
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = TextStyles.headline5,
  });

  final MiniplayerModel model;
  final bool isExpanded;
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horzPadding!,
        vertical: vertPadding!,
      ),
      child: getTitle(),
    );
  }

  Widget getTitle() {
    if (model.currentWorkout.runtimeType == Routine) {
      if (isExpanded) {
        return Text(
          Formatter.formattedWorkoutSetTitle(model.currentWorkoutSet),
          style: textStyle,
        );
      } else {
        return Text(
          Formatter.workoutSetWeightAndReps(
            model.currentWorkout as Routine?,
            model.currentRoutineWorkout,
            model.currentWorkoutSet,
          ),
          style: textStyle,
        );
      }
    } else {
      return YoutubeValueBuilder(
        builder: (context, value) {
          final video = model.currentWorkout as YoutubeVideo?;
          final currentWorkout = video!.workouts
                  .lastWhereOrNull((e) => e.position <= value.position) ??
              video.workouts[0];
          int currentIndex = video.workouts
              .lastIndexWhere((e) => e.position <= value.position);

          currentIndex = (currentIndex == -1) ? 0 : currentIndex;

          model.updateCurrentIndex(currentIndex);

          return Text(
            Formatter.localizedTitle(
              currentWorkout.workoutTitle,
              currentWorkout.translatedWorkoutTitle,
            ),
            style: textStyle,
          );
        },
      );
    }
  }
}
