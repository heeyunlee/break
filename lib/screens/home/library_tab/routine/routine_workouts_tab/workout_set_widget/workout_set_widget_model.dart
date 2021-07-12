import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

class WorkoutSetWidgetModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  WorkoutSetWidgetModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  late TextEditingController _textController1;
  late TextEditingController _textController2;
  late TextEditingController _textController3;
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;

  // late String _weights;
  late String _reps;
  late String _restTime;

  bool _weightWidgetEditing = false;
  bool _repsWidgetEditing = false;
  bool _restWidgetEditing = false;

  TextEditingController get textController1 => _textController1;
  TextEditingController get textController2 => _textController2;
  TextEditingController get textController3 => _textController3;
  FocusNode get focusNode1 => _focusNode1;
  FocusNode get focusNode2 => _focusNode2;
  FocusNode get focusNode3 => _focusNode3;

  // String get weights => _weights;
  String get reps => _reps;
  String get restTime => _restTime;

  bool get weightWidgetEditing => _weightWidgetEditing;
  bool get repsWidgetEditing => _repsWidgetEditing;
  bool get restWidgetEditing => _restWidgetEditing;

  void setWeightWidgetEditing(bool value) {
    _weightWidgetEditing = value;
    notifyListeners();
  }

  void setRepsWidgetEditing(bool value) {
    _repsWidgetEditing = value;
    notifyListeners();
  }

  void setRestWidgetEditing(bool value) {
    _restWidgetEditing = value;
    notifyListeners();
  }

  void init(WorkoutSet workoutSet) {
    final weights = Formatter.weights(workoutSet.weights!);
    // _weights = Formatter.weights(workoutSet.weights!);
    _textController1 = TextEditingController(text: weights);
    _focusNode1 = FocusNode();

    // _reps = workoutSet.reps.toString();
    final reps = workoutSet.reps.toString();
    _textController2 = TextEditingController(text: reps);
    _focusNode2 = FocusNode();

    _restTime = workoutSet.restTime.toString();
    // _textController3 = TextEditingController(text: restTime);
    _focusNode3 = FocusNode();

    // print('init');
  }

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
          : routineWorkout.numberOfReps - workoutSet.reps!;

      final totalWeights = routineWorkout.totalWeights -
          (workoutSet.weights! * workoutSet.reps!);

      final duration = routineWorkout.duration -
          workoutSet.restTime! -
          (workoutSet.reps! * routineWorkout.secondsPerRep);

      final updatedRoutineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayRemove([workoutSet.toJson()]),
      };

      // Update Routine Data
      final routineTotalWeights = (workoutSet.isRest)
          ? totalWeights
          : (workoutSet.weights == 0)
              ? routine.totalWeights
              : routine.totalWeights - (workoutSet.weights! * workoutSet.reps!);
      final routineDuration = (workoutSet.isRest)
          ? routine.duration - workoutSet.restTime!
          : routine.duration -
              (workoutSet.reps! * routineWorkout.secondsPerRep);
      final now = Timestamp.now();

      final updatedRoutine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
        'lastEditedDate': now,
      };

      await database!.setWorkoutSet(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      await database!.updateRoutine(routine, updatedRoutine);

      // getSnackbarWidget(
      //   '',
      //   (set.isRest) ? S.current.deletedARestMessage : S.current.deletedASet,
      // );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  Future<void> updateWeight(
    BuildContext context, {
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
    required int index,
  }) async {
    // _weightWidgetEditing = true;
    // notifyListeners();

    try {
      final workoutSets = routineWorkout.sets;
      print('workoutSets length is ${workoutSets.length}');

      // final workoutWeights = num.parse(_weights);
      // print('workoutWeights is ${workoutWeights.runtimeType}');

      // /// Workout Set
      // final sets = widget.routineWorkout.sets
      //     .where((element) => element.isRest == false)
      //     .toList();
      // final setIndex = sets.length + 1;

      /// Update Workout Set
      // final newSet = WorkoutSet(
      //   workoutSetId: workoutSet.workoutSetId,
      //   isRest: workoutSet.isRest,
      //   index: workoutSet.index,
      //   setTitle: workoutSet.setTitle,
      //   restTime: int.parse(_restTime),
      //   reps: int.parse(_reps),
      //   weights: num.parse(_weights),
      //   setIndex: set.setIndex,
      // );
      final updatedSet = workoutSet.copyWith(
        // weights: int.parse(_weights),
        weights: int.parse(_textController1.text),
        // restTime: int.parse(_restTime),
        // reps: 90,
        // weights: 90,
      );

      workoutSets[index] = updatedSet;

      int numberOfReps = 0;

      for (var i = 0; i < workoutSets.length; i++) {
        var reps = workoutSets[i].reps;
        numberOfReps = numberOfReps + reps!;
      }

      // Total Weights
      num totalWeights = 0;

      for (var i = 0; i < workoutSets.length; i++) {
        num weights = workoutSets[i].weights! * workoutSets[i].reps!;
        totalWeights = totalWeights + weights;
      }

      // Duration
      int duration = 0;

      for (var i = 0; i < workoutSets.length; i++) {
        var t = workoutSets[i].restTime! +
            (workoutSets[i].reps! * routineWorkout.secondsPerRep);
        duration = duration + t;
      }

      final updatedRoutineWorkout = {
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': workoutSets.map((e) => e.toJson()).toList(),
      };

      /// Update Routine Data
      final routineTotalWeights =
          routine.totalWeights - routineWorkout.totalWeights + totalWeights;
      final routineDuration =
          routine.duration - routineWorkout.duration + duration;

      final updatedRoutine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
      };

      await database!.updateRoutineWorkout(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      await database!.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
    _weightWidgetEditing = false;
    _focusNode1.unfocus();
    notifyListeners();
    // _textController1.dispose();
    // _focusNode1.dispose();
  }

  Future<void> updateSet(
    BuildContext context,
    String type, {
    required String value,
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required WorkoutSet workoutSet,
    required int index,
  }) async {
    try {
      final workoutSets = routineWorkout.sets;

      final updatedSet = workoutSet.copyWith(
        restTime: (type == 'restTime') ? int.parse(value) : null,
        reps: (type == 'reps') ? int.parse(value) : null,
        weights: (type == 'weights') ? int.parse(value) : null,
        // restTime: int.parse(_restTime),
        // reps: 90,
        // weights: 90,
      );

      workoutSets[index] = updatedSet;

      /// Update Routine Workout
      // NumberOfReps
      int numberOfReps = 0;

      for (var i = 0; i < workoutSets.length; i++) {
        var reps = workoutSets[i].reps;
        numberOfReps = numberOfReps + reps!;
      }

      // Total Weights
      num totalWeights = 0;

      for (var i = 0; i < workoutSets.length; i++) {
        num weights = workoutSets[i].weights! * workoutSets[i].reps!;
        totalWeights = totalWeights + weights;
      }

      // Duration
      int duration = 0;

      for (var i = 0; i < workoutSets.length; i++) {
        var t = workoutSets[i].restTime! +
            (workoutSets[i].reps! * routineWorkout.secondsPerRep);
        duration = duration + t;
      }

      final updatedRoutineWorkout = {
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': workoutSets.map((e) => e.toJson()).toList(),
      };

      /// Update Routine Data
      final routineTotalWeights =
          routine.totalWeights - routineWorkout.totalWeights + totalWeights;
      final routineDuration =
          routine.duration - routineWorkout.duration + duration;

      final updatedRoutine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
      };

      await database!.updateRoutineWorkout(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      await database!.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
    // _weightWidgetEditing = false;
    // _textController1.dispose();
    // _focusNode1.dispose();
  }
}
