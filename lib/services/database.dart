import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/firestore_service.dart';
import 'package:workout_player/services/logging.dart';

import 'api_path.dart';

class Database {
  final String? uid;

  Database({
    this.uid,
  });

  final _service = FirestoreService.instance;

  ////////////////////////// `Users` /////////////////////////////
  // Add or edit User Data
  Future<void> setUser(User user) => _service.setData<User>(
        path: APIPath.user(user.userId),
        data: user,
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Update User Data
  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _service.updateData<User>(
        path: APIPath.user(uid),
        data: data,
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Single User Data
  Future<User?> getUserDocument(String uid) => _service.getDocument<User>(
        path: APIPath.user(uid),
        // builder: (data) => data,
        // builder: (data, documentId) => User.fromJson(data, documentId),
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Single User Stream
  Stream<User?> userStream() => _service.documentStream<User?>(
        path: APIPath.user(uid!),
        // builder: (data, documentId) => User.fromJson(data, documentId),
        fromBuilder: (data, id) => User.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  //////////////////////// `Body Measurement` ///////////////////////////
  /// Add or edit Body Measurement Data
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
  Future<void> deleteMeasurement({
    required Measurement measurement,
  }) async =>
      _service.deleteData(
        path: APIPath.measurement(uid!, measurement.measurementId),
      );

  // Body Measurements Stream for User
  Stream<List<Measurement>> measurementsStream({int? limit}) =>
      _service.collectionStream<Measurement>(
        order: 'loggedTime',
        descending: true,
        limit: limit,
        path: APIPath.measurements(uid!),
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Body Measurements Stream for User
  Stream<List<Measurement>> measurementsStreamThisWeek() =>
      _service.collectionStreamOfThisWeek<Measurement>(
        path: APIPath.measurements(uid!),
        dateVariableName: 'loggedTime',
        fromBuilder: (data, id) => Measurement.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Measurements Query
  // Nutrition Query for specfic User
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
  Future<void> setNutrition(Nutrition nutrition) => _service.setData<Nutrition>(
        path: APIPath.nutrition(nutrition.nutritionId),
        data: nutrition,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Edit Routine
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
  Future<void> deleteNutrition(Nutrition nutrition) async =>
      _service.deleteData(
        path: APIPath.nutrition(nutrition.nutritionId),
      );

  // Stream of Single Nutrition Stream
  Stream<Nutrition?> nutritionStream(String nutritionId) =>
      _service.documentStream<Nutrition?>(
        path: APIPath.nutrition(nutritionId),
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Nutrition Stream for specific User
  Stream<List<Nutrition>> userNutritionStream({int limit = 10}) =>
      _service.isEqualToOrderByCollectionStream<Nutrition>(
        path: APIPath.nutritions(),
        whereVariableName: 'userId',
        isEqualToValue: uid,
        orderByVariable: 'loggedTime',
        isDescending: true,
        limit: limit,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Today's Nutrition Entries
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
  Stream<List<Nutrition>> thisWeeksNutritionsStream() =>
      _service.collectionStreamOfThisWeek<Nutrition>(
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'loggedTime',
        path: APIPath.nutritions(),
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Proteins Query for specfic User
  Query<Nutrition> proteinsPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<Nutrition>(
        path: APIPath.nutritions(),
        where: 'userId',
        isEqualTo: uid,
        orderBy: 'loggedTime',
        descending: true,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Carbs Query for specfic User
  Query<Nutrition> carbsPaginatedUserQuery() =>
      _service.whereNotNullAndOrderByQuery<Nutrition>(
        path: APIPath.nutritions(),
        where: 'userId',
        isEqualTo: uid,
        orderBy: 'loggedTime',
        descending: true,
        fromBuilder: (data, id) => Nutrition.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  /////////////////////// `User Feedback` /////////////////////
  // Add or edit User Data
  Future<void> setUserFeedback(UserFeedback userFeedback) =>
      _service.setData<UserFeedback>(
        path: APIPath.userFeedback(userFeedback.userFeedbackId),
        data: userFeedback,
        fromBuilder: (data, id) => UserFeedback.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  //////////////////////// `Workouts` /////////////////////
  // Add or edit workout data
  Future<void> setWorkout(Workout workout) => _service.setData<Workout>(
        path: APIPath.workout(workout.workoutId),
        data: workout,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Edit Workout
  Future<void> updateWorkout(Workout workout, Map<String, dynamic> data) =>
      _service.updateData<Workout>(
        path: APIPath.workout(workout.workoutId),
        data: data,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Delete workout data
  Future<void> deleteWorkout(Workout workout) async => _service.deleteData(
        path: APIPath.workout(workout.workoutId),
      );

  // Get Workojut
  Future<Workout?> getWorkout(String workoutId) async =>
      _service.getDocument<Workout>(
        path: APIPath.workout(workoutId),
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Single Workout Stream
  Stream<Workout?> workoutStream(String workoutId) =>
      _service.documentStream<Workout?>(
        path: APIPath.workout(workoutId),
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Stream for all available Workouts
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
  Stream<List<Workout>> workoutsSearchStream({
    required bool isEqualTo,
    String? arrayContainsVariableName,
    String? arrayContainsValue,
    String? isEqualToVariableName,
    String? isEqualToVariableValue,
    int? limit,
  }) =>
      isEqualTo
          ? _service.twoIsEqualToCollectionStream(
              path: APIPath.workouts(),
              whereVariableName1: 'isPublic',
              isEqualToValue1: true,
              whereVariableName2: isEqualToVariableName!,
              isEqualToValue2: isEqualToVariableValue,
              orderByVariable: 'workoutTitle',
              isDescending: false,
              fromBuilder: (data, id) => Workout.fromJson(data, id),
              toBuilder: (model) => model.toJson(),
              limit: limit,
            )
          : _service.isEqualToArrayContainsCollectionStream<Workout>(
              path: APIPath.workouts(),
              whereVariableName: 'isPublic',
              isEqualToValue: true,
              arrayContainsVariableName: arrayContainsVariableName!,
              arrayContainsValue: arrayContainsValue,
              orderByVariable: 'workoutTitle',
              isDescending: false,
              fromBuilder: (data, id) => Workout.fromJson(data, id),
              toBuilder: (model) => model.toJson(),
              limit: limit,
            );

  // Paginated Workouts Query for specific user

  Query<Workout> workoutsPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<Workout>(
        path: APIPath.workouts(),
        where: 'workoutOwnerId',
        isEqualTo: uid,
        orderBy: 'workoutTitle',
        descending: false,
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  Query<Workout> workoutsSearchQuery() =>
      _service.paginatedPublicCollectionQuery(
        path: APIPath.workouts(),
        orderBy: 'workoutTitle',
        descending: false,
        isPublicName: 'isPublic',
        fromBuilder: (data, id) => Workout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  /// BATCH
  // Batch Update of Workout

  Future<void> batchUpdateWorkouts(
    List<Map<String, dynamic>> workouts,
  ) async {
    // final workoutId = <String>[];

    // workouts.forEach((element) {
    //   var id = APIPath.workout(element['workoutId']);
    //   workoutId.add(id);
    // });

    final List<String> workoutIds = workouts
        .map((map) => APIPath.workout(map['workoutId'].toString()))
        .toList();

    await _service.batchUpdateData(
      path: workoutIds,
      data: workouts,
    );
  }

  /////////////// `Routine` /////////////////////
  // Add Routine

  Future<void> setRoutine(Routine routine) => _service.setData<Routine>(
        path: APIPath.routine(routine.routineId),
        data: routine,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Edit Routine

  Future<void> updateRoutine(Routine routine, Map<String, dynamic> data) =>
      _service.updateData<Routine>(
        path: APIPath.routine(routine.routineId),
        data: data,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Delete Routine data

  Future<void> deleteRoutine(Routine routine) async => _service.deleteData(
        path: APIPath.routine(routine.routineId),
      );

  // Get Routine

  Future<Routine?> getRoutine(String routineId) async =>
      _service.getDocument<Routine>(
        path: APIPath.routine(routineId),
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // All Public Routines Stream

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

  Stream<Routine?> routineStream(String routineId) =>
      _service.documentStream<Routine?>(
        path: APIPath.routine(routineId),
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Routine Stream for specific User

  Stream<List<Routine>> userRoutinesStream({int? limit}) =>
      _service.isEqualToOrderByCollectionStream<Routine>(
        path: APIPath.routines(),
        whereVariableName: 'routineOwnerId',
        isEqualToValue: uid,
        orderByVariable: 'routineTitle',
        isDescending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Routine for Initial Search Screen

  Stream<List<Routine>> routinesSearchStream({
    required bool isEqualTo,
    String? isEqualToVariableName,
    String? isEqualToVariableValue,
    String? arrayContainsVariableName,
    String? arrayContainsValue,
    int? limit,
  }) =>
      isEqualTo
          ? _service.twoIsEqualToCollectionStream<Routine>(
              path: APIPath.routines(),
              whereVariableName1: 'isPublic',
              isEqualToValue1: true,
              whereVariableName2: isEqualToVariableName!,
              isEqualToValue2: isEqualToVariableValue,
              orderByVariable: 'routineTitle',
              isDescending: false,
              fromBuilder: (data, id) => Routine.fromJson(data, id),
              toBuilder: (model) => model.toJson(),
              limit: limit,
            )
          : _service.isEqualToArrayContainsCollectionStream<Routine>(
              path: APIPath.routines(),
              whereVariableName: 'isPublic',
              isEqualToValue: true,
              arrayContainsVariableName: arrayContainsVariableName!,
              arrayContainsValue: arrayContainsValue,
              orderByVariable: 'routineTitle',
              isDescending: false,
              fromBuilder: (data, id) => Routine.fromJson(data, id),
              toBuilder: (model) => model.toJson(),
              limit: limit,
            );

  // Batch Update of Routine

  Future<void> batchUpdateRoutines(
    List<Map<String, dynamic>> routines,
  ) async {
    final List<String> routineIds = routines
        .map((map) => APIPath.routine(map['routineId'].toString()))
        .toList();

    // final routineId = <String>[];

    // routines.forEach((element) {
    //   var id = APIPath.routine(element['routineId']);
    //   routineId.add(id);
    // });

    await _service.batchUpdateData(
      path: routineIds,
      data: routines,
    );
  }

  /////////////////// `Routine Workouts` ///////////////////
  // Add or edit Routine Workout

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

  Future<void> deleteRoutineWorkout(
          Routine routine, RoutineWorkout routineWorkout) async =>
      _service.deleteData(
        path: APIPath.routineWorkout(
            routine.routineId, routineWorkout.routineWorkoutId),
      );

  // Edit Routine Workout

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

  Future<void> batchWriteRoutineWorkouts(
    Routine routine,
    List<RoutineWorkout> routineWorkouts,
  ) async {
    final List<String> routineWorkoutsPath = <String>[];
    final List<Map<String, dynamic>> routineWorkoutsAsMap = [];

    for (final routineWorkout in routineWorkouts) {
      final Map<String, dynamic> routineWorkoutAsJson = routineWorkout.toJson();
      final String path = APIPath.routineWorkout(
        routine.routineId,
        routineWorkout.routineWorkoutId,
      );

      routineWorkoutsAsMap.add(routineWorkoutAsJson);
      routineWorkoutsPath.add(path);
    }

    // routineWorkouts.forEach((routineWorkout) {
    //   Map<String, dynamic> routineWorkoutAsJson = routineWorkout.toJson();
    //   String path = APIPath.routineWorkout(
    //     routine.routineId,
    //     routineWorkout.routineWorkoutId,
    //   );

    //   routineWorkoutsAsMap.add(routineWorkoutAsJson);
    //   routineWorkoutsPath.add(path);
    // });

    await _service.batchData(
      path: routineWorkoutsPath,
      data: routineWorkoutsAsMap,
    );
  }

  // Single Routine Workout Stream

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

  Stream<List<RoutineWorkout>> routineWorkoutsStream(String routineId) =>
      _service.collectionStream<RoutineWorkout>(
        path: APIPath.routineWorkouts(routineId),
        order: 'index',
        descending: false,
        fromBuilder: (data, id) => RoutineWorkout.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Paginated Routines Query for specific user

  Query<Routine> routinesPaginatedPublicQuery() =>
      _service.paginatedCollectionQuery<Routine>(
        path: APIPath.routines(),
        orderBy: 'routineTitle',
        descending: false,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  Query<Routine> routinesPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<Routine>(
        path: APIPath.routines(),
        orderBy: 'routineTitle',
        descending: false,
        where: 'routineOwnerId',
        isEqualTo: uid,
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Paginated Routines Query for specific user

  Query<Routine> routinesSearchQuery() =>
      _service.paginatedPublicCollectionQuery<Routine>(
        path: APIPath.routines(),
        orderBy: 'routineTitle',
        descending: false,
        isPublicName: 'isPublic',
        fromBuilder: (data, id) => Routine.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

//////////////// `Workout Sets` ///////////////////
  // Create or delete Workout Set

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

  Future<void> setRoutineHistory(RoutineHistory routineHistory) =>
      _service.setData<RoutineHistory>(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
        data: routineHistory,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Add or edit workout data

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

  Future<void> deleteRoutineHistory(RoutineHistory routineHistory) async =>
      _service.deleteData(
        path: APIPath.routineHistory(routineHistory.routineHistoryId),
      );

  // Stream of Single Workout Stream

  Stream<RoutineHistory?> routineHistoryStream(String routineHistoryId) =>
      _service.documentStream<RoutineHistory?>(
        path: APIPath.routineHistory(routineHistoryId),
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model!.toJson(),
      );

  // Routine History Stream for each User

  Stream<List<RoutineHistory>> routineHistoriesStream() =>
      _service.isEqualToOrderByCollectionStream<RoutineHistory>(
        path: APIPath.routineHistories(),
        whereVariableName: 'userId',
        isEqualToValue: uid,
        orderByVariable: 'workoutEndTime',
        isDescending: true,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Today's Routine History

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

  Stream<List<RoutineHistory>> routineHistoriesThisWeekStream() =>
      _service.collectionStreamOfThisWeek<RoutineHistory>(
        path: APIPath.routineHistories(),
        uid: uid,
        uidVariableName: 'userId',
        dateVariableName: 'workoutEndTime',
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Stream of Specific Routine's Routine History

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

  Query<RoutineHistory> routineHistoriesPaginatedPublicQuery() =>
      _service.paginatedCollectionQuery<RoutineHistory>(
        path: APIPath.routineHistories(),
        orderBy: 'workoutEndTime',
        descending: true,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  Query<RoutineHistory> routineHistoriesPaginatedUserQuery() =>
      _service.whereAndOrderByQuery<RoutineHistory>(
        path: APIPath.routineHistories(),
        orderBy: 'workoutEndTime',
        descending: true,
        where: 'userId',
        isEqualTo: uid,
        fromBuilder: (data, id) => RoutineHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Batch Update of Routine History

  Future<void> batchUpdateRoutineHistories(
    List<Map<String, dynamic>> routineHistories,
  ) async {
    // final routineHistoriesId = <String>[];

    // routineHistories.forEach((routineHistory) {
    //   var id = APIPath.routineHistory(routineHistory['routineHistoryId']);
    //   routineHistoriesId.add(id);
    // });

    final List<String> ids = routineHistories
        .map(
          (map) => APIPath.routineHistory(map['routineHistoryId'].toString()),
        )
        .toList();

    await _service.batchUpdateData(
      path: ids,
      data: routineHistories,
    );
  }

  ////////////////// `Workout Histories` ////////////////
  /// Add or edit workout data

  Future<void> setWorkoutHistory(WorkoutHistory workoutHistory) =>
      _service.setData<WorkoutHistory>(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
        data: workoutHistory,
        fromBuilder: (data, id) => WorkoutHistory.fromJson(data, id),
        toBuilder: (model) => model.toJson(),
      );

  // Update Workout History

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

  Future<void> deleteWorkoutHistory(WorkoutHistory workoutHistory) async =>
      _service.deleteData(
        path: APIPath.workoutHistory(workoutHistory.workoutHistoryId),
      );

  // Batch Add Workout Histories

  Future<void> batchWriteWorkoutHistories(
    List<WorkoutHistory> workoutHistories,
  ) async {
    final List<String> workoutHistoryPaths = <String>[];
    final List<Map<String, dynamic>> workoutHistoriesAsMap = [];

    for (final workoutHistory in workoutHistories) {
      final Map<String, dynamic> workoutHistoryAsJson = workoutHistory.toJson();
      final String path = APIPath.workoutHistory(
        workoutHistory.workoutHistoryId,
      );

      workoutHistoriesAsMap.add(workoutHistoryAsJson);
      workoutHistoryPaths.add(path);
    }

    // workoutHistories.forEach((workoutHistory) {
    //   Map<String, dynamic> workoutHistoryAsJson = workoutHistory.toJson();
    //   String path = APIPath.workoutHistory(workoutHistory.workoutHistoryId);
    //   workoutHistoriesAsMap.add(workoutHistoryAsJson);
    //   workoutHistoryPaths.add(path);
    // });

    await _service.batchData(
      path: workoutHistoryPaths,
      data: workoutHistoriesAsMap,
    );
  }

  // Batch Add Workout Histories

  Future<void> batchDeleteWorkoutHistories(
    List<WorkoutHistory> workoutHistories,
  ) async {
    // List<String> workoutHistoryPaths = <String>[];

    // workoutHistories.forEach((workoutHistory) {
    //   String path = APIPath.workoutHistory(workoutHistory.workoutHistoryId);
    //   workoutHistoryPaths.add(path);
    // });

    final List<String> paths = workoutHistories
        .map((history) => APIPath.workoutHistory(history.workoutHistoryId))
        .toList();

    await _service.batchDelete(
      path: paths,
    );
  }

  // Workout Histories Stream

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

  /// RxDart

  Stream<RoutineDetailScreenClass> routineDetailScreenStream(String routineId) {
    return Rx.combineLatest3(
      userStream(),
      routineStream(routineId),
      routineWorkoutsStream(routineId),
      (User? user, Routine? routine, List<RoutineWorkout>? routineWorkouts) {
        return RoutineDetailScreenClass(
          user: user,
          routine: routine,
          routineWorkouts: routineWorkouts,
        );
      },
    );
  }

  Stream<ProgressTabClass> progressTabStream(DateTime? day) {
    return Rx.combineLatest6(
      userStream(),
      measurementsStreamThisWeek(),
      thisWeeksNutritionsStream(),
      routineHistoriesThisWeekStream(),
      routineHistorySelectedDayStream(day),
      nutritionsSelectedDayStream(day),
      (
        User? user,
        List<Measurement> measurements,
        List<Nutrition> nutritions,
        List<RoutineHistory> routineHistories,
        List<RoutineHistory> selectedDayRoutineHistories,
        List<Nutrition> selectedDayNutritions,
      ) {
        final aLength = (user != null) ? 1 : 0;
        final bLength = measurements.length;
        final cLength = nutritions.length;
        final dLength = routineHistories.length;
        final eLength = selectedDayRoutineHistories.length;
        final fLength = selectedDayNutritions.length;

        final entireLength =
            aLength + bLength + cLength + dLength + eLength + fLength;

        logger.d('Rx stream read $entireLength documents');

        return ProgressTabClass(
          user: user!,
          routineHistories: routineHistories,
          nutritions: nutritions,
          measurements: measurements,
          selectedDayRoutineHistories: selectedDayRoutineHistories,
          selectedDayNutritions: selectedDayNutritions,
        );
      },
    );
  }

  Stream<EatsTabClass> eatsTabStream() {
    return Rx.combineLatest3(
      userStream(),
      thisWeeksNutritionsStream(),
      userNutritionStream(limit: 6),
      (
        User? user,
        List<Nutrition> thisWeeksNutritions,
        List<Nutrition> recentNutritions,
      ) {
        final todaysNutritionsLength = thisWeeksNutritions.length;
        final recentNutritionsLength = recentNutritions.length;

        final length = 1 + todaysNutritionsLength + recentNutritionsLength;

        logger.d('Rx `eatsTabStream` read $length documents');

        return EatsTabClass(
          user: user!,
          thisWeeksNutritions: thisWeeksNutritions,
          recentNutritions: recentNutritions,
        );
      },
    );
  }

  /// Function that updates existing YouTubeVideo data on Firebase

  Future<void> updatedYoutubeVideo(
    YoutubeVideo video,
    Map<String, dynamic> updatedVideo,
  ) =>
      _service.updateData<YoutubeVideo>(
        path: APIPath.youtubeVideo(video.youtubeVideoId),
        data: updatedVideo,
        fromBuilder: (data, id) => YoutubeVideo.fromMap(data, id),
        toBuilder: (model) => model.toMap(),
      );

  // All Public Routines Stream

  Stream<List<YoutubeVideo>> youtubeVideosStream({int? limit}) =>
      _service.collectionStream<YoutubeVideo>(
        path: APIPath.youtubeVideos(),
        order: 'title',
        descending: true,
        limit: limit,
        fromBuilder: (data, id) => YoutubeVideo.fromMap(data, id),
        toBuilder: (model) => model.toMap(),
      );
}
