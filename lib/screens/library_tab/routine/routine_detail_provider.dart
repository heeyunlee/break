import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/routine_workout.dart';

final currentRoutineWorkoutSnapshot =
    StateProvider<AsyncSnapshot<List<RoutineWorkout>>?>((ref) => null);
