import 'package:flutter/foundation.dart';

import 'workout_set.dart';

class RoutineWorkout {
  const RoutineWorkout({
    required this.routineWorkoutId,
    required this.routineId,
    required this.routineWorkoutOwnerId,
    required this.workoutId,
    required this.workoutTitle,
    required this.index,
    required this.numberOfSets,
    required this.numberOfReps,
    required this.totalWeights,
    required this.sets,
    required this.isBodyWeightWorkout,
    required this.duration,
    required this.secondsPerRep,
    required this.translated,
  });

  final String routineWorkoutId;
  final String routineId;
  final String routineWorkoutOwnerId;
  final String workoutId;
  final String workoutTitle;
  final int index;
  final int numberOfSets;
  final int numberOfReps;
  final num totalWeights;
  final List<WorkoutSet> sets;
  final bool isBodyWeightWorkout;
  final int duration;
  final int secondsPerRep;
  final Map<String, dynamic> translated;

  factory RoutineWorkout.fromJson(
      Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String routineId = data['routineId'].toString();
      final String routineWorkoutOwnerId =
          data['routineWorkoutOwnerId'].toString();
      final String workoutId = data['workoutId'].toString();
      final String workoutTitle = data['workoutTitle'].toString();
      final int index = int.parse(data['index'].toString());
      final int numberOfSets = int.parse(data['numberOfSets'].toString());
      final int numberOfReps = int.parse(data['numberOfReps'].toString());
      final num totalWeights = num.parse(data['totalWeights'].toString());
      final List<WorkoutSet> sets = (data['sets'] != null)
          ? (data['sets'] as List).map((e) => WorkoutSet.fromJson(e)).toList()
          : [];
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'] as bool;
      final int duration = data['duration'] as int;
      final int secondsPerRep = data['secondsPerRep'] as int;
      final Map<String, dynamic> translated =
          data['translated'] as Map<String, dynamic>;

      return RoutineWorkout(
        routineWorkoutId: documentId,
        index: index,
        workoutId: workoutId,
        routineId: routineId,
        routineWorkoutOwnerId: routineWorkoutOwnerId,
        workoutTitle: workoutTitle,
        numberOfSets: numberOfSets,
        numberOfReps: numberOfReps,
        totalWeights: totalWeights,
        sets: sets,
        isBodyWeightWorkout: isBodyWeightWorkout,
        duration: duration,
        secondsPerRep: secondsPerRep,
        translated: translated,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['index'] = index;
    data['workoutId'] = workoutId;
    data['routineId'] = routineId;
    data['routineWorkoutOwnerId'] = routineWorkoutOwnerId;
    data['workoutTitle'] = workoutTitle;
    data['numberOfSets'] = numberOfSets;
    data['numberOfReps'] = numberOfReps;
    data['totalWeights'] = totalWeights;
    data['sets'] = sets.map((e) => e.toJson()).toList();
    data['isBodyWeightWorkout'] = isBodyWeightWorkout;
    data['duration'] = duration;
    data['secondsPerRep'] = secondsPerRep;
    data['translated'] = translated;

    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoutineWorkout &&
        other.routineWorkoutId == routineWorkoutId &&
        other.routineId == routineId &&
        other.routineWorkoutOwnerId == routineWorkoutOwnerId &&
        other.workoutId == workoutId &&
        other.workoutTitle == workoutTitle &&
        other.index == index &&
        other.numberOfSets == numberOfSets &&
        other.numberOfReps == numberOfReps &&
        other.totalWeights == totalWeights &&
        listEquals(other.sets, sets) &&
        other.isBodyWeightWorkout == isBodyWeightWorkout &&
        other.duration == duration &&
        other.secondsPerRep == secondsPerRep &&
        mapEquals(other.translated, translated);
  }

  @override
  int get hashCode {
    return routineWorkoutId.hashCode ^
        routineId.hashCode ^
        routineWorkoutOwnerId.hashCode ^
        workoutId.hashCode ^
        workoutTitle.hashCode ^
        index.hashCode ^
        numberOfSets.hashCode ^
        numberOfReps.hashCode ^
        totalWeights.hashCode ^
        sets.hashCode ^
        isBodyWeightWorkout.hashCode ^
        duration.hashCode ^
        secondsPerRep.hashCode ^
        translated.hashCode;
  }
}
