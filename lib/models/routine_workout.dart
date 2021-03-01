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
      sets = new List<WorkoutSet>();
      data['sets'].forEach((set) {
        sets.add(new WorkoutSet.fromMap(set));
      });
    }
    isBodyWeightWorkout = data['isBodyWeightWorkout'];
    duration = data['duration'];
    secondsPerRep = data['secondsPerRep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['workoutId'] = this.workoutId;
    data['workoutTitle'] = this.workoutTitle;
    data['numberOfSets'] = this.numberOfSets;
    data['numberOfReps'] = this.numberOfReps;
    data['totalWeights'] = this.totalWeights;
    if (this.sets != null) {
      data['sets'] = this.sets.map((e) => e.toMap()).toList();
    }
    data['isBodyWeightWorkout'] = this.isBodyWeightWorkout;
    data['duration'] = this.duration;
    data['secondsPerRep'] = this.secondsPerRep;

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
