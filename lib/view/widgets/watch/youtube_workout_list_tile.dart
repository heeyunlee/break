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
    if (workout.isRest ?? false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: kCardColorDark,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        Formatter.durationInMMSS(workout.position),
                        style: TextStyles.blackHans2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer_rounded, size: 16),
                const SizedBox(width: 8),
                Text(
                  S.current.youtubeWorkoutListTileTitle(getSubtitle()),
                  style: TextStyles.body1,
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: kCardColor,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 56,
                  height: 64,
                  child: Center(
                    child: Text(
                      Formatter.durationInMMSS(workout.position),
                      style: TextStyles.blackHans2,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatter.localizedTitle(
                      workout.workoutTitle,
                      workout.translatedWorkoutTitle,
                    ),
                    style: TextStyles.body1,
                  ),
                  Text(
                    getSubtitle(),
                    style: TextStyles.body2Grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  String getSubtitle() {
    if (workout.isRepsBased) {
      return '${workout.reps} x';
    } else {
      return '${workout.duration!.inSeconds} ${S.current.seconds}';
    }
  }
}
