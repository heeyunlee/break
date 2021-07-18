import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RoutineHistory {
  final String routineHistoryId;
  final String userId;
  final String username;
  final String routineId;
  final String routineTitle;
  final bool isPublic;
  final Timestamp workoutStartTime;
  final Timestamp workoutEndTime;
  final num totalWeights;
  final num? totalCalories; // Nullable
  final int totalDuration;
  final bool? earnedBadges; // Nullable
  final String? notes; // Nullable
  final List<dynamic> mainMuscleGroup;
  final List<dynamic>? secondMuscleGroup; // Nullable
  final bool isBodyWeightWorkout;
  final DateTime workoutDate;
  final String imageUrl;
  final int unitOfMass;
  final List<dynamic> equipmentRequired;
  final num? effort; // Nullable

  const RoutineHistory({
    required this.routineHistoryId,
    required this.userId,
    required this.username,
    required this.routineId,
    required this.routineTitle,
    required this.isPublic,
    required this.workoutStartTime,
    required this.workoutEndTime,
    required this.totalWeights,
    this.totalCalories,
    required this.totalDuration,
    this.earnedBadges,
    this.notes,
    required this.mainMuscleGroup,
    this.secondMuscleGroup,
    required this.isBodyWeightWorkout,
    required this.workoutDate,
    required this.imageUrl,
    required this.unitOfMass,
    required this.equipmentRequired,
    this.effort,
  });

  factory RoutineHistory.fromJson(
      Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'];
      final String username = data['username'];
      final String routineId = data['routineId'];
      final String routineTitle = data['routineTitle'];
      final bool isPublic = data['isPublic'];
      final Timestamp workoutStartTime = data['workoutStartTime'];
      final Timestamp workoutEndTime = data['workoutEndTime'];
      final num totalWeights = data['totalWeights'];
      final num? totalCalories = data['totalCalories'];
      final int totalDuration = data['totalDuration'];
      final bool? earnedBadges = data['earnedBadges'];
      final String? notes = data['notes'];
      final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
      final DateTime workoutDate = data['workoutDate'].toDate();
      final String imageUrl = data['imageUrl'];
      final int unitOfMass = data['unitOfMass'];
      final List<dynamic> equipmentRequired = data['equipmentRequired'];
      final num? effort = data['effort'];

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
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoutineHistory &&
        other.routineHistoryId == routineHistoryId &&
        other.userId == userId &&
        other.username == username &&
        other.routineId == routineId &&
        other.routineTitle == routineTitle &&
        other.isPublic == isPublic &&
        other.workoutStartTime == workoutStartTime &&
        other.workoutEndTime == workoutEndTime &&
        other.totalWeights == totalWeights &&
        other.totalCalories == totalCalories &&
        other.totalDuration == totalDuration &&
        other.earnedBadges == earnedBadges &&
        other.notes == notes &&
        listEquals(other.mainMuscleGroup, mainMuscleGroup) &&
        listEquals(other.secondMuscleGroup, secondMuscleGroup) &&
        other.isBodyWeightWorkout == isBodyWeightWorkout &&
        other.workoutDate == workoutDate &&
        other.imageUrl == imageUrl &&
        other.unitOfMass == unitOfMass &&
        listEquals(other.equipmentRequired, equipmentRequired) &&
        other.effort == effort;
  }

  @override
  int get hashCode {
    return routineHistoryId.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        routineId.hashCode ^
        routineTitle.hashCode ^
        isPublic.hashCode ^
        workoutStartTime.hashCode ^
        workoutEndTime.hashCode ^
        totalWeights.hashCode ^
        totalCalories.hashCode ^
        totalDuration.hashCode ^
        earnedBadges.hashCode ^
        notes.hashCode ^
        mainMuscleGroup.hashCode ^
        secondMuscleGroup.hashCode ^
        isBodyWeightWorkout.hashCode ^
        workoutDate.hashCode ^
        imageUrl.hashCode ^
        unitOfMass.hashCode ^
        equipmentRequired.hashCode ^
        effort.hashCode;
  }
}
