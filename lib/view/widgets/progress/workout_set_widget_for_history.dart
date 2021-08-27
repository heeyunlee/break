import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class WorkoutSetWidgetForHistory extends StatelessWidget {
  final RoutineHistory routineHistory;
  final WorkoutHistory workoutHistory;
  final WorkoutSet workoutSet;
  final int index;

  const WorkoutSetWidgetForHistory({
    Key? key,
    required this.routineHistory,
    required this.workoutHistory,
    required this.workoutSet,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = '${S.current.set} ${workoutSet.setIndex}';
    final String reps = '${workoutSet.reps} ${S.current.x}';
    final String restTime = '${workoutSet.restTime} ${S.current.seconds}';

    return Row(
      children: [
        const SizedBox(width: 16, height: 56),
        if (!workoutSet.isRest) Text(title, style: TextStyles.body1Bold),

        if (workoutSet.isRest)
          const Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
        const Spacer(),

        /// Weights
        if (!workoutSet.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 36,
              width: 128,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: kCardColorLight,
              child: Center(
                child: Text(
                  Formatter.workoutSetWeightsFromHistory(
                    routineHistory,
                    workoutHistory,
                    workoutSet,
                  ),
                  style: TextStyles.body1,
                ),
              ),
            ),
          ),
        const SizedBox(width: 16),

        /// Reps
        if (!workoutSet.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 36,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              color: kPrimaryColor,
              child: Center(child: Text(reps, style: TextStyles.body1)),
            ),
          ),

        /// Rest Time
        if (workoutSet.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
                height: 36,
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                color: kPrimaryColor,
                child: Center(child: Text(restTime, style: TextStyles.body1))),
          ),

        const SizedBox(width: 16),
      ],
    );
  }
}
