import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/user_feedback.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/services/api_path.dart';
import 'package:workout_player/services/firestore_service.dart';

///
///
///
/// `riverpod`
///
final databaseProvider = Provider.family<FirestoreDatabase, String>(
  (ref, uid) => FirestoreDatabase(userId: uid),
);

final userStreamProvider = StreamProvider.family<User?, String>((ref, id) {
  final database = ref.watch(databaseProvider(id));
  return database.userStream(id);
});

final todaysNutritionStreamProvider =
    StreamProvider.family<List<Nutrition>?, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.todaysNutritionStream(uid);
});

final thisWeeksNutritionsStreamProvider =
    StreamProvider.family<List<Nutrition>?, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.thisWeeksNutritionsStream(uid);
});

final todaysRHStreamProvider =
    StreamProvider.family<List<RoutineHistory>?, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.routineHistoryTodayStream(uid);
});

final workoutStreamProvider = StreamProvider.family<Workout?, String>(
  (ref, id) {
    final database = ref.watch(databaseProvider(id));
    return database.workoutStream(workoutId: id);
  },
);

final rhOfThisWeekStreamProvider =
    StreamProvider.autoDispose.family<List<RoutineHistory>?, String>(
  (ref, uid) {
    final database = ref.watch(databaseProvider(uid));
    return database.routineHistoriesThisWeekStream(uid);
  },
);

///
///
///
///
/// `Abstract class Database`
///
abstract class Database {
  /////////////// `User` ////////////////
  // FUTURE
  // Future<void> getUser(User user);
  Future<void> setUser(User user);
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  Future<User?> getUserDocument(String uid);

  // Stream
  Stream<User> userStream(String uid);

  //////////////////// `Body Measurement` //////////////////////
  Future<void> setMeasurement({
    required String uid,
    required Measurement measurement,
  });
  Future<void> updateMeasurement({
    required String uid,
    required String measurementId,
    required Map<String, dynamic> data,
  });
  Future<void> deleteMeasurement({
    required String uid,
    required Measurement measurement,
  });
  Stream<List<Measurement>> measurementsStream(String uid);
  Stream<List<Measurement>> measurementsStreamThisWeek(String uid);

  // Query
  Query measurementsQuery(String uid);

  //////////////////// `Nutrition` /////////////////////
  //Future
  Future<void> setNutrition(Nutrition nutrition);
  Future<void> updateNutrition({
    required Nutrition nutrition,
    required Map<String, dynamic> data,
  });
  Future<void> deleteNutrition(Nutrition nutrition);

  // Stream
  Stream<List<Nutrition>> userNutritionStream({int limit});
  Stream<List<Nutrition>?> todaysNutritionStream(String uid);
  Stream<List<Nutrition>?> thisWeeksNutritionsStream(String uid);

  // Query
  Query nutritionsPaginatedUserQuery();

  /////////////////// `User Feedback` /////////////////////
  Future<void> setUserFeedback(UserFeedback userFeedback);

  //////////////// `Workout` ///////////////
  // FUTURE
  Future<void> setWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout, Map<String, dynamic> data);
  Future<void> deleteWorkout(Workout workout);
  Future<Workout?> getWorkout(String workoutId);

  // STREAM
  Stream<Workout> workoutStream({required String workoutId});
  Stream<List<Workout>> workoutsStream({int limit});
  Stream<List<Workout>> userWorkoutsStream({int limit});
  Stream<List<Workout>> workoutsSearchStream({
    String? isEqualTo,
    String? arrayContains,
    String? searchCategory,
    int? limit,
  });

  // QUERY
  Query workoutsPaginatedUserQuery();
  Query workoutsSearchQuery();

  // BATCH
  Future<void> batchUpdateWorkouts(List<Map<String, dynamic>> workouts);

  /////////// `Routine` ////////////////
  // FUTURE
  Future<void> setRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine, Map<String, dynamic> data);
  Future<void> deleteRoutine(Routine routine);
  Future<Routine?> getRoutine(String routineId);
  // Stream<Routine> getRoutine2(String routineId);

  // STREAM
  Stream<Routine> routineStream({required String routineId});
  Stream<List<Routine>> routinesStream({int limit});
  Stream<List<Routine>> userRoutinesStream({int limit});
  Stream<List<Routine>> routinesSearchStream({
    String? isEqualTo,
    String? arrayContains,
    String? searchCategory,
    int? limit,
  });
  Stream<List<Routine>> routinesSearchStream2({
    String? searchCategory,
    String? arrayContains,
    String? searchCategory2,
    String? arrayContains2,
    int? limit,
  });
  Stream<List<Routine>> routinesSearchStream3({
    String? searchCategory,
    String? arrayContains,
    int? limit,
  });

  // QUERY
  Query routinesPaginatedPublicQuery();
  Query routinesPaginatedUserQuery();
  Query routinesSearchQuery();

  // Batch
  Future<void> batchUpdateRoutines(List<Map<String, dynamic>> routines);

  ///////////////// `Routine Workout` //////////////////
  Future<void> setRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Future<void> deleteRoutineWorkout(
      Routine routine, RoutineWorkout routineWorkout);
  Future<void> updateRoutineWorkout({
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required Map<String, dynamic> data,
  });
  Stream<RoutineWorkout> routineWorkoutStream(
    Routine routine,
    RoutineWorkout routineWorkout,
  );
  Stream<List<RoutineWorkout>> routineWorkoutsStream(Routine routine);

  Future<void> setWorkoutSet({
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required Map<String, dynamic> data,
  });

  ///////////// `Routine History` //////////////
  // FUTURE
  Future<void> setRoutineHistory(RoutineHistory routineHistory);
  Future<void> updateRoutineHistory(
    RoutineHistory routineHistory,
    Map<String, dynamic> data,
  );
  Future<void> deleteRoutineHistory(RoutineHistory routineHistory);
  Future<void> setRoutineWorkoutForHistory(
    RoutineHistory routineHistory,
    RoutineWorkout routineWorkout,
  );
  Future<void> deleteRoutineWorkoutForHistory(
    RoutineHistory routineHistory,
    RoutineWorkout routineWorkout,
  );
  Future<void> batchRoutineWorkouts(
    RoutineHistory routineHistory,
    List<RoutineWorkout> routineWorkout,
  );

  // STREAM
  Stream<RoutineHistory> routineHistoryStream(
      {required String routineHistoryId});
  Stream<List<RoutineHistory>> routineHistoriesStream();
  Stream<List<RoutineHistory>?> routineHistoryTodayStream(String uid);
  Stream<List<RoutineHistory>?> routineHistoriesThisWeekStream(String uid);
  Stream<List<RoutineHistory>> routineHistoriesPublicStream();
  Stream<List<RoutineWorkout>> routineWorkoutsStreamForHistory(
    RoutineHistory routineHistory,
  );

  // QUERY
  Query routineHistoriesPaginatedPublicQuery();
  Query routineHistoriesPaginatedUserQuery();
  Future<void> batchUpdateRoutineHistories(
    List<Map<String, dynamic>> routineHistories,
  );

  ///////////// `Workout History` /////////////////
  Future<void> setWorkoutHistory(WorkoutHistory workoutHistory);
  Future<void> updateWorkoutHistory(
    WorkoutHistory workoutHistory,
    Map<String, dynamic> data,
  );
  Future<void> deleteWorkoutHistory(WorkoutHistory workoutHistory);
  Future<void> batchWriteWorkoutHistories(
    List<WorkoutHistory> workoutHistories,
  );
  Future<void> batchDeleteWorkoutHistories(
    List<WorkoutHistory> workoutHistories,
  );
  Stream<List<WorkoutHistory>> workoutHistoriesStream(String routineHistoryId);
}

///
///
///
/// `FirestoreDatabase`
///
///

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    this.userId,
  });

  final String? userId;

  final _service = FirestoreService.instance;

  ////////////////////////// `Users` /////////////////////////////
  // Add or edit User Data
  @override
  Future<void> setUser(User user) => _service.setData(
        path: APIPath.user(user.userId),
        data: user.toJson(),
      );

  // Update User Data
  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _service.updateData(
        path: APIPath.user(uid),
        data: data,
      );

  // Single User Data
  @override
  Future<User?> getUserDocument(String uid) => _service.getDocument(
        path: APIPath.user(uid),
        builder: (data, documentId) => User.fromJson(data, documentId),
      );

  // Single User Stream
  @override
  Stream<User> userStream(String uid) => _service.documentStream(
        path: APIPath.user(uid),
        builder: (data, documentId) => User.fromJson(data, documentId),
      );

  //////////////////////// `Body Measurement` ///////////////////////////
  // Add or edit Body Measurement Data
  @override
  Future<void> setMeasurement({
    required String uid,
    required Measurement measurement,
  }) =>
      _service.setData(
        path: APIPath.measurement(
          uid,
          measurement.measurementId,
        ),
        data: measurement.toMap(),
      );

  // Update Body Measurement Data
  @override
  Future<void> updateMeasurement({
    required String uid,
    required String measurementId,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData(
        path: APIPath.measurement(uid, measurementId),
        data: data,
      );

  // Delete Body Measurement Data
  @override
  Future<void> deleteMeasurement({
    required String uid,
    required Measurement measurement,
  }) async =>
      _service.deleteData(
        path: APIPath.measurement(uid, measurement.measurementId),
      );

  // Body Measurements Stream for User
  @override
  Stream<List<Measurement>> measurementsStream(String uid) =>
      _service.collectionStream(
        order: 'loggedTime',
        descending: true,
        path: APIPath.measurements(uid),
        builder: (data, documentId) => Measurement.fromMap(data, documentId),
      );

  // Body Measurements Stream for User
  @override
  Stream<List<Measurement>> measurementsStreamThisWeek(String uid) =>
      _service.collectionStreamOfThisWeek(
        path: APIPath.measurements(uid),
        dateVariableName: 'loggedDate',
        builder: (data, documentId) => Measurement.fromMap(data, documentId),
      );

  // Measurements Query
  // Nutrition Query for specfic User
  @override
  Query measurementsQuery(String uid) => _service.paginatedCollectionQuery(
        path: APIPath.measurements(uid),
        order: 'loggedTime',
        descending: true,
      );

  ////////////////////////// `Nutrition` ///////////////////////////////
  // Set
  @override
  Future<void> setNutrition(Nutrition nutrition) => _service.setData(
        path: APIPath.nutrition(nutrition.nutritionId),
        data: nutrition.toMap(),
      );

  // Edit Routine
  @override
  Future<void> updateNutrition({
    required Nutrition nutrition,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData(
        path: APIPath.nutrition(nutrition.nutritionId),
        data: data,
      );

  // Delete workout data
  @override
  Future<void> deleteNutrition(Nutrition nutrition) async =>
      _service.deleteData(
        path: APIPath.nutrition(nutrition.nutritionId),
      );

  // Nutrition Stream for specific User
  @override
  Stream<List<Nutrition>> userNutritionStream({int limit = 10}) =>
      _service.userCollectionStream(
        searchCategory: 'userId',
        searchString: userId,
        order: 'loggedTime',
        descending: true,
        limit: limit,
        path: APIPath.nutritions(),
        builder: (data, documentId) => Nutrition.fromMap(data, documentId),
      );

  // Stream of Today's Nutrition Entries
  @override
  Stream<List<Nutrition>?> todaysNutritionStream(String uid) =>
      _service.collectionStreamOfToday(
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'loggedDate',
        orderVariableName: 'loggedTime',
        path: APIPath.nutritions(),
        builder: (data, documentId) => Nutrition.fromMap(data, documentId),
      );

  // Stream of This Week's Nutrition Entries
  @override
  Stream<List<Nutrition>?> thisWeeksNutritionsStream(String uid) =>
      _service.collectionStreamOfThisWeek(
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'loggedTime',
        path: APIPath.nutritions(),
        builder: (data, documentId) => Nutrition.fromMap(data, documentId),
      );

  // Nutrition Query for specfic User
  @override
  Query nutritionsPaginatedUserQuery() => _service.paginatedUserCollectionQuery(
        path: APIPath.nutritions(),
        order: 'loggedTime',
        descending: true,
        id: 'userId',
        userId: userId,
      );

  /////////////////////// `User Feedback` /////////////////////
  // Add or edit User Data
  @override
  Future<void> setUserFeedback(UserFeedback userFeedback) => _service.setData(
        path: APIPath.userFeedback(userFeedback.userFeedbackId),
        data: userFeedback.toMap(),
      );

  //////////////////////// `Workouts` /////////////////////
  // Add or edit workout data
  @override
  Future<void> setWorkout(Workout workout) => _service.setData(
        path: APIPath.workout(workout.workoutId),
        data: workout.toMap(),
      );

  // Edit Workout
  @override
  Future<void> updateWorkout(Workout workout, Map<String, dynamic> data) =>
      _service.updateData(
        path: APIPath.workout(workout.workoutId),
        data: data,
      );

  // Delete workout data
  @override
  Future<void> deleteWorkout(Workout workout) async => _service.deleteData(
        path: APIPath.workout(workout.workoutId),
      );

  // Get Workojut
  @override
  Future<Workout?> getWorkout(String workoutId) async =>
      _service.getDocument<Workout>(
        path: APIPath.workout(workoutId),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  // Stream of Single Workout Stream
  @override
  Stream<Workout> workoutStream({required String workoutId}) =>
      _service.documentStream(
        path: APIPath.workout(workoutId),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  // Stream for all available Workouts
  @override
  Stream<List<Workout>> workoutsStream({int? limit}) =>
      _service.publicCollectionStream(
        order: 'workoutTitle',
        descending: false,
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
        limit: limit,
      );

  // Workout Stream for specific User
  @override
  Stream<List<Workout>> userWorkoutsStream({int? limit}) =>
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
  Stream<List<Workout>> workoutsSearchStream({
    String? isEqualTo,
    String? arrayContains,
    String? searchCategory,
    int? limit,
  }) =>
      _service.publicSearchCollectionStream(
        order: 'workoutTitle',
        isEqualTo: isEqualTo,
        arrayContains: arrayContains,
        searchCategory: searchCategory,
        limit: limit,
        path: APIPath.workouts(),
        builder: (data, documentId) => Workout.fromMap(data, documentId),
      );

  // Paginated Workouts Query for specific user
  @override
  Query workoutsPaginatedUserQuery() => _service.paginatedUserCollectionQuery(
        path: APIPath.workouts(),
        order: 'workoutTitle',
        descending: false,
        id: 'workoutOwnerId',
        userId: userId,
      );

  // Paginated Routines Query for specific user
  @override
  Query workoutsSearchQuery() => _service.paginatedPublicCollectionQuery(
        path: APIPath.workouts(),
        order: 'workoutTitle',
        descending: false,
      );

  /// BATCH
  // Batch Update of Workout
  @override
  Future<void> batchUpdateWorkouts(
    List<Map<String, dynamic>> workouts,
  ) async {
    final workoutId = <String>[];

    workouts.forEach((element) {
      var id = APIPath.workout(element['workoutId']);
      workoutId.add(id);
    });

    await _service.batchUpdateData(
      path: workoutId,
      data: workouts,
    );
  }

  /////////////// `Routine` /////////////////////
  // Add Routine
  @override
  Future<void> setRoutine(Routine routine) => _service.setData(
        path: APIPath.routine(routine.routineId),
        data: routine.toMap(),
      );

  // Edit Routine
  @override
  Future<void> updateRoutine(Routine routine, Map<String, dynamic> data) =>
      _service.updateData(
        path: APIPath.routine(routine.routineId),
        data: data,
      );

  // Delete Routine data
  @override
  Future<void> deleteRoutine(Routine routine) async => _service.deleteData(
        path: APIPath.routine(routine.routineId),
      );

  // Get Routine
  @override
  Future<Routine?> getRoutine(String routineId) async =>
      _service.getDocument<Routine>(
        path: APIPath.routine(routineId),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // // Get Routine
  // @override
  // Stream<Routine> getRoutine2(String routineId) =>
  //     _service.documentStream<Routine>(
  //       path: APIPath.routine(routineId),
  //       builder: (data, documentId) => Routine.fromMap(data, documentId),
  //     );

  // All Public Routines Stream
  @override
  Stream<List<Routine>> routinesStream({int? limit}) =>
      _service.publicCollectionStream(
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
        order: 'routineTitle',
        descending: false,
        limit: limit,
      );

  // Single Routine Stream
  @override
  Stream<Routine> routineStream({required String routineId}) =>
      _service.documentStream(
        path: APIPath.routine(routineId),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine Stream for specific User
  @override
  Stream<List<Routine>> userRoutinesStream({int? limit}) =>
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
    String? isEqualTo,
    String? arrayContains,
    String? searchCategory,
    int? limit,
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
    String? searchCategory,
    String? arrayContains,
    String? searchCategory2,
    String? arrayContains2,
    int? limit,
  }) =>
      _service.publicSearchCollectionStream2(
        order: 'routineTitle',
        searchCategory: searchCategory,
        arrayContains: arrayContains,
        searchCategory2: searchCategory2,
        arrayContains2: arrayContains2,
        limit: limit ?? 10,
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesSearchStream3({
    String? searchCategory,
    String? arrayContains,
    int? limit,
  }) =>
      _service.publicSearchCollectionStream3(
        order: 'routineTitle',
        searchCategory: searchCategory,
        arrayContains: arrayContains,
        limit: limit ?? 10,
        path: APIPath.routines(),
        builder: (data, documentId) => Routine.fromMap(data, documentId),
      );

  // Batch Update of Routine
  @override
  Future<void> batchUpdateRoutines(
    List<Map<String, dynamic>> routines,
  ) async {
    final routineId = <String>[];

    routines.forEach((element) {
      var id = APIPath.routine(element['routineId']);
      routineId.add(id);
    });

    await _service.batchUpdateData(
      path: routineId,
      data: routines,
    );
  }

  /////////////////// `Routine Workouts` ///////////////////
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
  Future<void> updateRoutineWorkout({
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required Map<String, dynamic> data,
  }) =>
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

  // Paginated Routines Query for specific user
  @override
  Query routinesPaginatedPublicQuery() =>
      _service.paginatedPublicCollectionQuery(
        path: APIPath.routines(),
        order: 'routineTitle',
        descending: false,
      );

  @override
  Query routinesPaginatedUserQuery() => _service.paginatedUserCollectionQuery(
        path: APIPath.routines(),
        order: 'routineTitle',
        descending: false,
        id: 'routineOwnerId',
        userId: userId,
      );

  // Paginated Routines Query for specific user
  @override
  Query routinesSearchQuery() => _service.paginatedPublicCollectionQuery(
        path: APIPath.routines(),
        order: 'routineTitle',
        descending: false,
      );

//////////////// `Workout Sets` ///////////////////
  // Create or delete Workout Set
  @override
  Future<void> setWorkoutSet({
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: data,
      );

  /////////////////////////// `Routine History` //////////////////////////
  // Add or edit workout data
  @override
  Future<void> setRoutineHistory(RoutineHistory routineHistory) =>
      _service.setData(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
        data: routineHistory.toMap(),
      );

  // Add or edit workout data
  @override
  Future<void> updateRoutineHistory(
    RoutineHistory routineHistory,
    Map<String, dynamic> data,
  ) =>
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
  Stream<RoutineHistory> routineHistoryStream(
          {required String routineHistoryId}) =>
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

  // Stream of Today's Routine History
  @override
  Stream<List<RoutineHistory>?> routineHistoryTodayStream(String uid) =>
      _service.collectionStreamOfToday(
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'workoutDate',
        orderVariableName: 'workoutStartTime',
        path: APIPath.routineHistories(),
        builder: (data, documentId) => RoutineHistory.fromMap(data, documentId),
      );

  // Stream of This Week's Routine History
  @override
  Stream<List<RoutineHistory>?> routineHistoriesThisWeekStream(String uid) =>
      _service.collectionStreamOfThisWeek(
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'workoutEndTime',
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

  @override
  Query routineHistoriesPaginatedPublicQuery() =>
      _service.paginatedPublicCollectionQuery(
        path: APIPath.routineHistories(),
        order: 'workoutEndTime',
        descending: true,
      );

  @override
  Query routineHistoriesPaginatedUserQuery() =>
      _service.paginatedUserCollectionQuery(
        path: APIPath.routineHistories(),
        order: 'workoutEndTime',
        descending: true,
        id: 'userId',
        userId: userId,
      );

  // Batch Update of Routine History
  @override
  Future<void> batchUpdateRoutineHistories(
    List<Map<String, dynamic>> routineHistories,
  ) async {
    final routineHistoriesId = <String>[];

    routineHistories.forEach((routineHistory) {
      var id = APIPath.routineHistory(routineHistory['routineHistoryId']);
      routineHistoriesId.add(id);
    });

    await _service.batchUpdateData(
      path: routineHistoriesId,
      data: routineHistories,
    );
  }

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

    final routineWorkoutIds = <String>[];
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

  ////////////////// `Workout Histories` ////////////////
  /// Add or edit workout data
  @override
  Future<void> setWorkoutHistory(WorkoutHistory workoutHistory) =>
      _service.setData(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
        data: workoutHistory.toJson(),
      );

  // Update Workout History
  @override
  Future<void> updateWorkoutHistory(
    WorkoutHistory workoutHistory,
    Map<String, dynamic> data,
  ) =>
      _service.updateData(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
        data: data,
      );

  // Delete workout data
  @override
  Future<void> deleteWorkoutHistory(WorkoutHistory workoutHistory) async =>
      _service.deleteData(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
      );

  // Batch Add Workout Histories
  @override
  Future<void> batchWriteWorkoutHistories(
    List<WorkoutHistory> workoutHistories,
  ) async {
    List<String> workoutHistoryPaths = <String>[];
    List<Map<String, dynamic>> workoutHistoriesAsMap = [];

    workoutHistories.forEach((workoutHistory) {
      Map<String, dynamic> workoutHistoryAsJson = workoutHistory.toJson();
      String path = APIPath.workoutHistory(workoutHistory.workoutHistoryId);
      workoutHistoriesAsMap.add(workoutHistoryAsJson);
      workoutHistoryPaths.add(path);
    });

    await _service.batchData(
      path: workoutHistoryPaths,
      data: workoutHistoriesAsMap,
    );
  }

  // Batch Add Workout Histories
  @override
  Future<void> batchDeleteWorkoutHistories(
    List<WorkoutHistory> workoutHistories,
  ) async {
    List<String> workoutHistoryPaths = <String>[];

    workoutHistories.forEach((workoutHistory) {
      String path = APIPath.workoutHistory(workoutHistory.workoutHistoryId);
      workoutHistoryPaths.add(path);
    });

    await _service.batchDelete(
      path: workoutHistoryPaths,
    );
  }

  // Workout Histories Stream
  @override
  Stream<List<WorkoutHistory>> workoutHistoriesStream(
    String routineHistoryId,
  ) =>
      _service.workoutHistoriesForRoutineHistoryStream(
        routineHistoryId: routineHistoryId,
        path: APIPath.workoutHistories(),
        builder: (data, documentId) =>
            WorkoutHistory.fromJson(data, documentId),
      );
}
