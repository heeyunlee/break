import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'main_model.dart';

final addWorkoutsToRoutineScreenModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) => AddWorkoutsToRoutineScreenModel(),
);

class AddWorkoutsToRoutineScreenModel with ChangeNotifier {
  Database? database;

  AddWorkoutsToRoutineScreenModel({
    this.database,
  }) {
    final container = ProviderContainer();
    final auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth.currentUser?.uid));
  }

  String _selectedMainMuscleGroup = 'MainMuscleGroup.abs';
  String _selectedChipTranslated = MainMuscleGroup.abs.translation!;
  final List<Workout> _selectedWorkouts = <Workout>[];
  late Stream<List<Workout>> _stream;

  String get selectedMainMuscleGroup => _selectedMainMuscleGroup;
  String get selectedChipTranslated => _selectedChipTranslated;
  List<Workout> get selectedWorkouts => _selectedWorkouts;
  Stream<List<Workout>> get stream => _stream;

  void init(Routine routine) {
    _selectedMainMuscleGroup = routine.mainMuscleGroup?[0].toString() ??
        routine.mainMuscleGroupEnum?[0].toString() ??
        'MainMuscleGroup.abs';

    _stream = database!.workoutsSearchStream(
      isEqualTo: false,
      arrayContainsVariableName: 'mainMuscleGroup',
      arrayContainsValue: _selectedMainMuscleGroup,
    );
  }

  void onSelectChoiceChip(bool selected, String string) {
    HapticFeedback.mediumImpact();
    _selectedMainMuscleGroup = string;
    _selectedChipTranslated = (string == 'Saved')
        ? S.current.saved
        : (string == 'All')
            ? S.current.all
            : MainMuscleGroup.values
                .firstWhere((e) => e.toString() == _selectedMainMuscleGroup)
                .translation!;

    if (_selectedMainMuscleGroup == 'Saved') {
      _stream = database!.workoutsStream();
    } else if (_selectedMainMuscleGroup == 'All') {
      _stream = database!.workoutsStream();
    } else {
      _stream = database!.workoutsSearchStream(
        isEqualTo: false,
        arrayContainsVariableName: 'mainMuscleGroup',
        arrayContainsValue: _selectedMainMuscleGroup,
      );
    }

    notifyListeners();
  }

  void selectWorkout(BuildContext context, Workout workout) {
    if (_selectedWorkouts.contains(workout)) {
      _selectedWorkouts.remove(workout);
    } else {
      if (_selectedWorkouts.length < 6) {
        _selectedWorkouts.add(workout);
      } else {
        showAlertDialog(
          context,
          title: S.current.warning,
          content: S.current.addWorkoutWaningMessage,
          defaultActionText: S.current.ok,
        );
      }
    }

    notifyListeners();
  }

  // Stream<List<Workout>> getWorkoutsStream() {
  //   logger.d('`getWorkoutsStream()` function called');

  //   if (_selectedMainMuscleGroup == 'Saved') {
  //     return database!.workoutsStream();
  //   } else if (_selectedMainMuscleGroup == 'All') {
  //     return database!.workoutsStream();
  //   } else {
  //     return database!.workoutsSearchStream(
  //       arrayContainsVariableName: 'mainMuscleGroup',
  //       arrayContainsValue: _selectedMainMuscleGroup,
  //     );
  //   }
  // }

  Future<void> addWorkoutsToRoutine(
    BuildContext context,
    Routine routine,
    List<RoutineWorkout> routineWorkouts,
  ) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    await HapticFeedback.mediumImpact();

    try {
      final List<RoutineWorkout> _routineWorkouts = [];
      // int _index = routineWorkouts.length;

      for (int i = 0; i < _selectedWorkouts.length; i++) {
        final id = const Uuid().v1();
        final workout = _selectedWorkouts[i];
        final index = routineWorkouts.length + i + 1;
        final routineWorkout = RoutineWorkout(
          routineWorkoutId: 'RW$id',
          workoutId: workout.workoutId,
          routineId: routine.routineId,
          routineWorkoutOwnerId: auth.currentUser!.uid,
          workoutTitle: workout.workoutTitle,
          numberOfReps: 0,
          numberOfSets: 0,
          totalWeights: 0,
          index: index,
          sets: [],
          isBodyWeightWorkout: workout.isBodyWeightWorkout,
          duration: 0,
          secondsPerRep: workout.secondsPerRep,
          translated: workout.translated,
        );

        _routineWorkouts.add(routineWorkout);
      }
      // _selectedWorkouts.forEach((workout) {
      //   final id = const Uuid().v1();
      //   _index += 1;

      //   final routineWorkout = RoutineWorkout(
      //     routineWorkoutId: 'RW$id',
      //     workoutId: workout.workoutId,
      //     routineId: routine.routineId,
      //     routineWorkoutOwnerId: auth.currentUser!.uid,
      //     workoutTitle: workout.workoutTitle,
      //     numberOfReps: 0,
      //     numberOfSets: 0,
      //     totalWeights: 0,
      //     index: _index,
      //     sets: [],
      //     isBodyWeightWorkout: workout.isBodyWeightWorkout,
      //     duration: 0,
      //     secondsPerRep: workout.secondsPerRep,
      //     translated: workout.translated,
      //   );

      //   _routineWorkouts.add(routineWorkout);
      // });

      await database.batchWriteRoutineWorkouts(routine, _routineWorkouts);

      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.addWorkoutToRoutineSnackbarTitle,
        S.current.addWorkoutToRoutineSnackbar,
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
}
