import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/saved_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/user_feedback.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/api_path.dart';
import 'package:workout_player/services/firestore_service.dart';

abstract class Database {
  /// User
  Future<void> getUser(String userId, User user);
  Future<void> setUser(User user);
  Future<void> updateUser(String userId, Map data);
  Stream<User> userStream({String userId});
  Future<void> setSavedWorkout(SavedWorkout savedWorkout);
  Stream<SavedWorkout> savedWorkoutStream({String workoutId});
  Stream<List<SavedWorkout>> savedWorkoutsStream();

  /// User Feedback
  Future<void> setUserFeedback(UserFeedback userFeedback);

  /// Workout
  Future<void> setWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout, Map data);
  Future<void> deleteWorkout(Workout workout);
  Stream<Workout> workoutStream({String workoutId});
  Stream<List<Workout>> workoutsStream({int limit});
  Stream<List<Workout>> userWorkoutsStream({int limit});
  Stream<List<Workout>> workoutsSearchStream({
    String isEqualTo,
    String arrayContains,
    String searchCategory,
    int limit,
  });

  /// Routine
  Future<void> setRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine, Map data);
  Future<void> deleteRoutine(Routine routine);
  Stream<Routine> routineStream({String routineId});
  Stream<List<Routine>> routinesStream({int limit});
  Stream<List<Routine>> userRoutinesStream({int limit});
  Stream<List<Routine>> routinesSearchStream({
    String isEqualTo,
    String arrayContains,
    String searchCategory,
    int limit,
  });
  Stream<List<Routine>> routinesSearchStream2({
    String searchCategory,
    String arrayContains,
    String searchCategory2,
    String arrayContains2,
    int limit,
  });
  Stream<List<Routine>> routinesSearchStream3({
    String searchCategory,
    String arrayContains,
    int limit,
  });

  /// Routine Workout
  Future<void> setRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Future<void> deleteRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Future<void> updateRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout, Map data);
  Stream<RoutineWorkout> routineWorkoutStream(
    Routine routine,
    RoutineWorkout routineWorkout,
  );
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine);

  /// Individual Set inside Routine Workouts
  Future<void> setWorkoutSet(
    Routine routine,
    RoutineWorkout routineWorkout,
    Map data,
  );

  /// Routine History
  Future<void> setRoutineHistory(RoutineHistory routineHistory);
  Future<void> updateRoutineHistory(RoutineHistory routineHistory, Map data);
  Future<void> deleteRoutineHistory(RoutineHistory routineHistory);
  Stream<RoutineHistory> routineHistoryStream({String routineHistoryId});
  Stream<List<RoutineHistory>> routineHistoriesStream();
  Stream<List<RoutineHistory>> routineHistoriesPublicStream();
  Future<void> setRoutineWorkoutForHistory(
    RoutineHistory routineHistory,
    RoutineWorkout routineWorkout,
  );
  Future<void> deleteRoutineWorkoutForHistory(
    RoutineHistory routineHistory,
    RoutineWorkout routineWorkout,
  );
  Stream<List<RoutineWorkout>> routineWorkoutsStreamForHistory(
    RoutineHistory routineHistory,
  );

  Future<void> batchRoutineWorkouts(
    RoutineHistory routineHistory,
    List<RoutineWorkout> routineWorkout,
  );
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    @required this.userId,
    @required this.workoutId,
    @required this.routineId,
  });

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

  // Get User Data
  @override
  Future<void> getUser(String userId, User user) => _service.getData(
        path: APIPath.user(userId),
        data: user.toMap(),
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

  // Set saved Workout
  @override
  Future<void> setSavedWorkout(SavedWorkout savedWorkout) => _service.setData(
        path: APIPath.savedWorkout(userId, savedWorkout.workoutId),
        data: savedWorkout.toMap(),
      );

  // Saved Workouts Stream (All the Documents)
  @override
  Stream<List<SavedWorkout>> savedWorkoutsStream() => _service.collectionStream(
        path: APIPath.savedWorkouts(userId),
        builder: (data, documentId) => SavedWorkout.fromMap(data, documentId),
        order: 'workoutTitle',
        descending: false,
      );

  // Stream of Saved Workout (Single Document)
  @override
  Stream<SavedWorkout> savedWorkoutStream({String workoutId}) =>
      _service.documentStream(
        path: APIPath.savedWorkout(userId, workoutId),
        builder: (data, documentId) => SavedWorkout.fromMap(data, documentId),
      );

  /// User Feedback
  // Add or edit User Data
  @override
  Future<void> setUserFeedback(UserFeedback userFeedback) => _service.setData(
        path: APIPath.userFeedback(userFeedback.userFeedbackId),
        data: userFeedback.toMap(),
      );

  /// Workouts
  // Add or edit workout data
  @override
  Future<void> setWorkout(Workout workout) => _service.setData(
        path: APIPath.workout(workout.workoutId),
        data: workout.toMap(),
      );

  // Edit Routine
  @override
  Future<void> updateWorkout(Workout workout, Map data) => _service.updateData(
        path: APIPath.workout(workout.workoutId),
        data: data,
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

  // Stream for all available Workouts
  @override
  Stream<List<Workout>> workoutsStream({int limit}) =>
      _service.publicCollectionStream(
        order: 'workoutTitle',
        descending: false,
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
        limit: limit,
      );

  // Workout Stream for specific User
  @override
  Stream<List<Workout>> userWorkoutsStream({int limit}) =>
      _service.userCollectionStream(
        searchCategory: 'workoutOwnerId',
        searchString: userId,
        order: 'workoutTitle',
        descending: false,
        limit: limit,
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  // Workout Search Stream
  @override
  Stream<List<Workout>> workoutsSearchStream(
          {String isEqualTo,
          String arrayContains,
          String searchCategory,
          int limit}) =>
      _service.publicSearchCollectionStream(
        order: 'workoutTitle',
        isEqualTo: isEqualTo,
        arrayContains: arrayContains,
        searchCategory: searchCategory,
        limit: limit,
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

  // All Public Routines Stream
  @override
  Stream<List<Routine>> routinesStream({int limit}) =>
      _service.publicCollectionStream(
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
        order: 'routineTitle',
        descending: false,
        limit: limit,
      );

  // Single Routine Stream
  @override
  Stream<Routine> routineStream({String routineId}) => _service.documentStream(
        path: APIPath.routine(routineId),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine Stream for specific User
  @override
  Stream<List<Routine>> userRoutinesStream({int limit}) =>
      _service.userCollectionStream(
        searchCategory: 'routineOwnerId',
        searchString: userId,
        order: 'routineTitle',
        descending: false,
        limit: limit,
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesSearchStream({
    String isEqualTo,
    String arrayContains,
    String searchCategory,
    int limit,
  }) =>
      _service.publicSearchCollectionStream(
        order: 'routineTitle',
        isEqualTo: isEqualTo,
        arrayContains: arrayContains,
        searchCategory: searchCategory,
        limit: limit,
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesSearchStream2({
    String searchCategory,
    String arrayContains,
    String searchCategory2,
    String arrayContains2,
    int limit,
  }) =>
      _service.publicSearchCollectionStream2(
        order: 'routineTitle',
        searchCategory: searchCategory,
        arrayContains: arrayContains,
        searchCategory2: searchCategory2,
        arrayContains2: arrayContains2,
        limit: limit,
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesSearchStream3({
    String searchCategory,
    String arrayContains,
    int limit,
  }) =>
      _service.publicSearchCollectionStream3(
        order: 'routineTitle',
        searchCategory: searchCategory,
        arrayContains: arrayContains,
        limit: limit,
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

  // Edit Routine
  @override
  Future<void> updateRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout, Map data) =>
      _service.updateData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: data,
      );

  // Single Routine Workout Stream
  @override
  Stream<RoutineWorkout> routineWorkoutStream(
          Routine routine, RoutineWorkout routineWorkout) =>
      _service.documentStream(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        builder: (data, documentId) =>
            RoutineWorkout.fromJson(data, documentId),
      );

  // Routine Workout Stream
  @override
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine) =>
      _service.collectionStream(
        order: 'index',
        descending: false,
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

  /// Workout History
  // Add or edit workout data
  @override
  Future<void> setRoutineHistory(RoutineHistory routineHistory) =>
      _service.setData(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
        data: routineHistory.toMap(),
      );

  // Add or edit workout data
  @override
  Future<void> updateRoutineHistory(RoutineHistory routineHistory, Map data) =>
      _service.updateData(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
        data: data,
      );

  // Delete workout data
  @override
  Future<void> deleteRoutineHistory(RoutineHistory routineHistory) async =>
      _service.deleteData(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
      );

  // Stream of Single Workout Stream
  @override
  Stream<RoutineHistory> routineHistoryStream({String routineHistoryId}) =>
      _service.documentStream(
        path: APIPath.routineHistory(routineHistoryId),
        builder: (data, documentId) => RoutineHistory.fromMap(data, documentId),
      );

  // Workout History Stream for each User
  @override
  Stream<List<RoutineHistory>> routineHistoriesStream() =>
      _service.userCollectionStream(
        searchCategory: 'userId',
        searchString: userId,
        order: 'workoutEndTime',
        descending: true,
        path: APIPath.routineHistories(),
        builder: (data, documentId) => RoutineHistory.fromMap(data, documentId),
      );

  @override
  Stream<List<RoutineHistory>> routineHistoriesPublicStream() =>
      _service.publicCollectionStream(
        order: 'workoutEndTime',
        descending: true,
        path: APIPath.routineHistories(),
        builder: (data, documentId) => RoutineHistory.fromMap(data, documentId),
      );

  /// Routine Workouts for Routine History
  // Add or edit Routine Workout
  @override
  Future<void> setRoutineWorkoutForHistory(
          RoutineHistory routineHistory, RoutineWorkout routineWorkout) =>
      _service.setData(
        path: APIPath.routineWorkoutForHistory(
            routineHistory.routineHistoryId, routineWorkout.routineWorkoutId),
        data: routineWorkout.toJson(),
      );

  // Add or edit Routine Workout
  @override
  Future<void> batchRoutineWorkouts(
    RoutineHistory routineHistory,
    List<RoutineWorkout> routineWorkout,
  ) async {
    debugPrint('batchRoutineWorkouts pressed');

    final List<String> routineWorkoutIds = [];
    final List<Map<String, dynamic>> routineWorkoutsAsMap = [];
    routineWorkout.forEach((routineWorkout) {
      var routineWorkoutToJson = routineWorkout.toJson();
      var id = APIPath.routineWorkoutForHistory(
          routineHistory.routineHistoryId, routineWorkout.routineWorkoutId);
      routineWorkoutsAsMap.add(routineWorkoutToJson);
      routineWorkoutIds.add(id);
    });

    await _service.batchData(
      path: routineWorkoutIds,
      data: routineWorkoutsAsMap,
    );
  }

  // Delete Routine data
  @override
  Future<void> deleteRoutineWorkoutForHistory(
          RoutineHistory routineHistory, RoutineWorkout routineWorkout) async =>
      _service.deleteData(
        path: APIPath.routineWorkoutForHistory(
            routineHistory.routineHistoryId, routineWorkout.routineWorkoutId),
      );

  // Routine Workout Stream
  @override
  Stream<List<RoutineWorkout>> routineWorkoutsStreamForHistory(
    RoutineHistory routineHistory,
  ) =>
      _service.collectionStream(
        order: 'index',
        descending: false,
        path:
            APIPath.routineWorkoutsForHistory(routineHistory.routineHistoryId),
        builder: (data, documentId) =>
            RoutineWorkout.fromJson(data, documentId),
      );
}
