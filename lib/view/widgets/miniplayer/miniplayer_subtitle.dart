import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout_for_youtube.dart';
import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';
import 'package:collection/collection.dart';

class MiniplayerSubtitle extends StatelessWidget {
  final double? horizontalPadding;
  final TextStyle? textStyle;
  final MiniplayerModel model;

  const MiniplayerSubtitle({
    Key? key,
    this.horizontalPadding,
    this.textStyle = TextStyles.headline6Grey,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 24),
      child: getString(),
    );
  }

  Widget getString() {
    if (model.currentWorkout.runtimeType == Routine) {
      final translated = Formatter.localizedTitle(
        model.currentRoutineWorkout!.workoutTitle,
        model.currentRoutineWorkout!.translated,
      );

      return Text(
        '${model.currentRoutineWorkout!.index}. $translated',
        style: textStyle,
      );
    } else {
      return YoutubeValueBuilder(
        controller: model.youtubeController,
        builder: (context, value) {
          final video = model.currentWorkout as YoutubeVideo?;
          final currentWorkout = video!.workouts.lastWhereOrNull(
                (element) => element.position <= value.position,
              ) ??
              video.workouts[0];

          return Text(getSubtitle(currentWorkout), style: textStyle);
        },
      );
    }
  }

  String getSubtitle(WorkoutForYoutube workout) {
    if (workout.isRepsBased) {
      return '${workout.reps} x';
    } else {
      return '${workout.duration!.inSeconds} ${S.current.seconds}';
    }
  }
}
