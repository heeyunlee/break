import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workout_player/classes/measurement.dart';
import 'package:workout_player/classes/nutrition.dart';
import 'package:workout_player/classes/progress_tab_class.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/classes/routine_and_routine_workouts.dart';
import 'package:workout_player/classes/routine_history.dart';
import 'package:workout_player/classes/routine_workout.dart';
import 'package:workout_player/classes/steps.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/classes/user_feedback.dart';
import 'package:workout_player/classes/workout.dart';
import 'package:workout_player/classes/workout_history.dart';
import 'package:workout_player/classes/workout_set.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/api_path.dart';
import 'package:workout_player/services/firestore_service.dart';

///
///
/// `riverpod`
///
///
final databaseProvider2 = Provider.family<FirestoreDatabase, String?>(
  (ref, uid) => FirestoreDatabase(reader: ref.read, uid: uid),
);

final databaseProvider = Provider.family<FirestoreDatabase, String>(
  (ref, uid) => FirestoreDatabase(),
);

final userStreamProvider = StreamProvider.family<User?, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.userStream();
});

final todaysNutritionStreamProvider =
    StreamProvider.family<List<Nutrition>?, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.todaysNutritionStream();
});

final nutritionSelectedDayStreamProvider =
    StreamProvider.family<List<Nutrition>?, List<dynamic>>((ref, ids) {
  final database = ref.watch(databaseProvider2(ids[0]));
  return database.nutritionsSelectedDayStream(ids[1]);
});

final thisWeeksNutritionsStreamProvider =
    StreamProvider.family<List<Nutrition>, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.thisWeeksNutritionsStream();
});

final workoutStreamProvider = StreamProvider.family<Workout?, String>(
  (ref, id) {
    final database = ref.watch(databaseProvider(id));
    return database.workoutStream(id);
  },
);

final routineStreamProvider = StreamProvider.family<Routine?, String>(
  (ref, id) {
    final database = ref.watch(databaseProvider(id));
    return database.routineStream(id);
  },
);

final routineWorkoutsStreamProvider =
    StreamProvider.family<List<RoutineWorkout?>, String>((ref, id) {
  final database = ref.watch(databaseProvider(id));
  return database.routineWorkoutsStream(id);
});

final todaysRHStreamProvider =
    StreamProvider.family<List<RoutineHistory>?, String>((ref, uid) {
  final database = ref.watch(databaseProvider(uid));
  return database.routineHistoryTodayStream();
});

final rhOfThisWeekStreamProvider =
    StreamProvider.autoDispose.family<List<RoutineHistory>, String>(
  (ref, uid) {
    final database = ref.watch(databaseProvider(uid));
    return database.routineHistoriesThisWeekStream();
  },
);

final rhOfThisWeekStreamProvider2 =
    StreamProvider.autoDispose.family<List<RoutineHistory?>, List<String>>(
  (ref, IDs) {
    final database = ref.watch(databaseProvider(IDs[0]));
    return database.routineHistoriesThisWeekStream2(IDs[0]);
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
  Future<void> setUser(User user);
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  Future<User?> getUserDocument(String userId);

  // Stream
  Stream<User?> userStream();

  /// HEALTH DATA
  Future<void> setSetps(Steps steps);
  Future<void> updateSteps(String uid, Map<String, dynamic> data);
  Future<Steps?> getSteps(String uid);
  Stream<Steps?> stepsStream();

  //////////////////// `Body Measurement` //////////////////////
  Future<void> setMeasurement({
    // required String uid,
    required Measurement measurement,
  });
  Future<void> updateMeasurement({
    // required String uid,
    required String measurementId,
    required Map<String, dynamic> data,
  });
  Future<void> deleteMeasurement({
    // required String uid,
    required Measurement measurement,
  });
  Stream<List<Measurement>> measurementsStream({int? limit});
  Stream<List<Measurement>> measurementsStreamThisWeek();

  // Query
  Query<Measurement> measurementsQuery();

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
  Stream<List<Nutrition>?> todaysNutritionStream();
  Stream<List<Nutrition>> nutritionsSelectedDayStream(DateTime? date);
  Stream<List<Nutrition>> thisWeeksNutritionsStream();

  // Query
  Query<Nutrition> nutritionsPaginatedUserQuery();

  /////////////////// `User Feedback` /////////////////////
  Future<void> setUserFeedback(UserFeedback userFeedback);

  //////////////// `Workout` ///////////////
  // FUTURE
  Future<void> setWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout, Map<String, dynamic> data);
  Future<void> deleteWorkout(Workout workout);
  Future<Workout?> getWorkout(String workoutId);

  // STREAM
  Stream<Workout?> workoutStream(String workoutId);
  Stream<List<Workout>> workoutsStream({int limit});
  Stream<List<Workout>> userWorkoutsStream({int limit});
  Stream<List<Workout>> workoutsSearchStream({
    required String arrayContainsVariableName,
    required String arrayContainsValue,
    int? limit,
  });

  // QUERY
  Query<Workout> workoutsPaginatedUserQuery();
  Query<Workout> workoutsSearchQuery();

  // BATCH
  Future<void> batchUpdateWorkouts(List<Map<String, dynamic>> workouts);

  /////////// `Routine` ////////////////
  // FUTURE
  Future<void> setRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine, Map<String, dynamic> data);
  Future<void> deleteRoutine(Routine routine);
  Future<Routine?> getRoutine(String routineId);

  // STREAM
  Stream<Routine?> routineStream(String routineId);
  Stream<List<Routine>> routinesStream({int limit});
  Stream<List<Routine>> userRoutinesStream({int limit});
  Stream<List<Routine>> routinesSearchStream({
    required String arrayContainsVariableName,
    required String arrayContainsValue,
    int? limit,
  });

  // QUERY
  Query<Routine> routinesPaginatedPublicQuery();
  Query<Routine> routinesPaginatedUserQuery();
  Query<Routine> routinesSearchQuery();

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
  Future<void> batchWriteRoutineWorkouts(
    Routine routine,
    List<RoutineWorkout> routineWorkouts,
  );

  Stream<RoutineWorkout?> routineWorkoutStream({
    required Routine routine,
    required RoutineWorkout routineWorkout,
  });
  Stream<List<RoutineWorkout>> routineWorkoutsStream(String routineId);

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

  // STREAM
  Stream<RoutineHistory?> routineHistoryStream(String routineHistoryId);
  Stream<List<RoutineHistory>> routineHistoriesStream();
  Stream<List<RoutineHistory>?> routineHistoryTodayStream();
  Stream<List<RoutineHistory>> routineHistorySelectedDayStream(DateTime? date);
  Stream<List<RoutineHistory>> routineHistoriesThisWeekStream();
  Stream<List<RoutineHistory?>> routineHistoriesThisWeekStream2(
      String routineId);
  Stream<List<RoutineHistory>> routineHistoriesPublicStream();

  // QUERY
  Query<RoutineHistory> routineHistoriesPaginatedPublicQuery();
  Query<RoutineHistory> routineHistoriesPaginatedUserQuery();
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
  Stream<List<WorkoutHistory?>> workoutHistoriesThisWeekStream(
      String workoutId);

  // RxDart CombinedLists
  Stream<RoutineAndRoutineWorkouts> routineRoutineWorkoutsStream(
    String routineId,
  );
  Stream<ProgressTabClass> progressTabStream(DateTime? day);
}

///
///
/// `FirestoreDatabase`
///
///

class FirestoreDatabase implements Database {
  final String? uid;
  final Reader? reader;

  FirestoreDatabase({
    this.uid,
    this.reader,
  });

  final _service = FirestoreService.instance;

  ////////////////////////// `Users` /////////////////////////////
  // Add or edit User Data
  @override
  Future<void> setUser(User user) => _service.setData<User>(
        path: APIPath.user(user.userId),
        data: user,
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Update User Data
  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _service.updateData<User>(
        path: APIPath.user(uid),
        data: data,
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Single User Data
  @override
  Future<User?> getUserDocument(String uid) => _service.getDocument<User>(
        path: APIPath.user(uid),
        // builder: (data) => data,
        // builder: (data, documentId) => User.fromJson(data, documentId),
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Single User Stream
  @override
  Stream<User?> userStream() => _service.documentStream<User?>(
        path: APIPath.user(uid!),
        // builder: (data, documentId) => User.fromJson(data, documentId),
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  @override
  Future<void> setSetps(Steps steps) {
    return _service.setData<Steps>(
      path: APIPath.steps(uid!),
      data: steps,
      fromBuilder: (data, id) => Steps.fromMap(data!),
      toBuilder: (model) => model.toMap(),
    );
  }

  // Update User Data
  @override
  Future<void> updateSteps(String uid, Map<String, dynamic> data) =>
      _service.updateData<Steps>(
        path: APIPath.steps(uid),
        data: data,
        fromBuilder: (data, id) => Steps.fromMap(data!),
        toBuilder: (model) => model.toMap(),
      );

  // Single User Data
  @override
  Future<Steps?> getSteps(String uid) => _service.getDocument<Steps>(
        path: APIPath.steps(uid),
        fromBuilder: (data, id) => Steps.fromMap(data!),
        toBuilder: (model) => model.toMap(),
      );

  @override
  Stream<Steps?> stepsStream() => _service.documentStream<Steps?>(
        path: APIPath.steps(uid!),
        fromBuilder: (data, id) => Steps.fromMap(data!),
        toBuilder: (model) => model!.toMap(),
      );

  //////////////////////// `Body Measurement` ///////////////////////////
  // Add or edit Body Measurement Data
  @override
  Future<void> setMeasurement({
    required Measurement measurement,
  }) =>
      _service.setData<Measurement>(
        path: APIPath.measurement(uid!, measurement.measurementId),
        data: measurement,
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Update Body Measurement Data
  @override
  Future<void> updateMeasurement({
    required String measurementId,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData<Measurement>(
        path: APIPath.measurement(uid!, measurementId),
        data: data,
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Delete Body Measurement Data
  @override
  Future<void> deleteMeasurement({
    required Measurement measurement,
  }) async =>
      _service.deleteData(
        path: APIPath.measurement(uid!, measurement.measurementId),
      );

  // Body Measurements Stream for User
  @override
  Stream<List<Measurement>> measurementsStream({int? limit}) =>
      _service.collectionStream<Measurement>(
        order: 'loggedTime',
        descending: false,
        limit: limit,
        path: APIPath.measurements(uid!),
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Body Measurements Stream for User
  @override
  Stream<List<Measurement>> measurementsStreamThisWeek() =>
      _service.collectionStreamOfThisWeek<Measurement>(
        path: APIPath.measurements(uid!),
        dateVariableName: 'loggedTime',
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Measurements Query
  // Nutrition Query for specfic User
  @override
  Query<Measurement> measurementsQuery() =>
      _service.paginatedCollectionQuery<Measurement>(
        path: APIPath.measurements(uid!),
        orderBy: 'loggedTime',
        descending: true,
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  ////////////////////////// `Nutrition` ///////////////////////////////
  // Set
  @override
  Future<void> setNutrition(Nutrition nutrition) => _service.setData<Nutrition>(
        path: APIPath.nutrition(nutrition.nutritionId),
        data: nutrition,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Edit Routine
  @override
  Future<void> updateNutrition({
    required Nutrition nutrition,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData<Nutrition>(
        path: APIPath.nutrition(nutrition.nutritionId),
        data: data,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
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
      _service.isEqualToOrderByCollectionStream<Nutrition>(
        path: APIPath.nutritions(),
        whereVariableName: 'userId',
        isEqualToValue: uid!,
        orderByVariable: 'loggedTime',
        isDescending: true,
        limit: limit,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Today's Nutrition Entries
  @override
  Stream<List<Nutrition>> todaysNutritionStream() =>
      _service.collectionStreamOfToday<Nutrition>(
        uid: uid!,
        uidVariableName: 'userId',
        dateVariableName: 'loggedDate',
        orderVariableName: 'loggedTime',
        path: APIPath.nutritions(),
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Selected Day's Nutrition Entries
  @override
  Stream<List<Nutrition>> nutritionsSelectedDayStream(DateTime? date) =>
      _service.collectionStreamOfSelectedDay<Nutrition>(
        uid: uid!,
        uidVariableName: 'userId',
        dateIsEqualTo: date,
        dateVariableName: 'loggedDate',
        orderVariableName: 'loggedTime',
        path: APIPath.nutritions(),
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of This Week's Nutrition Entries
  @override
  Stream<List<Nutrition>> thisWeeksNutritionsStream() =>
      _service.collectionStreamOfThisWeek<Nutrition>(
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'loggedTime',
        path: APIPath.nutritions(),
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Nutrition Query for specfic User
  @override
  Query<Nutrition> nutritionsPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<Nutrition>(
        path: APIPath.nutritions(),
        where: 'userId',
        isEqualTo: uid!,
        orderBy: 'loggedTime',
        descending: true,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  /////////////////////// `User Feedback` /////////////////////
  // Add or edit User Data
  @override
  Future<void> setUserFeedback(UserFeedback userFeedback) =>
      _service.setData<UserFeedback>(
        path: APIPath.userFeedback(userFeedback.userFeedbackId),
        data: userFeedback,
        fromBuilder: (data, id) => UserFeedback.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  //////////////////////// `Workouts` /////////////////////
  // Add or edit workout data
  @override
  Future<void> setWorkout(Workout workout) => _service.setData<Workout>(
        path: APIPath.workout(workout.workoutId),
        data: workout,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Edit Workout
  @override
  Future<void> updateWorkout(Workout workout, Map<String, dynamic> data) =>
      _service.updateData<Workout>(
        path: APIPath.workout(workout.workoutId),
        data: data,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
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
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Single Workout Stream
  @override
  Stream<Workout?> workoutStream(String workoutId) =>
      _service.documentStream<Workout?>(
        path: APIPath.workout(workoutId),
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Stream for all available Workouts
  @override
  Stream<List<Workout>> workoutsStream({int? limit}) =>
      _service.isEqualToOrderByCollectionStream<Workout>(
        path: APIPath.workouts(),
        whereVariableName: 'isPublic',
        isEqualToValue: true,
        orderByVariable: 'workoutTitle',
        isDescending: false,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Workout Stream for specific User
  @override
  Stream<List<Workout>> userWorkoutsStream({int? limit}) =>
      _service.isEqualToOrderByCollectionStream<Workout>(
        path: APIPath.workouts(),
        whereVariableName: 'workoutOwnerId',
        isEqualToValue: uid,
        orderByVariable: 'workoutTitle',
        isDescending: false,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Workout Search Stream
  @override
  Stream<List<Workout>> workoutsSearchStream({
    required String arrayContainsVariableName,
    required String arrayContainsValue,
    int? limit,
  }) =>
      _service.isEqualToArrayContainsCollectionStream<Workout>(
        path: APIPath.workouts(),
        whereVariableName: 'isPublic',
        isEqualToValue: true,
        arrayContainsVariableName: arrayContainsVariableName,
        arrayContainsValue: arrayContainsValue,
        orderByVariable: 'workoutTitle',
        isDescending: false,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
        limit: limit,
      );

  // Paginated Workouts Query for specific user
  @override
  Query<Workout> workoutsPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<Workout>(
        path: APIPath.workouts(),
        where: 'workoutOwnerId',
        isEqualTo: uid!,
        orderBy: 'workoutTitle',
        descending: false,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Paginated Routines Query for specific user
  @override
  Query<Workout> workoutsSearchQuery() => _service.paginatedCollectionQuery(
        path: APIPath.workouts(),
        orderBy: 'workoutTitle',
        descending: false,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
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
  Future<void> setRoutine(Routine routine) => _service.setData<Routine>(
        path: APIPath.routine(routine.routineId),
        data: routine,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Edit Routine
  @override
  Future<void> updateRoutine(Routine routine, Map<String, dynamic> data) =>
      _service.updateData<Routine>(
        path: APIPath.routine(routine.routineId),
        data: data,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
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
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // All Public Routines Stream
  @override
  Stream<List<Routine>> routinesStream({int? limit}) =>
      _service.isEqualToOrderByCollectionStream<Routine>(
        path: APIPath.routines(),
        whereVariableName: 'isPublic',
        isEqualToValue: true,
        orderByVariable: 'routineTitle',
        isDescending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Single Routine Stream
  @override
  Stream<Routine?> routineStream(String routineId) =>
      _service.documentStream<Routine?>(
        path: APIPath.routine(routineId),
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Routine Stream for specific User
  @override
  Stream<List<Routine>> userRoutinesStream({int? limit}) =>
      _service.isEqualToOrderByCollectionStream<Routine>(
        path: APIPath.routines(),
        whereVariableName: 'routineOwnerId',
        isEqualToValue: uid!,
        orderByVariable: 'routineTitle',
        isDescending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Routine for Initial Search Screen
  @override
  Stream<List<Routine>> routinesSearchStream({
    required String arrayContainsVariableName,
    required String arrayContainsValue,
    int? limit,
  }) =>
      _service.isEqualToArrayContainsCollectionStream<Routine>(
        path: APIPath.routines(),
        whereVariableName: 'isPublic',
        isEqualToValue: true,
        arrayContainsVariableName: arrayContainsVariableName,
        arrayContainsValue: arrayContainsValue,
        orderByVariable: 'routineTitle',
        isDescending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
        limit: limit,
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
      _service.setData<RoutineWorkout>(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: routineWorkout,
        fromBuilder: (data, id) => RoutineWorkout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Delete Routine data
  @override
  Future<void> deleteRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout) async =>
      _service.deleteData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
      );

  // Edit Routine Workout
  @override
  Future<void> updateRoutineWorkout({
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData<RoutineWorkout>(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: data,
        fromBuilder: (data, id) => RoutineWorkout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Batch Add Workout Histories
  @override
  Future<void> batchWriteRoutineWorkouts(
    Routine routine,
    List<RoutineWorkout> routineWorkouts,
  ) async {
    List<String> routineWorkoutsPath = <String>[];
    List<Map<String, dynamic>> routineWorkoutsAsMap = [];

    routineWorkouts.forEach((routineWorkout) {
      Map<String, dynamic> routineWorkoutAsJson = routineWorkout.toJson();
      String path = APIPath.routineWorkout(
        routine.routineId,
        routineWorkout.routineWorkoutId,
      );

      routineWorkoutsAsMap.add(routineWorkoutAsJson);
      routineWorkoutsPath.add(path);
    });

    await _service.batchData(
      path: routineWorkoutsPath,
      data: routineWorkoutsAsMap,
    );
  }

  // Single Routine Workout Stream
  @override
  Stream<RoutineWorkout?> routineWorkoutStream({
    required Routine routine,
    required RoutineWorkout routineWorkout,
  }) =>
      _service.documentStream<RoutineWorkout?>(
        path: APIPath.routineWorkout(
          routine.routineId,
          routineWorkout.routineWorkoutId,
        ),
        fromBuilder: (data, id) => RoutineWorkout.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Routine Workout Stream
  @override
  Stream<List<RoutineWorkout>> routineWorkoutsStream(String routineId) =>
      _service.collectionStream<RoutineWorkout>(
        path: APIPath.routineWorkouts(routineId),
        order: 'index',
        descending: false,
        fromBuilder: (data, id) => RoutineWorkout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Paginated Routines Query for specific user
  @override
  Query<Routine> routinesPaginatedPublicQuery() =>
      _service.paginatedCollectionQuery<Routine>(
        path: APIPath.routines(),
        orderBy: 'routineTitle',
        descending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  @override
  Query<Routine> routinesPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<Routine>(
        path: APIPath.routines(),
        orderBy: 'routineTitle',
        descending: false,
        where: 'routineOwnerId',
        isEqualTo: uid!,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Paginated Routines Query for specific user
  @override
  Query<Routine> routinesSearchQuery() =>
      _service.paginatedCollectionQuery<Routine>(
        path: APIPath.routines(),
        orderBy: 'routineTitle',
        descending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

//////////////// `Workout Sets` ///////////////////
  // Create or delete Workout Set
  @override
  Future<void> setWorkoutSet({
    required Routine routine,
    required RoutineWorkout routineWorkout,
    required Map<String, dynamic> data,
  }) =>
      _service.updateData<WorkoutSet>(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
        data: data,
        fromBuilder: (data, id) => WorkoutSet.fromJson(data),
        toBuilder: (model) => model.toJson(),
      );

  /////////////////////////// `Routine History` //////////////////////////
  // Add or edit workout data
  @override
  Future<void> setRoutineHistory(RoutineHistory routineHistory) =>
      _service.setData<RoutineHistory>(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
        data: routineHistory,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Add or edit workout data
  @override
  Future<void> updateRoutineHistory(
    RoutineHistory routineHistory,
    Map<String, dynamic> data,
  ) =>
      _service.updateData<RoutineHistory>(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
        data: data,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Delete workout data
  @override
  Future<void> deleteRoutineHistory(RoutineHistory routineHistory) async =>
      _service.deleteData(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
      );

  // Stream of Single Workout Stream
  @override
  Stream<RoutineHistory?> routineHistoryStream(String routineHistoryId) =>
      _service.documentStream<RoutineHistory?>(
        path: APIPath.routineHistory(routineHistoryId),
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Routine History Stream for each User
  @override
  Stream<List<RoutineHistory>> routineHistoriesStream() =>
      _service.isEqualToOrderByCollectionStream<RoutineHistory>(
        path: APIPath.routineHistories(),
        whereVariableName: 'userId',
        isEqualToValue: uid!,
        orderByVariable: 'workoutEndTime',
        isDescending: true,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Today's Routine History
  @override
  Stream<List<RoutineHistory>?> routineHistoryTodayStream() =>
      _service.collectionStreamOfToday<RoutineHistory>(
        path: APIPath.routineHistories(),
        uid: uid!,
        uidVariableName: 'userId',
        dateVariableName: 'workoutDate',
        orderVariableName: 'workoutStartTime',
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Selected Day's Routine History
  @override
  Stream<List<RoutineHistory>> routineHistorySelectedDayStream(
          DateTime? date) =>
      _service.collectionStreamOfSelectedDay<RoutineHistory>(
        path: APIPath.routineHistories(),
        uid: uid!,
        uidVariableName: 'userId',
        dateVariableName: 'workoutDate',
        dateIsEqualTo: date,
        orderVariableName: 'workoutStartTime',
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of This Week's Routine History
  @override
  Stream<List<RoutineHistory>> routineHistoriesThisWeekStream() =>
      _service.collectionStreamOfThisWeek<RoutineHistory>(
        path: APIPath.routineHistories(),
        uid: uid!,
        uidVariableName: 'userId',
        dateVariableName: 'workoutEndTime',
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Specific Routine's Routine History
  @override
  Stream<List<RoutineHistory?>> routineHistoriesThisWeekStream2(
          String routineId) =>
      _service.collectionStreamOfThisWeek2<RoutineHistory>(
        path: APIPath.routineHistories(),
        uid: uid!,
        uidVariableName: 'userId',
        dateVariableName: 'workoutEndTime',
        whereVariableName: 'routineId',
        isEqualToVariable: routineId,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  @override
  Stream<List<RoutineHistory>> routineHistoriesPublicStream() =>
      _service.isEqualToOrderByCollectionStream<RoutineHistory>(
        path: APIPath.routineHistories(),
        whereVariableName: 'isPublic',
        isEqualToValue: true,
        orderByVariable: 'workoutEndTime',
        isDescending: true,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  @override
  Query<RoutineHistory> routineHistoriesPaginatedPublicQuery() =>
      _service.paginatedCollectionQuery<RoutineHistory>(
        path: APIPath.routineHistories(),
        orderBy: 'workoutEndTime',
        descending: true,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  @override
  Query<RoutineHistory> routineHistoriesPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<RoutineHistory>(
        path: APIPath.routineHistories(),
        orderBy: 'workoutEndTime',
        descending: true,
        where: 'userId',
        isEqualTo: uid!,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
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

  ////////////////// `Workout Histories` ////////////////
  /// Add or edit workout data
  @override
  Future<void> setWorkoutHistory(WorkoutHistory workoutHistory) =>
      _service.setData<WorkoutHistory>(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
        data: workoutHistory,
        fromBuilder: (data, id) => WorkoutHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Update Workout History
  @override
  Future<void> updateWorkoutHistory(
    WorkoutHistory workoutHistory,
    Map<String, dynamic> data,
  ) =>
      _service.updateData<WorkoutHistory>(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
        data: data,
        fromBuilder: (data, id) => WorkoutHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
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
      _service.isEqualToOrderByCollectionStream<WorkoutHistory>(
        path: APIPath.workoutHistories(),
        whereVariableName: 'routineHistoryId',
        isEqualToValue: routineHistoryId,
        orderByVariable: 'index',
        isDescending: false,
        fromBuilder: (data, id) => WorkoutHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Specific Workout's History
  @override
  Stream<List<WorkoutHistory?>> workoutHistoriesThisWeekStream(
          String workoutId) =>
      _service.collectionStreamOfThisWeek2<WorkoutHistory>(
        path: APIPath.workoutHistories(),
        uid: uid!,
        uidVariableName: 'uid',
        dateVariableName: 'workoutDate',
        whereVariableName: 'workoutId',
        isEqualToVariable: workoutId,
        fromBuilder: (data, id) => WorkoutHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  @override
  Stream<RoutineAndRoutineWorkouts> routineRoutineWorkoutsStream(
    String routineId,
  ) {
    return Rx.combineLatest2(
      routineStream(routineId),
      routineWorkoutsStream(routineId),
      (Routine? routine, List<RoutineWorkout>? routineWorkouts) {
        return RoutineAndRoutineWorkouts(
          routine: routine,
          routineWorkouts: routineWorkouts,
        );
      },
    );
  }

  @override
  Stream<ProgressTabClass> progressTabStream(DateTime? day) {
    return Rx.combineLatest7(
      userStream(),
      measurementsStreamThisWeek(),
      thisWeeksNutritionsStream(),
      routineHistoriesThisWeekStream(),
      routineHistorySelectedDayStream(day),
      nutritionsSelectedDayStream(day),
      stepsStream(),
      (
        User? user,
        List<Measurement> measurements,
        List<Nutrition> nutritions,
        List<RoutineHistory> routineHistories,
        List<RoutineHistory> selectedDayRoutineHistories,
        List<Nutrition> selectedDayNutritions,
        Steps? steps,
      ) {
        final aLength = (user != null) ? 1 : 0;
        final bLength = measurements.length;
        final cLength = nutritions.length;
        final dLength = routineHistories.length;
        final eLength = selectedDayRoutineHistories.length;
        final fLength = selectedDayNutritions.length;
        final gLength = (steps != null) ? 1 : 0;

        final entireLength =
            aLength + bLength + cLength + dLength + eLength + fLength + gLength;

        logger.d('Rx stream read $entireLength documents');

        return ProgressTabClass(
          user: user!,
          routineHistories: routineHistories,
          nutritions: nutritions,
          measurements: measurements,
          selectedDayRoutineHistories: selectedDayRoutineHistories,
          selectedDayNutritions: selectedDayNutritions,
          steps: steps,
        );
      },
    );
  }
}
