import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/screens/add_workout_to_routine_screen.dart';
import 'package:workout_player/view/screens/routine_detail_screen.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'main_model.dart';

final addWorkoutToRoutineScreenModelProvider = ChangeNotifierProvider(
  (ref) => AddWorkoutToRoutineScreenModel(),
);

class AddWorkoutToRoutineScreenModel with ChangeNotifier {
  Future<void> submit(
    BuildContext context,
    BuildContext currentTabContext, {
    required Workout workout,
    required Routine routine,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    try {
      final routineWorkouts =
          await database.routineWorkoutsStream(routine.routineId).first;
      final index = routineWorkouts.length + 1;

      final id = 'RW${const Uuid().v1()}';

      final routineWorkout = RoutineWorkout(
        routineWorkoutId: id,
        workoutId: workout.workoutId,
        routineId: routine.routineId,
        routineWorkoutOwnerId: auth.currentUser!.uid,
        workoutTitle: workout.workoutTitle,
        isBodyWeightWorkout: workout.isBodyWeightWorkout,
        totalWeights: 0,
        numberOfSets: 0,
        numberOfReps: 0,
        duration: 0,
        secondsPerRep: workout.secondsPerRep,
        sets: [],
        index: index,
        translated: workout.translated,
      );
      await database.setRoutineWorkout(routine, routineWorkout);

      Navigator.of(context).pop();

      RoutineDetailScreen.show(
        currentTabContext,
        routine: routine,
        tag: 'addWorkoutToRoutine${routine.routineId}',
      );

      // TODO: ADD SNACK BAR HERE
      getSnackbarWidget(
        S.current.addWorkout,
        S.current.addWorkoutToRoutineSnackbarMessage(''),
      );
    } on Exception catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// Navigation
  static void show(
    BuildContext context, {
    required Workout workout,
  }) {
    final database = provider.Provider.of<Database>(context, listen: false);

    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddWorkoutToRoutineScreen(
          workout: workout,
          database: database,
        ),
      ),
    );
  }
}
