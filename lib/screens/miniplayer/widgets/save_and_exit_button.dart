import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routine_history_summary_screen.dart';
import '../provider/workout_miniplayer_provider.dart';

class SaveAndExitButton extends ConsumerWidget {
  final Future<User?> user;
  final Database database;

  const SaveAndExitButton({
    Key? key,
    required this.user,
    required this.database,
  }) : super(key: key);

  Future<void> _submit(
    BuildContext context, {
    required Routine routine,
    required List<RoutineWorkout> routineWorkouts,
  }) async {
    try {
      debugPrint('submit button pressed');

      /// For Routine History
      final userData = (await user)!;
      final _workoutStartTime = Timestamp.now();
      final routineHistoryId = 'RH${documentIdFromCurrentDate()}';
      final workoutEndTime = Timestamp.now();
      final workoutStartDate = _workoutStartTime.toDate();
      final workoutEndDate = workoutEndTime.toDate();
      final duration = workoutEndDate.difference(workoutStartDate).inSeconds;
      final isBodyWeightWorkout = routineWorkouts.any(
        (element) => element.isBodyWeightWorkout == true,
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
          var weights = routineWorkouts[i].totalWeights;
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
          final workoutHistoryId = documentIdFromCurrentDate();
          final uniqueId = UniqueKey().toString();

          final workoutHistory = WorkoutHistory(
            workoutHistoryId: 'WH$workoutHistoryId$uniqueId',
            routineHistoryId: routineHistoryId,
            workoutId: rw.workoutId,
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
          );
          workoutHistories.add(workoutHistory);
        },
      );

      /// Update User Data
      // GET history data
      final histories = userData.dailyWorkoutHistories;

      final index = userData.dailyWorkoutHistories!
          .indexWhere((element) => element.date.toUtc() == workoutDate);

      if (index == -1) {
        final newHistory = DailyWorkoutHistory(
          date: workoutDate,
          totalWeights: totalWeights,
        );
        histories!.add(newHistory);
      } else {
        final oldHistory = histories![index];

        final newHistory = DailyWorkoutHistory(
          date: oldHistory.date,
          totalWeights: oldHistory.totalWeights + totalWeights,
        );
        histories[index] = newHistory;
      }

      // User
      final updatedUserData = {
        'totalWeights': userData.totalWeights + totalWeights,
        'totalNumberOfWorkouts': userData.totalNumberOfWorkouts + 1,
        'dailyWorkoutHistories': histories.map((e) => e.toMap()).toList(),
      };

      await database.setRoutineHistory(routineHistory);
      await database.batchWriteWorkoutHistories(workoutHistories);
      await database.updateUser(userData.userId, updatedUserData);

      RoutineHistorySummaryScreen.show(
        context,
        routineHistory: routineHistory,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.current.afterWorkoutSnackbar),
      ));
      context
          .read(miniplayerProviderNotifierProvider.notifier)
          .makeValuesNull();
      context.read(miniplayerIndexProvider).setEveryIndexToDefault(0);
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
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    // final routine = watch(selectedRoutineProvider).state;
    final routine = miniplayerProvider.selectedRoutine;
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    // final routineWorkouts = watch(selectedRoutineWorkoutsProvider).state;
    final routineWorkouts = miniplayerProvider.selectedRoutineWorkouts;

    return SizedBox(
      height: size.height * 0.1,
      child: (isWorkoutPaused.isWorkoutPaused)
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: MaxWidthRaisedButton(
                width: double.infinity,
                buttonText: S.current.saveAndEndWorkout,
                color: Colors.grey[700],
                onPressed: () => _submit(
                  context,
                  routine: routine!,
                  routineWorkouts: routineWorkouts!,
                ),
              ),
            )
          : Container(),
    );
  }
}
