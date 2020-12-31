import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/api_path.dart';
import 'package:workout_player/services/firestore_service.dart';

abstract class Database {
  /// User
  Future<void> setUser(User user);

  /// Workout
  Future<void> setWorkout(Workout workout);
  Future<void> deleteWorkout(Workout workout);
  Stream<List<Workout>> savedWorkoutsStream();
  Stream<List<Workout>> workoutsInitialStream();
  Stream<List<Workout>> workoutsStream();

  /// Routine
  Future<void> setRoutine(Routine routine);
  Future<void> deleteRoutine(Routine routine);
  Stream<List<Routine>> routinesStream();
  Stream<List<Routine>> routinesInitialStream();
  Stream<List<Routine>> routinesSearchStream(String tag, String searchCategory);

  /// History
  Stream<List<RoutineHistory>> routineHistoriesStream();

  /// Routine Workout (Sets)
  Future<void> setRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Future<void> deleteRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine);
  // Future updateUserData(String name, String userEmail);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    @required this.uid,
    @required this.workoutId,
    @required this.routineId,
  });
  // : assert(
  //     routineId != null,
  //     uid != null,
  //     // workoutId != null,
  //   );

  final String uid;
  final String workoutId;
  final String routineId;

  final _service = FirestoreService.instance;

  /// Users
  // Add or edit User Data
  @override
  Future<void> setUser(User user) => _service.setData(
        path: APIPath.user(user.userId),
        data: user.toMap(),
      );

  /// Workouts
  // Add or edit workout data
  @override
  Future<void> setWorkout(Workout workout) => _service.setData(
        path: APIPath.workout(workout.workoutId),
        data: workout.toMap(),
      );

  // Delete workout data
  @override
  Future<void> deleteWorkout(Workout workout) async => _service.deleteData(
        path: APIPath.workout(workout.workoutId),
      );

  // Workout Stream for Initial Search Screen
  @override
  Stream<List<Workout>> workoutsInitialStream() =>
      _service.initialCollectionStream(
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  // Stream for all available Workouts
  @override
  Stream<List<Workout>> workoutsStream() => _service.collectionStream(
        order: 'workoutTitle',
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  /// Routine
  // Add or edit Routine
  @override
  Future<void> setRoutine(Routine routine) => _service.setData(
        path: APIPath.routine(routine.routineId),
        data: routine.toMap(),
      );

  // Delete Routine data
  @override
  Future<void> deleteRoutine(Routine routine) async => _service.deleteData(
        path: APIPath.routine(routine.routineId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesInitialStream() =>
      _service.initialCollectionStream(
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesStream() => _service.collectionStream(
        order: 'routineTitle',
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesSearchStream(
          String tag, String searchCategory) =>
      _service.searchCollectionStream(
        order: 'routineTitle',
        tag: tag,
        searchCategory: searchCategory,
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  /// Workout History
  // Workout History Stream
  @override
  Stream<List<RoutineHistory>> routineHistoriesStream() =>
      _service.collectionStream(
        order: 'workedOutTime',
        path: APIPath.routineHistories(),
        builder: (data, documentId) => RoutineHistory.fromMap(data, documentId),
      );

  /// Saved Workouts
  @override
  Stream<List<Workout>> savedWorkoutsStream() => _service.collectionStream(
        order: 'workoutTitle',
        path: APIPath.savedWorkouts(uid),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  /// Workout routines for the routines
  // Add or edit Routine
  @override
  Future<void> setRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout) =>
      _service.setData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: routine.toMap(),
      );

  // Delete Routine data
  @override
  Future<void> deleteRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout) async =>
      _service.deleteData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
      );

  // Workout Routine Stream
  @override
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine) =>
      _service.collectionStream(
        order: 'index',
        path: APIPath.routineWorkouts(routine.routineId),
        builder: (data, documentId) => RoutineWorkout.fromMap(data, documentId),
      );
}
