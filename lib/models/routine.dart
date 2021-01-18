import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Routine {
  Routine({
    @required this.routineId,
    @required this.routineOwnerId,
    @required this.routineOwnerUserName,
    @required this.routineTitle,
    @required this.lastEditedDate,
    @required this.routineCreatedDate,
    @required this.mainMuscleGroup,
    this.secondMuscleGroup,
    this.description,
    this.imageUrl,
    this.totalWeights,
    this.averageTotalCalories,
    this.duration,
    this.equipmentRequired,
    // TODO: ADD THEM LATER
    // this.tags,
    // this.routineGoal,
    // this.trainingLevel,
    // this.workoutType,
  });

  final String routineId;
  final String routineOwnerId;
  final String routineOwnerUserName;
  final String routineTitle;
  final Timestamp lastEditedDate;
  final Timestamp routineCreatedDate;
  final String mainMuscleGroup;
  final String secondMuscleGroup;
  final String description;
  final String imageUrl;
  final int totalWeights;
  final int averageTotalCalories;
  final int duration;
  final String equipmentRequired;
  // final String tags;
  // final String routineGoal;
  // final String trainingLevel;
  // final String workoutType;

  factory Routine.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String routineOwnerId = data['routineOwnerId'];
    final String routineOwnerUserName = data['routineOwnerUserName'];
    final String routineTitle = data['routineTitle'];
    final Timestamp lastEditedDate = data['lastEditedDate'];
    final Timestamp routineCreatedDate = data['routineCreatedDate'];
    final String mainMuscleGroup = data['mainMuscleGroup'];
    final String secondMuscleGroup = data['secondMuscleGroup'];
    final String description = data['description'];
    final String imageUrl = data['imageUrl'];
    final int totalWeights = data['totalWeights'];
    final int averageTotalCalories = data['averageTotalCalories'];
    final int duration = data['duration'];
    final String equipmentRequired = data['equipmentRequired'];
    // final String tags = data['tags'];
    // final String routineGoal = data['routineGoal'];
    // final String trainingLevel = data['trainingLevel'];
    // final String workoutType = data['workoutType'];

    return Routine(
      routineId: documentId,
      routineOwnerId: routineOwnerId,
      routineOwnerUserName: routineOwnerUserName,
      routineTitle: routineTitle,
      lastEditedDate: lastEditedDate,
      routineCreatedDate: routineCreatedDate,
      mainMuscleGroup: mainMuscleGroup,
      secondMuscleGroup: secondMuscleGroup,
      description: description,
      imageUrl: imageUrl,
      totalWeights: totalWeights,
      averageTotalCalories: averageTotalCalories,
      duration: duration,
      equipmentRequired: equipmentRequired,
      // tags: tags,
      // routineGoal: routineGoal,
      // trainingLevel: trainingLevel,
      // workoutType: workoutType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routineOwnerId': routineOwnerId,
      'routineTitle': routineTitle,
      'routineOwnerUserName': routineOwnerUserName,
      'lastEditedDate': lastEditedDate,
      'routineCreatedDate': routineCreatedDate,
      'mainMuscleGroup': mainMuscleGroup,
      'secondMuscleGroup': secondMuscleGroup,
      'description': description,
      'imageUrl': imageUrl,
      'totalWeights': totalWeights,
      'averageTotalCalories': averageTotalCalories,
      'duration': duration,
      'equipmentRequired': equipmentRequired,
      // 'tags': tags,
      // 'routineGoal': routineGoal,
      // 'trainingLevel': trainingLevel,
      // 'workoutType': workoutType,
    };
  }
}
