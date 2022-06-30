import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class RoutineWorkoutCardModel with ChangeNotifier {
  RoutineWorkoutCardModel({required this.database});

  final Database database;

  /// Add a New Set
  Future<void> addNewSet(
    BuildContext context, {
    required Routine routine,
    required RoutineWorkout routineWorkout,
  }) async {
    try {
      // WorkoutSet and RoutineWorkout
      final WorkoutSet? formerWorkoutSet = routineWorkout.sets.lastWhereOrNull(
        (element) => element.isRest == false,
      );

      final sets = routineWorkout.sets
          .where((element) => element.isRest == false)
          .toList();

      final id = const Uuid().v1();

      final newSet = WorkoutSet(
        workoutSetId: id,
        isRest: false,
        index: routineWorkout.sets.length + 1,
        setIndex: sets.length + 1,
        setTitle: 'Set ${sets.length + 1}',
        weights: formerWorkoutSet?.weights ?? 0,
        reps: formerWorkoutSet?.reps ?? 0,
      );

      final reps = newSet.reps ?? 0;

      final numberOfSets = routineWorkout.numberOfSets + 1;
      final numberOfReps = routineWorkout.numberOfReps + newSet.reps!;
      final totalWeights =
          routineWorkout.totalWeights + (newSet.weights! * newSet.reps!);
      final duration =
          routineWorkout.duration + (reps * routineWorkout.secondsPerRep);

      final updatedRoutineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayUnion([newSet.toJson()]),
      };

      await database.setWorkoutSet(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );
      if (Platform.isIOS) {
        await HapticFeedback.mediumImpact();
      }

      // Routine
      final updatedRoutine = {
        'totalWeights': routine.totalWeights + (newSet.weights! * newSet.reps!),
        'duration':
            routine.duration + (newSet.reps! * routineWorkout.secondsPerRep),
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

  // Add new a Rest
  Future<void> addNewRest(
    BuildContext context, {
    required Routine routine,
    required RoutineWorkout routineWorkout,
  }) async {
    try {
      final WorkoutSet? formerWorkoutSet = routineWorkout.sets.lastWhereOrNull(
        (element) => element.isRest == true,
      );

      final rests = routineWorkout.sets
          .where((element) => element.isRest == true)
          .toList();

      final id = const Uuid().v1();

      final newSet = WorkoutSet(
        workoutSetId: id,
        isRest: true,
        index: routineWorkout.sets.length + 1,
        restIndex: rests.length + 1,
        setTitle: 'Rest ${rests.length + 1}',
        weights: 0,
        reps: 0,
        restTime: formerWorkoutSet?.restTime ?? 60,
      );

      final duration = routineWorkout.duration + newSet.restTime!;

      final updatedRoutineWorkout = {
        'duration': duration,
        'sets': FieldValue.arrayUnion([newSet.toJson()]),
      };

      await database.setWorkoutSet(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );
      if (Platform.isIOS) {
        await HapticFeedback.mediumImpact();
      }

      /// Routine
      final updatedRoutine = {
        'lastEditedDate': Timestamp.now(),
        'duration': routine.duration + newSet.restTime!,
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

  /// Delete Routine Workout Method
  Future<void> deleteRoutineWorkout(
    BuildContext context, {
    required Routine routine,
    required RoutineWorkout routineWorkout,
  }) async {
    try {
      Navigator.of(context).pop();

      // Delete Routine Workout
      await database.deleteRoutineWorkout(routine, routineWorkout);

      // Update Routine
      final updatedRoutine = {
        'totalWeights': routine.totalWeights - routineWorkout.totalWeights,
        'duration': routine.duration - routineWorkout.duration,
      };

      await database.updateRoutine(routine, updatedRoutine);

      // getSnackbarWidget(
      //   S.current.deleteRoutineHistorySnackbarTitle,
      //   S.current.deleteRoutineWorkoutSnakbarMessage,
      // );
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  Future<void> deleteRestingWorkoutSet(
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

  static String numberOfSets(RoutineWorkout routineWorkout) {
    if (routineWorkout.numberOfSets > 1) {
      return '${routineWorkout.numberOfSets} ${S.current.sets}';
    } else {
      return '${routineWorkout.numberOfSets} ${S.current.set}';
    }
  }

  static String totalWeights(Routine routine, RoutineWorkout routineWorkout) {
    final weights = Formatter.numWithOrWithoutDecimal(
      routineWorkout.totalWeights,
    );

    final unit = Formatter.unitOfMass(
      routine.initialUnitOfMass,
      routine.unitOfMassEnum,
    );

    final formattedTotalWeights =
        (routineWorkout.isBodyWeightWorkout && routineWorkout.totalWeights == 0)
            ? S.current.bodyweight
            : (routineWorkout.isBodyWeightWorkout)
                ? '${S.current.bodyweight} + $weights $unit'
                : '$weights $unit';

    return formattedTotalWeights;
  }

  bool isOwner(Routine routine) {
    final uid = database.uid ?? 'asd';
    final routineOwnerId = routine.routineOwnerId;

    return uid == routineOwnerId;
  }
}
