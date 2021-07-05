import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../../../styles/constants.dart';
import '../miniplayer_model.dart';

class RestTimerWidget extends StatelessWidget {
  final MiniplayerModel model;

  const RestTimerWidget({Key? key, required this.model}) : super(key: key);

  void _timerOnComplete(BuildContext context) {
    if (model.currentIndex <= model.setsLength) {
      // Find length of routine workout
      final routineWorkouts = model.selectedRoutineWorkouts!;
      final routineWorkoutLength = routineWorkouts.length - 1;

      // Find length of workout set
      final routineWorkout = model.currentRoutineWorkout!;
      final workoutSetLength = routineWorkout.sets!.length - 1;

      model.incrementCurrentIndex();
      model.setIsWorkoutPaused(false);

      // If workout set is NOT last
      if (model.workoutSetIndex < workoutSetLength) {
        model.incrementWorkoutSetIndex();

        model.setWorkoutSet(
          routineWorkout.sets![model.workoutSetIndex],
        );

        final workoutSet = model.currentWorkoutSet!;

        if (workoutSet.isRest) {
          model.setRestTime(Duration(seconds: workoutSet.restTime ?? 60));
        }
      } else {
        // If workout set is LAST && Routine Workout is NOT last
        if (model.routineWorkoutIndex < routineWorkoutLength) {
          model.setWorkoutSetIndex(0);
          model.incrementRoutineWorkoutIndex();

          model.setRoutineWorkout(
            routineWorkouts[model.routineWorkoutIndex],
          );

          final newRoutineWorkout = model.currentRoutineWorkout!;

          model.setWorkoutSet(
            newRoutineWorkout.sets![model.workoutSetIndex],
          );

          final workoutSet = model.currentWorkoutSet!;

          if (workoutSet.isRest) {
            model.setRestTime(Duration(seconds: workoutSet.restTime ?? 60));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: Container(
          width: size.width - 56,
          height: size.width - 56,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CircularCountDownTimer(
              textStyle: kHeadline2,
              controller: model.countDownController,
              width: 280,
              height: 280,
              duration: model.restTime!.inSeconds,
              fillColor: Colors.grey[600]!,
              ringColor: Colors.red,
              isReverse: true,
              strokeWidth: 8,
              onComplete: () => _timerOnComplete(context),
            ),
          ),
        ),
      ),
    );
  }
}
