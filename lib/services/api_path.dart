class APIPath {
  // Users
  static String user(String userId) => 'users/$userId';
  static String users() => 'users';

  // Workout
  static String workout(String workoutId) => 'workouts/$workoutId';
  static String workouts() => 'workouts';

  // Routines
  static String routine(String routineId) => 'routines/$routineId';
  static String routines() => 'routines';

  // Saved Workouts
  static String savedWorkout(String userId, String workoutId) =>
      'users/$userId/workouts/$workoutId';
  static String savedWorkouts(String userId) => 'users/$userId/workouts';

  // Workout Histories
  static String routineHistory(String workoutHistoryId) =>
      'routine_histories/$workoutHistoryId';
  static String routineHistories() => 'routine_histories';

  // Routine Workout
  static String routineWorkout(String routineId, String routineWorkoutId) =>
      'routines/$routineId/routine_workouts/$routineWorkoutId';
  static String routineWorkouts(String routineId) =>
      'routines/$routineId/routine_workouts';
}
