class APIPath {
  /// Users
  static String user(String userId) => 'users/$userId';
  static String users() => 'users';
  static String savedWorkouts(String userId) => 'users/$userId/savedWorkouts';
  static String savedWorkout(String userId, String savedWorkoutId) =>
      'users/$userId/savedWorkouts/$savedWorkoutId';

  /// User Feedback
  // ignore: missing_return
  static String userFeedback(String userFeedbackId) =>
      'userFeedbacks/$userFeedbackId';

  /// Workout
  static String workout(String workoutId) => 'workouts/$workoutId';
  static String workouts() => 'workouts';

  /// Routines
  static String routine(String routineId) => 'routines/$routineId';
  static String routines() => 'routines';

  /// Workout Histories
  static String routineHistory(String routineHistoryId) =>
      'routine_histories/$routineHistoryId';
  static String routineHistories() => 'routine_histories';
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
