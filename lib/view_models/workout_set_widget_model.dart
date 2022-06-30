import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/widgets/dialogs.dart';

class WorkoutSetWidgetModel with ChangeNotifier {
  WorkoutSetWidgetModel({required this.database});

  final Database database;

  /// DELETE WORKOUT SET
  Future<void> deleteSet(
    BuildContext context, {
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
  }) async {
    try {
      // Update Routine Workout Data
      final numberOfSets = (workoutSet.isRest)
          ? routineWorkout.numberOfSets
          : routineWorkout.numberOfSets - 1;

      final numberOfReps = (workoutSet.isRest)
          ? routineWorkout.numberOfReps
          : routineWorkout.numberOfReps - (workoutSet.reps ?? 0);

      final totalWeights = routineWorkout.totalWeights -
          (workoutSet.weights ?? 0) * (workoutSet.reps ?? 0);

      final duration = routineWorkout.duration -
          (workoutSet.restTime ?? 0) -
          (workoutSet.reps ?? 0) * routineWorkout.secondsPerRep;

      final updatedRoutineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayRemove([workoutSet.toJson()]),
      };

      await database.setWorkoutSet(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      // Update Routine Data
      final routineTotalWeights = (workoutSet.isRest)
          ? routine.totalWeights
          : (workoutSet.weights == 0)
              ? routine.totalWeights
              : routine.totalWeights -
                  ((workoutSet.weights ?? 0) * (workoutSet.reps ?? 0));

      final routineDuration = (workoutSet.isRest)
          ? routine.duration - (workoutSet.restTime ?? 0)
          : routine.duration -
              ((workoutSet.reps ?? 0) * routineWorkout.secondsPerRep);

      final updatedRoutine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
        'lastEditedDate': Timestamp.now(),
      };

      await database.updateRoutine(routine, updatedRoutine);

      // getSnackbarWidget(
      //   S.current.deleteWorkoutSet,
      //   (workoutSet.isRest)
      //       ? S.current.deletedARestMessage
      //       : S.current.deletedASet,
      // );
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// UPDATE WEIGHT
  Future<void> updateWeight(
    BuildContext context, {
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
    required int index,
  }) async {
    /// Update Workout Set
    try {
      final List<WorkoutSet> workoutSets = routineWorkout.sets;

      final updatedWorkoutSet = workoutSet.copyWith(
        weights: num.tryParse(textEditingController.text),
      );

      workoutSets[index] = updatedWorkoutSet;

      focusNode.unfocus();

      await _submit(context, database, routine, routineWorkout, workoutSets);
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// UPDATE WEIGHT
  Future<void> updateReps(
    BuildContext context, {
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
    required int index,
  }) async {
    /// Update Workout Set
    try {
      final List<WorkoutSet> workoutSets = routineWorkout.sets;

      final updatedWorkoutSet = workoutSet.copyWith(
        reps: int.tryParse(textEditingController.text),
      );

      workoutSets[index] = updatedWorkoutSet;

      focusNode.unfocus();

      await _submit(context, database, routine, routineWorkout, workoutSets);
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// UPDATE WEIGHT
  Future<void> updateRestTime(
    BuildContext context,
    Database database, {
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
    required int index,
  }) async {
    /// Update Workout Set
    final List<WorkoutSet> workoutSets = routineWorkout.sets;

    final updatedWorkoutSet = workoutSet.copyWith(
      restTime: int.tryParse(textEditingController.text),
    );

    workoutSets[index] = updatedWorkoutSet;

    focusNode.unfocus();

    await _submit(context, database, routine, routineWorkout, workoutSets);
  }

  Future<void> _submit(
    BuildContext context,
    Database database,
    Routine routine,
    RoutineWorkout routineWorkout,
    List<WorkoutSet> workoutSets,
  ) async {
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

  static String title(WorkoutSet workoutSet) {
    return '${S.current.set} ${workoutSet.setIndex}';
  }

  static String unit(Routine routine) {
    final unit = Formatter.unitOfMass(
      routine.initialUnitOfMass,
      routine.unitOfMassEnum,
    );

    return unit;
  }
}
