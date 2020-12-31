import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RoutineHistory {
  RoutineHistory({
    @required this.routineHistoryId,
    @required this.userId,
    @required this.routineId,
    @required this.routineTitle,
    @required this.workedOutTime,
    this.totalWeights,
    this.totalCalories,
    this.totalDuration,
    this.earnedBadges,
    this.notes,
    this.sets,
  });

  final String routineHistoryId;
  final String userId;
  final String routineId;
  final String routineTitle;
  final Timestamp workedOutTime;
  final int totalWeights;
  final int totalCalories;
  final int totalDuration;
  final bool earnedBadges;
  final String notes;
  final List<Map> sets;

  factory RoutineHistory.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userId = data['userId'];
    final String routineId = data['routineId'];
    final String routineTitle = data['routineTitle'];
    final Timestamp workedOutTime = data['workedOutTime'];
    final int totalWeights = data['totalWeights'];
    final int totalCalories = data['totalCalories'];
    final int totalDuration = data['totalDuration'];
    final bool earnedBadges = data['earnedBadges'];
    final String notes = data['notes'];
    final List<Map> sets = data['sets'];

    return RoutineHistory(
      routineHistoryId: documentId,
      userId: userId,
      routineId: routineId,
      routineTitle: routineTitle,
      workedOutTime: workedOutTime,
      totalWeights: totalWeights,
      totalCalories: totalCalories,
      totalDuration: totalDuration,
      earnedBadges: earnedBadges,
      notes: notes,
      sets: sets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'routineId': routineId,
      'routineTitle': routineTitle,
      'workedOutTime': workedOutTime,
      'totalWeights': totalWeights,
      'totalCalories': totalCalories,
      'totalDuration': totalDuration,
      'earnedBadges': earnedBadges,
      'notes': notes,
      'sets': sets,
    };
  }
}
