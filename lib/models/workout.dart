import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum difficulty {
  SuperEasy,
  Beginner,
  Intermediate,
  PrettyHard,
  SuperHard,
}

extension difficultyExtension on difficulty {
  String get label {
    switch (this) {
      case difficulty.SuperEasy:
        return 'Super Easy';
      case difficulty.Beginner:
        return 'Beginner';
      case difficulty.Intermediate:
        return 'Intermediate';
      case difficulty.PrettyHard:
        return 'Pretty Hard';
      case difficulty.SuperHard:
        return 'Super Hard';
      default:
        return null;
    }
  }
}

class Workout {
  Workout({
    @required this.workoutId,
    @required this.workoutOwnerId,
    @required this.workoutOwnerUserName,
    @required this.workoutTitle,
    @required this.mainMuscleGroup,
    @required this.secondaryMuscleGroup,
    @required this.description,
    @required this.equipmentRequired,
    this.imageUrl,
    this.isBodyWeightWorkout,
    this.lastEditedDate,
    this.workoutCreatedDate,
    this.difficulty,
    this.instructions,
    this.tips,
    this.imageIndex,
  });

  final String workoutId;
  final String workoutOwnerId;
  final String workoutOwnerUserName;
  final String workoutTitle;
  final List<dynamic> mainMuscleGroup;
  final List<dynamic> secondaryMuscleGroup;
  final String description;
  final List<dynamic> equipmentRequired;
  final String imageUrl;
  final bool isBodyWeightWorkout;
  final Timestamp lastEditedDate;
  final Timestamp workoutCreatedDate;
  final int difficulty;
  final String instructions;
  final String tips;
  final int imageIndex;

  factory Workout.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String workoutOwnerId = data['workoutOwnerId'];
    final String workoutOwnerUserName = data['workoutOwnerUserName'];
    final String workoutTitle = data['workoutTitle'];
    final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
    final List<dynamic> secondaryMuscleGroup = data['secondaryMuscleGroup'];
    final String description = data['description'];
    final List<dynamic> equipmentRequired = data['equipmentRequired'];
    final String imageUrl = data['imageUrl'];
    final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
    final Timestamp lastEditedDate = data['lastEditedDate'];
    final Timestamp workoutCreatedDate = data['workoutCreatedDate'];
    final int difficulty = data['difficulty'];
    final String instructions = data['instructions'];
    final String tips = data['tips'];
    final int imageIndex = data['imageIndex'];

    return Workout(
      workoutId: documentId,
      workoutOwnerId: workoutOwnerId,
      workoutOwnerUserName: workoutOwnerUserName,
      workoutTitle: workoutTitle,
      mainMuscleGroup: mainMuscleGroup,
      secondaryMuscleGroup: secondaryMuscleGroup,
      description: description,
      equipmentRequired: equipmentRequired,
      imageUrl: imageUrl,
      isBodyWeightWorkout: isBodyWeightWorkout,
      lastEditedDate: lastEditedDate,
      workoutCreatedDate: workoutCreatedDate,
      difficulty: difficulty,
      instructions: instructions,
      tips: tips,
      imageIndex: imageIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workoutOwnerId': workoutOwnerId,
      'workoutOwnerUserName': workoutOwnerUserName,
      'workoutTitle': workoutTitle,
      'mainMuscleGroup': mainMuscleGroup,
      'secondaryMuscleGroup': secondaryMuscleGroup,
      'description': description,
      'equipmentRequired': equipmentRequired,
      'imageUrl': imageUrl,
      'isBodyWeightWorkout': isBodyWeightWorkout,
      'lastEditedDate': lastEditedDate,
      'workoutCreatedDate': workoutCreatedDate,
      'difficulty': difficulty,
      'instructions': instructions,
      'tips': tips,
      'imageIndex': imageIndex,
    };
  }
}
