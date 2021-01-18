import 'package:rxdart/rxdart.dart';
import 'package:workout_player/models/saved_workout.dart';
import 'package:workout_player/models/user_saved_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

class UserSavedWorkoutModel {
  UserSavedWorkoutModel({this.database, this.workout});

  final Database database;
  final Workout workout;

  Stream<List<UserSavedWorkout>> userSavedWorkoutsStream() {
    return Rx.combineLatest2(
      database.workoutsStream(),
      database.savedWorkoutsStream(),
      (List<Workout> workouts, List<SavedWorkout> savedWorkouts) {
        return workouts.map((workout) {
          final savedWorkout = savedWorkouts?.firstWhere(
            (savedWorkout) => savedWorkout.workoutId == workout.workoutId,
            orElse: () => null,
          );
          return UserSavedWorkout(
            workout: workout,
            isSavedWorkout: savedWorkout?.isFavorite ?? false,
          );
        }).toList();
      },
    );
  }

  // Stream of Single User Saved Workout Stream
  Stream<UserSavedWorkout> userSavedWorkoutStream(String workoutId) {
    return Rx.combineLatest2(
      database.workoutStream(workoutId: workoutId),
      database.savedWorkoutStream(workoutId: workoutId),
      (Workout workout, SavedWorkout savedWorkout) {
        return UserSavedWorkout(
          workout: workout,
          isSavedWorkout: savedWorkout?.isFavorite ?? false,
        );
      },
    );
  }
}
