import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import '../../home_screen.dart';
import '../routine_history_summary_screen.dart';

// typedef BoolCallback = void Function(bool value);
Logger logger = Logger();

class SaveAndExitButton extends StatelessWidget {
  // final BoolCallback callback;
  final Routine routine;
  final List<RoutineWorkout> routineWorkouts;
  final BoolNotifier boolNotifier;
  final Future<User?> user;
  final Database database;

  const SaveAndExitButton({
    Key? key,
    // required this.callback,
    required this.routine,
    required this.routineWorkouts,
    required this.boolNotifier,
    required this.user,
    required this.database,
  }) : super(key: key);

  // bool _isPaused = false;
  // static Widget create(BuildContext context {}) {
  //   final database = Provider.of<Database>(context, listen: false);
  //   final auth = Provider.of<AuthBase>(context, listen: false);
  //   final user = database.getUserDocument(auth.currentUser!.uid);

  //   return SaveAndExitButton(
  //     database: database,
  //     user: user,
  //     routine: routine,
  //     routineWorkouts: routineWorkouts,
  //     boolNotifier: boolNotifier,

  //   );
  // }

  Future<void> _submit(
    BuildContext context, {
    required Routine routine,
    required List<RoutineWorkout> routineWorkouts,
  }) async {
    try {
      debugPrint('submit button pressed');
      final userData = (await user)!;
      final _workoutStartTime = Timestamp.now();

      final routineHistoryId = documentIdFromCurrentDate();
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
        // final index = widget.user.dailyWorkoutHistories
        //     .indexWhere((element) => element.date.toUtc() == workoutDate);
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

      await database.setRoutineHistory(routineHistory).then((value) async {
        await database.batchRoutineWorkouts(
          routineHistory,
          routineWorkouts,
        );
      });
      await database.updateUser(userData.userId, updatedUserData);
      Navigator.of(context).popUntil((route) => route.isFirst);
      RoutineHistorySummaryScreen.show(
        context,
        routineHistory: routineHistory,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.current.afterWorkoutSnackbar),
      ));
    } on FirebaseException catch (e) {
      logger.d(e);
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
      child: (boolNotifier.isWorkoutPaused)
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: MaxWidthRaisedButton(
                width: double.infinity,
                buttonText: S.current.saveAndEndWorkout,
                color: Colors.grey[700],
                onPressed: () => _submit(
                  context,
                  routine: routine,
                  routineWorkouts: routineWorkouts,
                ),
              ),
            )
          : Container(),
    );
  }
}
