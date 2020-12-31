import 'package:flutter/material.dart';

class RoutineWorkout {
  RoutineWorkout({
    @required this.routineWorkoutId,
    @required this.workoutId,
    @required this.workoutTitle,
    this.numberOfSets,
    this.numberOfReps,
    this.sets,
  });

  final String routineWorkoutId;
  final String workoutId;
  final String workoutTitle;
  final int numberOfSets;
  final int numberOfReps;
  final List sets;

  factory RoutineWorkout.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String workoutId = data['workoutId'];
    final String workoutTitle = data['workoutTitle'];
    final int numberOfSets = data['numberOfSets'];
    final int numberOfReps = data['numberOfReps'];
    final List sets = data['sets'];

    return RoutineWorkout(
      routineWorkoutId: documentId,
      workoutId: workoutId,
      workoutTitle: workoutTitle,
      numberOfSets: numberOfSets,
      numberOfReps: numberOfReps,
      sets: sets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workoutId': workoutId,
      'workoutTitle': workoutTitle,
      'numberOfSets': numberOfSets,
      'numberOfReps': numberOfReps,
      'sets': sets,
    };
  }
}
