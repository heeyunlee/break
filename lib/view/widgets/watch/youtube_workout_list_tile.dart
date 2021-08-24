import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import 'package:workout_player/models/workout_for_youtube.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class YoutubeWorkoutListTile extends StatelessWidget {
  const YoutubeWorkoutListTile({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final WorkoutForYoutube workout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          Formatter.localizedTitle(
            workout.workoutTitle,
            workout.translatedWorkoutTitle,
          ),
          style: TextStyles.body1,
        ),
        subtitle: Text(
          getSubtitle(),
          style: TextStyles.body2_grey,
        ),
        leading: SizedBox(
          width: 56,
          child: Center(
            child: Text(
              Formatter.durationInMMSS(workout.position),
              style: TextStyles.blackHans2,
            ),
          ),
        ),
        tileColor: kCardColor,
      ),
    );
  }

  String getSubtitle() {
    if (workout.isRepsBased) {
      return '${workout.reps} x';
    } else {
      return '${workout.duration!.inSeconds} ${S.current.seconds}';
    }
  }
}
