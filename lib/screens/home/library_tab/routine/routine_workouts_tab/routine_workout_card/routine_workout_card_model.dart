import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/classes/combined/auth_and_database.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/classes/routine_workout.dart';
import 'package:workout_player/classes/workout_set.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:collection/collection.dart';

final routineWorkoutCardModelProvider =
    ChangeNotifierProvider.family<RoutineWorkoutCardModel, AuthAndDatabase>(
  (ref, authAndDatabase) {
    return RoutineWorkoutCardModel(
      auth: authAndDatabase.auth,
      database: authAndDatabase.database,
    );
  },
);

class RoutineWorkoutCardModel with ChangeNotifier {
  AuthBase? auth;
  Database? database;

  RoutineWorkoutCardModel({
    this.auth,
    this.database,
  });

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

      final id = Uuid().v1();

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

      await database!.setWorkoutSet(
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

      await database!.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      logger.e(e);
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

      final id = Uuid().v1();

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

      await database!.setWorkoutSet(
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

      await database!.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      logger.e(e);
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
      // Delete Routine Workout
      await database!.deleteRoutineWorkout(routine, routineWorkout);

      Navigator.of(context).pop();

      // Update Routine
      final updatedRoutine = {
        'totalWeights': routine.totalWeights - routineWorkout.totalWeights,
        'duration': routine.duration - routineWorkout.duration,
      };

      await database!.updateRoutine(routine, updatedRoutine);

      getSnackbarWidget(
        S.current.deleteRoutineHistorySnackbarTitle,
        S.current.deleteRoutineWorkoutSnakbarMessage,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }
}
