import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/workout_history.dart';

final currentWorkoutHistories =
    StateProvider<List<WorkoutHistory>?>((ref) => null);
