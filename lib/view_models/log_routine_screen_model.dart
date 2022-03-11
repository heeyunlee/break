import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/workout_summary_screen.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'main_model.dart';

class LogRoutineModel with ChangeNotifier {
  LogRoutineModel({required this.database});

  final Database database;

  bool _isButtonPressed = false;
  Timestamp _loggedTime = Timestamp.now();
  double _effort = 2.5;
  bool _isPublic = true;
  bool _isExpanded = false;

  late TextEditingController _titleEditingController;
  late TextEditingController _durationEditingController;
  late TextEditingController _totalVolumeEditingController;
  late TextEditingController _notesEditingController;

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;

  bool get isButtonPressed => _isButtonPressed;
  Timestamp get loggedTime => _loggedTime;
  double get effort => _effort;
  bool get isPublic => _isPublic;
  bool get isExpanded => _isExpanded;

  TextEditingController get titleEditingController => _titleEditingController;
  TextEditingController get durationEditingController =>
      _durationEditingController;
  TextEditingController get totalVolumeEditingController =>
      _totalVolumeEditingController;
  TextEditingController get notesEditingController => _notesEditingController;

  FocusNode get focusNode1 => _focusNode1;
  FocusNode get focusNode2 => _focusNode2;
  FocusNode get focusNode3 => _focusNode3;
  FocusNode get focusNode4 => _focusNode4;
  List<FocusNode> get focusNodes => [
        _focusNode1,
        _focusNode2,
        _focusNode3,
        _focusNode4,
      ];

  void toggleExpanded() {
    _isExpanded = !_isExpanded;

    notifyListeners();
  }

  void init(Routine routine) {
    _titleEditingController = TextEditingController(text: routine.routineTitle);

    final secondsNotNegative = routine.duration < 0 ? 0 : routine.duration;
    final durationInMinutes = Duration(seconds: secondsNotNegative).inMinutes;
    _durationEditingController = TextEditingController(
      text: durationInMinutes.toString(),
    );

    _totalVolumeEditingController = TextEditingController(
      text: routine.totalWeights.toString(),
    );

    _notesEditingController = TextEditingController();

    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
  }

  bool hasFocus() {
    return _focusNode1.hasFocus ||
        _focusNode2.hasFocus ||
        _focusNode3.hasFocus ||
        _focusNode4.hasFocus;
  }

  void _toggleBoolValue() {
    _isButtonPressed = !_isButtonPressed;
    notifyListeners();
  }

  void onDateTimeChanged(DateTime date) {
    _loggedTime = Timestamp.fromDate(date);

    notifyListeners();
  }

  void onRatingUpdate(double value) {
    _effort = value;
    notifyListeners();
  }

  void onIsPublicChanged(bool isChanged) {
    _isPublic = !_isPublic;
    notifyListeners();
  }

  // Submit data to Firestore
  Future<void> submit(
    BuildContext context, {
    required User user,
    required Routine routine,
    required List<RoutineWorkout?> routineWorkouts,
  }) async {
    try {
      _toggleBoolValue();

      /// For Routine History
      final routineHistoryId = 'RH${const Uuid().v1()}';
      final _workoutStartTime = _loggedTime.toDate().subtract(
            Duration(minutes: int.parse(_durationEditingController.text)),
          );

      final isBodyWeightWorkout = routineWorkouts.any(
        (element) => element!.isBodyWeightWorkout == true,
      );
      final workoutDate = DateTime.utc(
        _loggedTime.toDate().year,
        _loggedTime.toDate().month,
        _loggedTime.toDate().day,
      );

      final muscleGroup = routine.mainMuscleGroupEnum ??
          Formatter.getListOfMainMuscleGroupFromStrings(
              routine.mainMuscleGroup);
      final equipments = routine.equipmentRequiredEnum ??
          Formatter.getListOfEquipmentsFromStrings(routine.equipmentRequired);
      final unitOfMass = routine.unitOfMassEnum ??
          UnitOfMass.values[routine.initialUnitOfMass ?? 0];

      final routineHistory = RoutineHistory(
        routineHistoryId: routineHistoryId,
        userId: user.userId,
        username: user.displayName,
        routineId: routine.routineId,
        routineTitle: _titleEditingController.text,
        isPublic: _isPublic,
        workoutEndTime: _loggedTime,
        workoutStartTime: Timestamp.fromDate(_workoutStartTime),
        notes: _notesEditingController.text,
        totalCalories: 0,
        totalDuration: int.parse(_durationEditingController.text) * 60,
        totalWeights: num.parse(_totalVolumeEditingController.text),
        isBodyWeightWorkout: isBodyWeightWorkout,
        workoutDate: workoutDate,
        imageUrl: routine.imageUrl,
        mainMuscleGroupEnum: muscleGroup,
        equipmentRequiredEnum: equipments,
        effort: _effort,
        unitOfMassEnum: unitOfMass,
        routineHistoryType: 'routine',
      );

      /// For Workout Histories
      final List<WorkoutHistory> workoutHistories = routineWorkouts.map((rw) {
        final uniqueId = UniqueKey().toString();

        final workoutHistoryId = 'WH${const Uuid().v1()}$uniqueId';

        final workoutHistory = WorkoutHistory(
          workoutHistoryId: workoutHistoryId,
          routineHistoryId: routineHistoryId,
          workoutId: rw!.workoutId,
          routineId: rw.routineId,
          uid: user.userId,
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
          workoutTime: _loggedTime,
          workoutDate: Timestamp.fromDate(workoutDate),
          unitOfMass: routine.initialUnitOfMass,
        );

        return workoutHistory;
      }).toList();

      await database.setRoutineHistory(routineHistory);
      await database.batchWriteWorkoutHistories(workoutHistories);

      Navigator.of(context).pop();

      WorkoutSummaryScreen.show(
        context,
        routineHistory: routineHistory,
      );

      getSnackbarWidget(
        'Finished Workout',
        S.current.afterWorkoutSnackbar,
      );

      // ref.read(miniplayerModelProvider).close();

      _toggleBoolValue();
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }

    notifyListeners();
  }

  /// STATIC
  static final formKey = GlobalKey<FormState>();
}
