import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/saved_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/api_path.dart';
import 'package:workout_player/services/firestore_service.dart';

abstract class Database {
  /// User
  Future<void> setUser(User user);
  Future<void> updateUser(String userId, Map data);
  Stream<User> userStream({String userId});
  Future<void> setSavedWorkout(SavedWorkout savedWorkout);
  Stream<SavedWorkout> savedWorkoutStream({String workoutId});
  Stream<List<SavedWorkout>> savedWorkoutsStream();

  /// Workout
  Future<void> setWorkout(Workout workout);
  Future<void> deleteWorkout(Workout workout);
  Stream<Workout> workoutStream({String workoutId});
  Stream<List<Workout>> workoutsInitialStream();
  Stream<List<Workout>> workoutsStream();
  Stream<List<Workout>> workoutsSearchStream(String tag, String searchCategory);

  /// Routine
  Future<void> setRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine, Map data);
  Future<void> deleteRoutine(Routine routine);
  Stream<Routine> routineStream({String routineId});
  Stream<List<Routine>> routinesStream();
  Stream<List<Routine>> routinesInitialStream();
  Stream<List<Routine>> routinesSearchStream(String tag, String searchCategory);

  /// History
  Stream<List<RoutineHistory>> routineHistoriesStream();

  /// Routine Workout
  Future<void> setRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Future<void> deleteRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine);

  /// Individual Set inside Routine Workouts
  Future<void> setWorkoutSet(
    Routine routine,
    RoutineWorkout routineWorkout,
    Map data,
  );
  // Future<void> editWorkoutSet(
  //   Routine routine,
  //   RoutineWorkout routineWorkout,
  //   Map oldData,
  //   Map newData,
  // );
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    @required this.userId,
    @required this.workoutId,
    @required this.routineId,
  });
  // : assert(
  //     routineId != null,
  //     userId != null,
  //     workoutId != null,
  //   );

  final String userId;
  final String workoutId;
  final String routineId;

  final _service = FirestoreService.instance;

  /// Users
  //  Stream of Single Workout Stream
  @override
  Stream<User> userStream({String userId}) => _service.documentStream(
        path: APIPath.user(userId),
        builder: (data, documentId) => User.fromMap(data, documentId),
      );

  // Add or edit User Data
  @override
  Future<void> setUser(User user) => _service.setData(
        path: APIPath.user(user.userId),
        data: user.toMap(),
      );

  // Update User Data
  @override
  Future<void> updateUser(String userId, Map data) => _service.updateData(
        path: APIPath.user(userId),
        data: data,
      );

  // /// Workout Sets
  // // Create or delete Workout Set
  // @override
  // Future<void> setWorkoutSet(
  //     Routine routine,
  //     RoutineWorkout routineWorkout,
  //     Map data,
  //     ) =>
  //     _service.updateData(
  //       path: APIPath.routineWorkout(
  //           routine.routineId, routineWorkout.routineWorkoutId),
  //       data: data,
  //     );

  // Set saved Workout
  @override
  Future<void> setSavedWorkout(SavedWorkout savedWorkout) => _service.setData(
        path: APIPath.savedWorkout(userId, savedWorkout.workoutId),
        data: savedWorkout.toMap(),
      );

  // Saved Workouts Stream (All the Documents)
  @override
  Stream<List<SavedWorkout>> savedWorkoutsStream() =>
      _service.collectionStreamWithoutOrder(
        path: APIPath.savedWorkouts(userId),
        builder: (data, documentId) => SavedWorkout.fromMap(data, documentId),
      );

  // Stream of Saved Workout (Single Document)
  @override
  Stream<SavedWorkout> savedWorkoutStream({String workoutId}) =>
      _service.documentStream(
        path: APIPath.savedWorkout(userId, workoutId),
        builder: (data, documentId) => SavedWorkout.fromMap(data, documentId),
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

  // Stream of Single Workout Stream
  @override
  Stream<Workout> workoutStream({String workoutId}) => _service.documentStream(
        path: APIPath.workout(workoutId),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
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

  // Workout Search Stream
  @override
  Stream<List<Workout>> workoutsSearchStream(
          String tag, String searchCategory) =>
      _service.searchCollectionStream(
        order: 'workoutTitle',
        tag: tag,
        searchCategory: searchCategory,
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  /// Routine
  // Add Routine
  @override
  Future<void> setRoutine(Routine routine) => _service.setData(
        path: APIPath.routine(routine.routineId),
        data: routine.toMap(),
      );

  // Edit Routine
  @override
  Future<void> updateRoutine(Routine routine, Map data) => _service.updateData(
        path: APIPath.routine(routine.routineId),
        data: data,
      );

  // Delete Routine data
  @override
  Future<void> deleteRoutine(Routine routine) async => _service.deleteData(
        path: APIPath.routine(routine.routineId),
      );

  // Single Routine Stream
  @override
  Stream<Routine> routineStream({String routineId}) => _service.documentStream(
        path: APIPath.routine(routineId),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
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

  /// Routine Workouts
  // Add or edit Routine Workout
  @override
  Future<void> setRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout) =>
      _service.setData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: routineWorkout.toJson(),
      );

  // Delete Routine data
  @override
  Future<void> deleteRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout) async =>
      _service.deleteData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
      );

  // Routine Workout Stream
  @override
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine) =>
      _service.collectionStream(
        order: 'index',
        path: APIPath.routineWorkouts(routine.routineId),
        builder: (data, documentId) =>
            RoutineWorkout.fromJson(data, documentId),
      );

  /// Workout Sets
  // Create or delete Workout Set
  @override
  Future<void> setWorkoutSet(
    Routine routine,
    RoutineWorkout routineWorkout,
    Map data,
  ) =>
      _service.updateData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: data,
      );

  // // Edit existing Workout Set of Routine Workout
  // @override
  // Future<void> editWorkoutSet(
  //   Routine routine,
  //   RoutineWorkout routineWorkout,
  //   Map oldData,
  //   Map newData,
  // ) =>
  //     _service.editData(
  //       path: APIPath.routineWorkout(
  //           routine.routineId, routineWorkout.routineWorkoutId),
  //       oldData: oldData,
  //       newData: newData,
  //     );

  /// Workout History
  // Workout History Stream
  @override
  Stream<List<RoutineHistory>> routineHistoriesStream() =>
      _service.collectionStream(
        order: 'workedOutTime',
        path: APIPath.routineHistories(),
        builder: (data, documentId) => RoutineHistory.fromMap(data, documentId),
      );
}
