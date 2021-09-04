import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'workout_set.dart';

class WorkoutHistory {
  final String workoutHistoryId;
  final String routineHistoryId;
  final String workoutId;
  final String routineId;
  final String uid;
  final int index;
  final String workoutTitle;
  final int numberOfSets;
  final int numberOfReps;
  final num totalWeights;
  final List<WorkoutSet>? sets; // Nullable
  final bool isBodyWeightWorkout;
  final int duration;
  final int secondsPerRep;
  final Map<String, dynamic> translated;
  final Timestamp? workoutTime; // Nullable
  final Timestamp? workoutDate; // Nullable
  final int? unitOfMass; // Nullable

  const WorkoutHistory({
    required this.workoutHistoryId,
    required this.routineHistoryId,
    required this.workoutId,
    required this.routineId,
    required this.uid,
    required this.index,
    required this.workoutTitle,
    required this.numberOfSets,
    required this.numberOfReps,
    required this.totalWeights,
    this.sets,
    required this.isBodyWeightWorkout,
    required this.duration,
    required this.secondsPerRep,
    required this.translated,
    required this.workoutTime,
    required this.workoutDate,
    required this.unitOfMass,
  });

  factory WorkoutHistory.fromJson(
      Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String workoutHistoryId = documentId;
      final String routineHistoryId = data['routineHistoryId'].toString();
      final String workoutId = data['workoutId'].toString();
      final String routineId = data['routineId'].toString();
      final String uid = data['uid'].toString();
      final int index = int.parse(data['index'].toString());
      final String workoutTitle = data['workoutTitle'].toString();
      final int numberOfSets = int.parse(data['numberOfSets'].toString());
      final int numberOfReps = int.parse(data['numberOfReps'].toString());
      final num totalWeights = num.parse(data['totalWeights'].toString());
      final List<WorkoutSet>? sets = (data['sets'] != null)
          ? (data['sets'] as List)
              .map((map) => WorkoutSet.fromJson(map))
              .toList()
          : null;

      // List<WorkoutSet>? sets = <WorkoutSet>[]; // Nullable
      // if (data['sets'] != null) {
      //   data['sets'].forEach((item) {
      //     sets.add(WorkoutSet.fromJson(item));
      //   });
      // }
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'] as bool;
      final int duration = int.parse(data['duration'].toString());
      final int secondsPerRep = int.parse(data['secondsPerRep'].toString());
      final Map<String, dynamic> translated =
          data['translated'] as Map<String, dynamic>;
      final Timestamp? workoutTime =
          data['workoutTime'] as Timestamp?; // Nullable
      final Timestamp? workoutDate =
          data['workoutDate'] as Timestamp?; // Nullable
      final int? unitOfMass =
          int.tryParse(data['unitOfMass']?.toString() ?? ''); // Nullable

      return WorkoutHistory(
        workoutHistoryId: workoutHistoryId,
        routineHistoryId: routineHistoryId,
        workoutId: workoutId,
        routineId: routineId,
        uid: uid,
        index: index,
        workoutTitle: workoutTitle,
        numberOfSets: numberOfSets,
        numberOfReps: numberOfReps,
        totalWeights: totalWeights,
        sets: sets,
        isBodyWeightWorkout: isBodyWeightWorkout,
        duration: duration,
        secondsPerRep: secondsPerRep,
        translated: translated,
        workoutTime: workoutTime,
        workoutDate: workoutDate,
        unitOfMass: unitOfMass,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['routineHistoryId'] = routineHistoryId;
    data['workoutId'] = workoutId;
    data['routineId'] = routineId;
    data['uid'] = uid;
    data['index'] = index;
    data['workoutTitle'] = workoutTitle;
    data['numberOfSets'] = numberOfSets;
    data['numberOfReps'] = numberOfReps;
    data['totalWeights'] = totalWeights;
    if (sets != null) {
      data['sets'] = sets!.map((e) => e.toJson()).toList();
    }
    data['isBodyWeightWorkout'] = isBodyWeightWorkout;
    data['duration'] = duration;
    data['secondsPerRep'] = secondsPerRep;
    data['translated'] = translated;
    data['workoutTime'] = workoutTime;
    data['workoutDate'] = workoutDate;

    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutHistory &&
        other.workoutHistoryId == workoutHistoryId &&
        other.routineHistoryId == routineHistoryId &&
        other.workoutId == workoutId &&
        other.routineId == routineId &&
        other.uid == uid &&
        other.index == index &&
        other.workoutTitle == workoutTitle &&
        other.numberOfSets == numberOfSets &&
        other.numberOfReps == numberOfReps &&
        other.totalWeights == totalWeights &&
        listEquals(other.sets, sets) &&
        other.isBodyWeightWorkout == isBodyWeightWorkout &&
        other.duration == duration &&
        other.secondsPerRep == secondsPerRep &&
        mapEquals(other.translated, translated) &&
        other.workoutTime == workoutTime &&
        other.workoutDate == workoutDate &&
        other.unitOfMass == unitOfMass;
  }

  @override
  int get hashCode {
    return workoutHistoryId.hashCode ^
        routineHistoryId.hashCode ^
        workoutId.hashCode ^
        routineId.hashCode ^
        uid.hashCode ^
        index.hashCode ^
        workoutTitle.hashCode ^
        numberOfSets.hashCode ^
        numberOfReps.hashCode ^
        totalWeights.hashCode ^
        sets.hashCode ^
        isBodyWeightWorkout.hashCode ^
        duration.hashCode ^
        secondsPerRep.hashCode ^
        translated.hashCode ^
        workoutTime.hashCode ^
        workoutDate.hashCode ^
        unitOfMass.hashCode;
  }
}
