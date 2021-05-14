import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

import '../../../constants.dart';
import '../../../format.dart';

Logger logger = Logger();

class WorkoutSetForHistory extends StatelessWidget {
  const WorkoutSetForHistory({
    Key? key,
    required this.routineHistory,
    required this.routineWorkout,
    required this.set,
    required this.index,
  }) : super(key: key);

  final RoutineHistory routineHistory;
  final RoutineWorkout routineWorkout;
  final WorkoutSet set;
  final int index;

  @override
  Widget build(BuildContext context) {
    final String title = '${S.current.set} ${set.setIndex}';
    final String unit = Format.unitOfMass(routineHistory.unitOfMass);
    final num weights = set.weights!;
    final String formattedWeights = '${Format.weights(weights)} $unit';
    final String reps = '${set.reps} ${S.current.x}';
    final String restTime = '${set.restTime} ${S.current.seconds}';

    return Row(
      children: [
        const SizedBox(width: 16, height: 56),
        if (!set.isRest) Text(title, style: kBodyText1Bold),

        if (set.isRest)
          const Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
        const Spacer(),

        /// Weights
        if (!set.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 36,
              width: 128,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: kCardColorLight,
              child: Center(
                child: Text(
                  (routineWorkout.isBodyWeightWorkout)
                      ? S.current.bodyweight
                      : formattedWeights,
                  style: kBodyText1,
                ),
              ),
            ),
          ),
        const SizedBox(width: 16),

        /// Reps
        if (!set.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 36,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              color: kPrimaryColor,
              child: Center(child: Text(reps, style: kBodyText1)),
            ),
          ),

        /// Rest Time
        if (set.isRest)
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
                height: 36,
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                color: kPrimaryColor,
                child: Center(child: Text(restTime, style: kBodyText1))),
          ),

        const SizedBox(width: 16),
      ],
    );
  }
}
