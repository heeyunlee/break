import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

final ValueNotifier<double> miniplayerExpandProgress =
    ValueNotifier(miniplayerMinHeight);

final double miniplayerMinHeight = Platform.isIOS ? 152 : 120;

final miniplayerModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => MiniplayerModel(),
);

class MiniplayerModel with ChangeNotifier {
  int _currentIndex = 1;
  int _routineWorkoutIndex = 0;
  int _workoutSetIndex = 0;
  int _setsLength = 0;
  bool _isWorkoutPaused = false;
  Routine? _selectedRoutine;
  List<RoutineWorkout?>? _selectedRoutineWorkouts;
  RoutineWorkout? _currentRoutineWorkout;
  WorkoutSet? _currentWorkoutSet;
  Duration? _restTime;
  final MiniplayerController _miniplayerController = MiniplayerController();
  final CountDownController _countDownController = CountDownController();

  int get currentIndex => _currentIndex;
  int get routineWorkoutIndex => _routineWorkoutIndex;
  int get workoutSetIndex => _workoutSetIndex;
  int get setsLength => _setsLength;
  bool get isWorkoutPaused => _isWorkoutPaused;
  Routine? get selectedRoutine => _selectedRoutine;
  List<RoutineWorkout?>? get selectedRoutineWorkouts =>
      _selectedRoutineWorkouts;
  RoutineWorkout? get currentRoutineWorkout => _currentRoutineWorkout;
  WorkoutSet? get currentWorkoutSet => _currentWorkoutSet;
  Duration? get restTime => _restTime;
  MiniplayerController get miniplayerController => _miniplayerController;
  CountDownController get countDownController => _countDownController;

  // CURRENT INDEX
  void incrementCurrentIndex() {
    _currentIndex++;
    notifyListeners();
  }

  void decrementCurrentIndex() {
    _currentIndex--;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ROUTINE WORKOUT INDEX
  void incrementRoutineWorkoutIndex() {
    _routineWorkoutIndex++;
    notifyListeners();
  }

  void decrementRoutineWorkoutIndex() {
    _routineWorkoutIndex--;
    notifyListeners();
  }

  void setRoutineWorkoutIndex(int index) {
    _routineWorkoutIndex = index;
    notifyListeners();
  }

  // WORKOUT SET INDEX
  void incrementWorkoutSetIndex() {
    _workoutSetIndex++;
    notifyListeners();
  }

  void decrementWorkoutSetIndex() {
    _workoutSetIndex--;
    notifyListeners();
  }

  void setWorkoutSetIndex(int index) {
    _workoutSetIndex = index;
    notifyListeners();
  }

  // SETS LENGTH
  void setSetsLength(int index) {
    _setsLength = index;
    notifyListeners();
  }

  void setIndexesToDefault() {
    _currentIndex = 1;
    _routineWorkoutIndex = 0;
    _workoutSetIndex = 0;
    _setsLength = 0;
    notifyListeners();
  }

  // IS WORKOUT PAUSED
  void toggleIsWorkoutPaused() {
    _isWorkoutPaused = !_isWorkoutPaused;
    notifyListeners();
  }

  void setIsWorkoutPaused(bool value) {
    _isWorkoutPaused = value;
    notifyListeners();
  }

  // ROUTINE, ROUTINE WORKOUTS, WORKOUT SETS
  void setRoutine(Routine? routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }

  void setRoutineWorkouts(List<RoutineWorkout>? routineWorkouts) {
    _selectedRoutineWorkouts = routineWorkouts;
    notifyListeners();
  }

  void setRoutineWorkout(RoutineWorkout? routineWorkout) {
    _currentRoutineWorkout = routineWorkout;
    notifyListeners();
  }

  void setWorkoutSet(WorkoutSet? workoutSet) {
    _currentWorkoutSet = workoutSet;
    notifyListeners();
  }

  void setMiniplayerValues({
    Routine? routine,
    List<RoutineWorkout?>? routineWorkouts,
    RoutineWorkout? routineWorkout,
    WorkoutSet? workoutSet,
  }) {
    _selectedRoutine = routine;
    _selectedRoutineWorkouts = routineWorkouts;
    _currentRoutineWorkout = routineWorkout;
    _currentWorkoutSet = workoutSet;
    notifyListeners();
  }

  void setMiniplayerValuesNull() {
    _selectedRoutine = null;
    _selectedRoutineWorkouts = null;
    _currentRoutineWorkout = null;
    _currentWorkoutSet = null;
    notifyListeners();
  }

  void setRestTime(Duration? time) {
    _restTime = time;
    notifyListeners();
  }

  void diosposeValues(Duration? time) {
    _selectedRoutine = null;
    _selectedRoutineWorkouts = null;
    _currentRoutineWorkout = null;
    _currentWorkoutSet = null;
    _restTime = time;
    _currentIndex = 1;
    _routineWorkoutIndex = 0;
    _workoutSetIndex = 0;
    _setsLength = 0;

    notifyListeners();
  }

  void startRoutine() {}
}
