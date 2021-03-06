import 'package:flutter/material.dart';

import 'workout_set.dart';

class RoutineWorkout {
  RoutineWorkout({
    this.index,
    @required this.routineWorkoutId,
    @required this.workoutId,
    @required this.workoutTitle,
    this.numberOfSets,
    this.numberOfReps,
    this.totalWeights,
    this.sets,
    this.isBodyWeightWorkout,
    this.duration,
    this.secondsPerRep,
  });

  int index;
  String routineWorkoutId;
  String workoutId;
  String workoutTitle;
  int numberOfSets;
  int numberOfReps;
  double totalWeights;
  List<WorkoutSet> sets;
  bool isBodyWeightWorkout;
  int duration;
  int secondsPerRep;

  RoutineWorkout.fromJson(Map<String, dynamic> data, String documentId) {
    routineWorkoutId = documentId;
    index = data['index'];
    workoutId = data['workoutId'];
    workoutTitle = data['workoutTitle'];
    numberOfSets = data['numberOfSets'];
    numberOfReps = data['numberOfReps'];
    totalWeights = data['totalWeights'];
    if (data['sets'] != null) {
      sets = <WorkoutSet>[];
      data['sets'].forEach((set) {
        sets.add(WorkoutSet.fromMap(set));
      });
    }
    isBodyWeightWorkout = data['isBodyWeightWorkout'];
    duration = data['duration'];
    secondsPerRep = data['secondsPerRep'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['index'] = index;
    data['workoutId'] = workoutId;
    data['workoutTitle'] = workoutTitle;
    data['numberOfSets'] = numberOfSets;
    data['numberOfReps'] = numberOfReps;
    data['totalWeights'] = totalWeights;
    if (sets != null) {
      data['sets'] = sets.map((e) => e.toMap()).toList();
    }
    data['isBodyWeightWorkout'] = isBodyWeightWorkout;
    data['duration'] = duration;
    data['secondsPerRep'] = secondsPerRep;

    return data;
    // return {
    //   'index': index,
    //   'workoutId': workoutId,
    //   'workoutTitle': workoutTitle,
    //   'numberOfSets': numberOfSets,
    //   'numberOfReps': numberOfReps,
    //   'sets': sets,
    // };
  }
}
