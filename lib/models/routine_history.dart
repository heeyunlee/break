import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RoutineHistory {
  RoutineHistory({
    @required this.routineHistoryId,
    @required this.userId,
    @required this.username,
    @required this.routineId,
    @required this.routineTitle,
    @required this.isPublic,
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
    this.workoutDate,
    this.imageUrl,
    this.unitOfMass,
    this.equipmentRequired,
    this.effort,
  });

  final String routineHistoryId;
  final String userId;
  final String username;
  final String routineId;
  final String routineTitle;
  final bool isPublic;
  final Timestamp workoutStartTime;
  final Timestamp workoutEndTime;
  final double totalWeights;
  final double totalCalories;
  final int totalDuration;
  final bool earnedBadges;
  final String notes;
  final List<dynamic> mainMuscleGroup;
  final List<dynamic> secondMuscleGroup;
  final bool isBodyWeightWorkout;
  final DateTime workoutDate;
  final String imageUrl;
  final int unitOfMass;
  final List<dynamic> equipmentRequired;
  final double effort;

  factory RoutineHistory.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userId = data['userId'];
    final String username = data['username'];
    final String routineId = data['routineId'];
    final String routineTitle = data['routineTitle'];
    final bool isPublic = data['isPublic'];
    final Timestamp workoutStartTime = data['workoutStartTime'];
    final Timestamp workoutEndTime = data['workoutEndTime'];
    final double totalWeights = data['totalWeights'];
    final double totalCalories = data['totalCalories'];
    final int totalDuration = data['totalDuration'];
    final bool earnedBadges = data['earnedBadges'];
    final String notes = data['notes'];
    final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
    final List<dynamic> secondMuscleGroup = data['secondMuscleGroup'];
    final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
    final DateTime workoutDate = data['workoutDate'].toDate();
    final String imageUrl = data['imageUrl'];
    final int unitOfMass = data['unitOfMass'];
    final List<dynamic> equipmentRequired = data['equipmentRequired'];
    final double effort = data['effort'];

    return RoutineHistory(
      routineHistoryId: documentId,
      userId: userId,
      username: username,
      routineId: routineId,
      routineTitle: routineTitle,
      isPublic: isPublic,
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
      workoutDate: workoutDate,
      imageUrl: imageUrl,
      unitOfMass: unitOfMass,
      equipmentRequired: equipmentRequired,
      effort: effort,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'routineId': routineId,
      'routineTitle': routineTitle,
      'isPublic': isPublic,
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
      'workoutDate': workoutDate,
      'imageUrl': imageUrl,
      'unitOfMass': unitOfMass,
      'equipmentRequired': equipmentRequired,
      'effort': effort,
    };
  }
}
