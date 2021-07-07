import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import '../routine_history_summary_screen.dart';
import '../miniplayer_model.dart';

class SaveAndExitButton extends StatelessWidget {
  final Future<User?> user;
  final Database database;
  final MiniplayerModel model;

  const SaveAndExitButton({
    Key? key,
    required this.user,
    required this.database,
    required this.model,
  }) : super(key: key);

  Future<void> _submit(BuildContext context) async {
    final routine = model.selectedRoutine!;
    final routineWorkouts = model.selectedRoutineWorkouts!;

    try {
      /// For Routine History
      final userData = (await user)!;
      final _workoutStartTime = Timestamp.now();
      // final routineHistoryId = 'RH${documentIdFromCurrentDate()}';
      final routineHistoryId = 'RH${Uuid().v1()}';
      final workoutEndTime = Timestamp.now();
      final workoutStartDate = _workoutStartTime.toDate();
      final workoutEndDate = workoutEndTime.toDate();
      final duration = workoutEndDate.difference(workoutStartDate).inSeconds;
      final isBodyWeightWorkout = routineWorkouts.any(
        (element) => element!.isBodyWeightWorkout == true,
      );
      final workoutDate = DateTime.utc(
        workoutStartDate.year,
        workoutStartDate.month,
        workoutStartDate.day,
      );

      // For Calculating Total Weights
      var totalWeights = 0.00;
      var weightsCalculated = false;
      if (!weightsCalculated) {
        for (var i = 0; i < routineWorkouts.length; i++) {
          var weights = routineWorkouts[i]!.totalWeights;
          totalWeights = totalWeights + weights;
        }
        weightsCalculated = true;
      }

      final routineHistory = RoutineHistory(
        routineHistoryId: routineHistoryId,
        userId: userData.userId,
        username: userData.displayName,
        routineId: routine.routineId,
        routineTitle: routine.routineTitle,
        isPublic: true,
        mainMuscleGroup: routine.mainMuscleGroup,
        secondMuscleGroup: routine.secondMuscleGroup,
        workoutStartTime: _workoutStartTime,
        workoutEndTime: workoutEndTime,
        notes: '',
        totalCalories: 0,
        totalDuration: duration,
        totalWeights: totalWeights,
        isBodyWeightWorkout: isBodyWeightWorkout,
        workoutDate: workoutDate,
        imageUrl: routine.imageUrl,
        unitOfMass: routine.initialUnitOfMass,
        equipmentRequired: routine.equipmentRequired,
      );

      /// For Workout Histories
      List<WorkoutHistory> workoutHistories = [];
      routineWorkouts.forEach(
        (rw) {
          final id = 'WH${Uuid().v1()}';
          // final workoutHistoryId = documentIdFromCurrentDate();
          // final uniqueId = UniqueKey().toString();

          final workoutHistory = WorkoutHistory(
            workoutHistoryId: id,
            routineHistoryId: routineHistoryId,
            workoutId: rw!.workoutId,
            routineId: rw.routineId,
            uid: userData.userId,
            index: rw.index,
            workoutTitle: rw.workoutTitle,
            numberOfSets: rw.numberOfSets,
            numberOfReps: rw.numberOfReps,
            totalWeights: rw.totalWeights,
            isBodyWeightWorkout: rw.isBodyWeightWorkout,
            duration: rw.duration,
            secondsPerRep: rw.secondsPerRep,
            translated: rw.translated,
            sets: rw.sets,
            workoutTime: workoutEndTime,
            workoutDate: Timestamp.fromDate(workoutDate),
            unitOfMass: routine.initialUnitOfMass,
          );
          workoutHistories.add(workoutHistory);
        },
      );

      await database.setRoutineHistory(routineHistory);
      await database.batchWriteWorkoutHistories(workoutHistories);

      model.setMiniplayerValuesNull();
      model.setIndexesToDefault();

      RoutineHistorySummaryScreen.show(
        context,
        routineHistory: routineHistory,
      );

      // TODO: ADD SNACKBAR HERE
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(S.current.afterWorkoutSnackbar),
      // ));

    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.1,
      child: (model.isWorkoutPaused)
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: MaxWidthRaisedButton(
                width: double.infinity,
                buttonText: S.current.saveAndEndWorkout,
                color: Colors.grey[700],
                onPressed: () => _submit(context),
              ),
            )
          : Container(),
    );
  }
}
