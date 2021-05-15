import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

final double miniplayerMinHeight = 144.0;

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
// final miniplayerAnimationControllerProvider =
//     StateProvider.family<TickerProvider, AnimationController>(
//   (vsync, animationController) => AnimationController(vsync: vsync),
// );

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

// class BooleanNotifier<bool> extends StateNotifier {
//   BooleanNotifier(state) : super(state);
//   bool get isWorkoutPaused => state;

//   void toggleBoolValue() {
//     state = !state;
//   }

//   void setBoolean(bool value) {
//     state = value;
//   }
// }

final isWorkoutPausedProvider =
    ChangeNotifierProvider((ref) => IsWorkoutPausedNotifier());
// final workoutPausedProvider =
//     StateNotifierProvider((_) => BooleanNotifier(false));

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
  }

  void incrementRWIndex() {
    _routineWorkoutIndex++;
  }

  void incrementWorkoutSetIndex() {
    _workoutSetIndex++;
  }

  void decrementCurrentIndex() {
    _currentIndex--;
  }

  void decrementRWIndex() {
    _routineWorkoutIndex--;
  }

  void decrementWorkoutSetIndex() {
    _workoutSetIndex--;
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
  }

  void setRWIndex(int index) {
    _routineWorkoutIndex = index;
  }

  void setWorkoutSetIndex(int index) {
    _workoutSetIndex = index;
  }

  void setEveryIndexToDefault() {
    _currentIndex = 1;
    _routineWorkoutIndex = 0;
    _workoutSetIndex = 0;
  }

  void setRoutineLength(int value) {
    _routineLength = value;
  }
}

final miniplayerIndexProvider = ChangeNotifierProvider.autoDispose(
  (ref) => MiniplayerIndexNotifier(),
);
