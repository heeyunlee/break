import 'package:flutter/foundation.dart';

class WorkoutSet {
  WorkoutSet({
    @required this.workoutSetId,
    @required this.isRest,
    @required this.index,
    @required this.setTitle,
    this.weights,
    this.reps,
    this.restTime,
  });

  final String workoutSetId;
  final bool isRest;
  final int index;
  final String setTitle;
  final int weights;
  final int reps;
  final int restTime;

  factory WorkoutSet.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String workoutSetId = data['workoutSetId'];
    final bool isRest = data['isRest'];
    final int index = data['index'];
    final String setTitle = data['setTitle'];
    final int weights = data['weights'];
    final int reps = data['reps'];
    final int restTime = data['restTime'];

    return WorkoutSet(
      workoutSetId: workoutSetId,
      isRest: isRest,
      index: index,
      setTitle: setTitle,
      weights: weights,
      reps: reps,
      restTime: restTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workoutSetId': workoutSetId,
      'isRest': isRest,
      'index': index,
      'setTitle': setTitle,
      'weights': weights,
      'reps': reps,
      'restTime': restTime,
    };
  }
}
