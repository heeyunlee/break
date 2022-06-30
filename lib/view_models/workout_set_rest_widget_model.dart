import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/features/widgets/dialogs.dart';

class WorkoutSetRestWidgetModel with ChangeNotifier {
  WorkoutSetRestWidgetModel({required this.database});

  final Database database;

  Future<void> updateRestTime(
    BuildContext context, {
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
    required int index,
  }) async {
    /// Update Workout Set
    List<WorkoutSet> workoutSets = routineWorkout.sets;

    final updatedWorkoutSet = workoutSet.copyWith(
      restTime: int.tryParse(textEditingController.text),
    );

    workoutSets[index] = updatedWorkoutSet;

    focusNode.unfocus();

    try {
      /// Update Routine Workout
      int numberOfReps = 0;
      num totalWeights = 0;
      int duration = 0;

      for (final workoutSet in workoutSets) {
        numberOfReps += workoutSet.reps ?? 0;
        totalWeights += (workoutSet.weights ?? 0) * (workoutSet.reps ?? 0);

        final int rest = workoutSet.restTime ?? 0;
        final int reps = workoutSet.reps ?? 0;
        final int secondsPerRep = routineWorkout.secondsPerRep;

        duration += rest + reps * secondsPerRep;
      }

      final updatedRoutineWorkout = {
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': workoutSets.map((e) => e.toJson()).toList(),
      };

      await database.updateRoutineWorkout(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      /// Update Routine
      final routineTotalWeights =
          routine.totalWeights - routineWorkout.totalWeights + totalWeights;
      final routineDuration =
          routine.duration - routineWorkout.duration + duration;

      final updatedRoutine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
        'lastEditedDate': Timestamp.now(),
      };

      await database.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }
}
