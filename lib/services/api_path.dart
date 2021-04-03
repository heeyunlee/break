class APIPath {
  /// Users
  static String user(String userId) => 'users/$userId';
  static String users() => 'users';
  static String measurements(String userId) => 'users/$userId/measurements';
  static String measurement(String userId, String measurementId) =>
      'users/$userId/measurements/$measurementId';
  // static String savedWorkouts(String userId) => 'users/$userId/savedWorkouts';
  // static String savedWorkout(String userId, String savedWorkoutId) =>
  //     'users/$userId/savedWorkouts/$savedWorkoutId';

  /// Nutrition
  static String nutritions() => 'nutritions';
  static String nutrition(String nutritionId) => 'nutritions/$nutritionId';

  /// User Feedback
  static String userFeedback(String userFeedbackId) =>
      'userFeedbacks/$userFeedbackId';

  /// Workout
  static String workouts() => 'workouts';
  static String workout(String workoutId) => 'workouts/$workoutId';

  /// Routines
  static String routines() => 'routines';
  static String routine(String routineId) => 'routines/$routineId';

  /// Workout Histories
  static String routineHistories() => 'routine_histories';
  static String routineHistory(String routineHistoryId) =>
      'routine_histories/$routineHistoryId';
  static String routineWorkoutForHistory(
          String routineHistoryId, String routineWorkoutId) =>
      'routine_histories/$routineHistoryId/routine_workouts/$routineWorkoutId';
  static String routineWorkoutsForHistory(String routineHistoryId) =>
      'routine_histories/$routineHistoryId/routine_workouts';

  /// Routine Workout
  static String routineWorkout(String routineId, String routineWorkoutId) =>
      'routines/$routineId/routine_workouts/$routineWorkoutId';
  static String routineWorkouts(String routineId) =>
      'routines/$routineId/routine_workouts';
}
