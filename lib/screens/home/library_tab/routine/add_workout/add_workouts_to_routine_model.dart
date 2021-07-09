import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

final addWorkoutsToRoutineScreenModelProvider = ChangeNotifierProvider(
  (ref) => AddWorkoutsToRoutineScreenModel(),
);

class AddWorkoutsToRoutineScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  AddWorkoutsToRoutineScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider3);
    print('current uid ${auth?.currentUser?.uid}');

    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  Workout? _selectedWorkout;
  String _selectedMainMuscleGroup = 'All';
  String _selectedChipTranslated = 'All';
  // int _selectedIndex = 0;

  Workout? get selectedWorkout => _selectedWorkout;
  String get selectedMainMuscleGroup => _selectedMainMuscleGroup;
  String get selectedChipTranslated => _selectedChipTranslated;
  // int get selectedIndex => _selectedIndex;

  void initSelectedChip(Routine routine) {
    _selectedMainMuscleGroup = routine.mainMuscleGroup[0];
  }

  void onSelected(bool selected, String string) {
    // final List<String> _mainMuscleGroup =
    //     ['All'] + MainMuscleGroup.values[0].list;

    // if (selected) {
    HapticFeedback.mediumImpact();
    // _selectedIndex = index;
    // _selectedMainMuscleGroup = _mainMuscleGroup[index];
    _selectedMainMuscleGroup = string;
    _selectedChipTranslated = MainMuscleGroup.values
        .firstWhere((e) => e.toString() == _selectedMainMuscleGroup)
        .translation!;
    // }

    notifyListeners();
  }

  Future<void> submitRoutineWorkoutData(
    BuildContext context,
    Routine routine,
    Workout workout,
  ) async {
    try {
      _selectedWorkout = workout;

      final routineWorkouts =
          await database!.routineWorkoutsStream(routine.routineId).first;
      final index = routineWorkouts.length + 1;
      // final id = documentIdFromCurrentDate();
      final id = Uuid().v1();

      final routineWorkout = RoutineWorkout(
        routineWorkoutId: 'RW$id',
        workoutId: _selectedWorkout!.workoutId,
        routineId: routine.routineId,
        routineWorkoutOwnerId: auth!.currentUser!.uid,
        workoutTitle: _selectedWorkout!.workoutTitle,
        numberOfReps: 0,
        numberOfSets: 0,
        totalWeights: 0,
        index: index,
        sets: [],
        isBodyWeightWorkout: _selectedWorkout!.isBodyWeightWorkout,
        duration: 0,
        secondsPerRep: _selectedWorkout!.secondsPerRep,
        translated: _selectedWorkout!.translated,
      );
      await database!.setRoutineWorkout(routine, routineWorkout);

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
