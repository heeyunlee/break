import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RoutineHistory {
  RoutineHistory({
    @required this.routineHistoryId,
    @required this.userId,
    @required this.routineId,
    @required this.routineTitle,
    this.workoutStartTime,
    this.workoutEndTime,
    this.totalWeights,
    this.totalCalories,
    this.totalDuration,
    this.earnedBadges,
    this.notes,
    this.mainMuscleGroup,
    this.secondMuscleGroup,
    this.isBodyWeightWorkout,
    this.imageIndex,
    this.workoutDate,
  });

  final String routineHistoryId;
  final String userId;
  final String routineId;
  final String routineTitle;
  final Timestamp workoutStartTime;
  final Timestamp workoutEndTime;
  final int totalWeights;
  final double totalCalories;
  final int totalDuration;
  final bool earnedBadges;
  final String notes;
  final List<dynamic> mainMuscleGroup;
  final List<dynamic> secondMuscleGroup;
  final bool isBodyWeightWorkout;
  final int imageIndex;
  final DateTime workoutDate;

  factory RoutineHistory.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userId = data['userId'];
    final String routineId = data['routineId'];
    final String routineTitle = data['routineTitle'];
    final Timestamp workoutStartTime = data['workoutStartTime'];
    final Timestamp workoutEndTime = data['workoutEndTime'];
    final int totalWeights = data['totalWeights'];
    final double totalCalories = data['totalCalories'];
    final int totalDuration = data['totalDuration'];
    final bool earnedBadges = data['earnedBadges'];
    final String notes = data['notes'];
    final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
    final List<dynamic> secondMuscleGroup = data['secondMuscleGroup'];
    final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
    final int imageIndex = data['imageIndex'];
    final DateTime workoutDate = data['workoutDate'].toDate();

    return RoutineHistory(
      routineHistoryId: documentId,
      userId: userId,
      routineId: routineId,
      routineTitle: routineTitle,
      workoutStartTime: workoutStartTime,
      workoutEndTime: workoutEndTime,
      totalWeights: totalWeights,
      totalCalories: totalCalories,
      totalDuration: totalDuration,
      earnedBadges: earnedBadges,
      notes: notes,
      mainMuscleGroup: mainMuscleGroup,
      secondMuscleGroup: secondMuscleGroup,
      isBodyWeightWorkout: isBodyWeightWorkout,
      imageIndex: imageIndex,
      workoutDate: workoutDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'routineId': routineId,
      'routineTitle': routineTitle,
      'workoutStartTime': workoutStartTime,
      'workoutEndTime': workoutEndTime,
      'totalWeights': totalWeights,
      'totalCalories': totalCalories,
      'totalDuration': totalDuration,
      'earnedBadges': earnedBadges,
      'notes': notes,
      'mainMuscleGroup': mainMuscleGroup,
      'secondMuscleGroup': secondMuscleGroup,
      'isBodyWeightWorkout': isBodyWeightWorkout,
      'imageIndex': imageIndex,
      'workoutDate': workoutDate,
    };
  }
}
