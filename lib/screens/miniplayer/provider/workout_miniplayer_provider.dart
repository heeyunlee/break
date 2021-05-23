import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

class newClass {
  late final Routine? selectedRoutine;
  late final List<RoutineWorkout>? selectedRoutineWorkouts;

  newClass({
    this.selectedRoutine,
    this.selectedRoutineWorkouts,
  });

  newClass.initial() {
    selectedRoutine = null;
    selectedRoutineWorkouts = null;
  }

  newClass copyWith({
    Routine? selectedRoutine,
    List<RoutineWorkout>? selectedRoutineWorkouts,
  }) {
    return newClass(
      selectedRoutine: selectedRoutine ?? this.selectedRoutine,
      selectedRoutineWorkouts:
          selectedRoutineWorkouts ?? this.selectedRoutineWorkouts,
    );
  }
}

final newClassNotifierProvider =
    StateNotifierProvider<newClassNotifier, newClass>((ref) {
  return newClassNotifier(newClass.initial());
});

class newClassNotifier extends StateNotifier<newClass> {
  newClassNotifier(newClass state) : super(state);

  void makeSelectedRoutineNull() {
    state = state.copyWith(selectedRoutine: null);
  }
}

final ValueNotifier<double> miniplayerExpandProgress =
    ValueNotifier(miniplayerMinHeight);

final double miniplayerMinHeight = 152;

final selectedRoutineProvider = StateProvider<Routine?>((ref) => null);
final selectedRoutineWorkoutsProvider =
    StateProvider<List<RoutineWorkout>?>((ref) => null);
final currentRoutineWorkoutProvider =
    StateProvider<RoutineWorkout?>((ref) => null);
final currentWorkoutSetProvider = StateProvider<WorkoutSet?>((ref) => null);

final miniplayerControllerProvider = StateProvider<MiniplayerController>(
  (ref) => MiniplayerController(),
);

final miniplayerTimerControllerProvider =
    StateProvider<CountDownController>((_) => CountDownController());

final restTimerDurationProvider = StateProvider<Duration?>((_) => Duration());

class IsWorkoutPausedNotifier extends ChangeNotifier {
  bool _isWorkoutPaused = false;
  bool get isWorkoutPaused => _isWorkoutPaused;

  void toggleBoolValue() {
    _isWorkoutPaused = !_isWorkoutPaused;
    notifyListeners();
  }

  void setBoolean(bool value) {
    _isWorkoutPaused = value;
    notifyListeners();
  }
}

class IsWorkoutPausedNotifier2 extends StateNotifier<bool> {
  IsWorkoutPausedNotifier2({bool state = false}) : super(state);

  // bool _isWorkoutPaused = false;

  // bool get isWorkoutPaused => _isWorkoutPaused;

  void toggleBoolValue() {
    state = !state;
  }

  void setBoolean(bool value) {
    state = value;
  }
}

final isWorkoutPausedProvider =
    ChangeNotifierProvider((ref) => IsWorkoutPausedNotifier());

class MiniplayerIndexNotifier extends ChangeNotifier {
  int _currentIndex = 1;
  int _routineWorkoutIndex = 0;
  int _workoutSetIndex = 0;
  int _routineLength = 0;

  int get currentIndex => _currentIndex;
  int get routineWorkoutIndex => _routineWorkoutIndex;
  int get workoutSetIndex => _workoutSetIndex;
  int get routineLength => _routineLength;

  void incrementCurrentIndex() {
    _currentIndex++;
    notifyListeners();
  }

  void incrementRWIndex() {
    _routineWorkoutIndex++;
    notifyListeners();
  }

  void incrementWorkoutSetIndex() {
    _workoutSetIndex++;
    notifyListeners();
  }

  void decrementCurrentIndex() {
    _currentIndex--;
    notifyListeners();
  }

  void decrementRWIndex() {
    _routineWorkoutIndex--;
    notifyListeners();
  }

  void decrementWorkoutSetIndex() {
    _workoutSetIndex--;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setRWIndex(int index) {
    _routineWorkoutIndex = index;
    notifyListeners();
  }

  void setWorkoutSetIndex(int index) {
    _workoutSetIndex = index;
    notifyListeners();
  }

  void setEveryIndexToDefault(int length) {
    _currentIndex = 1;
    _routineWorkoutIndex = 0;
    _workoutSetIndex = 0;
    _routineLength = length;
    notifyListeners();
  }

  void setRoutineLength(int value) {
    _routineLength = value;
    notifyListeners();
  }
}

final miniplayerIndexProvider = ChangeNotifierProvider(
  (ref) => MiniplayerIndexNotifier(),
);
