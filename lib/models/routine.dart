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
    this.trainingLevel,
    this.isPublic,
    this.initialUnitOfMass,
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
  final List<dynamic> mainMuscleGroup;
  final List<dynamic> secondMuscleGroup;
  final String description;
  final String imageUrl;
  final double totalWeights;
  final int averageTotalCalories;
  final int duration;
  final List<dynamic> equipmentRequired;
  final int trainingLevel;
  final bool isPublic;
  final int initialUnitOfMass;
  // final String tags;
  // final String routineGoal;
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
    final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
    final List<dynamic> secondMuscleGroup = data['secondMuscleGroup'];
    final String description = data['description'];
    final String imageUrl = data['imageUrl'];
    final double totalWeights = data['totalWeights'];
    final int averageTotalCalories = data['averageTotalCalories'];
    final int duration = data['duration'];
    final List<dynamic> equipmentRequired = data['equipmentRequired'];
    final int trainingLevel = data['trainingLevel'];
    final bool isPublic = data['isPublic'];
    final int initialUnitOfMass = data['initialUnitOfMass'];
    // final String tags = data['tags'];
    // final String routineGoal = data['routineGoal'];
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
      trainingLevel: trainingLevel,
      isPublic: isPublic,
      initialUnitOfMass: initialUnitOfMass,
      // tags: tags,
      // routineGoal: routineGoal,
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
      'trainingLevel': trainingLevel,
      'isPublic': isPublic,
      'initialUnitOfMass': initialUnitOfMass,
      // 'tags': tags,
      // 'routineGoal': routineGoal,
      // 'workoutType': workoutType,
    };
  }
}
