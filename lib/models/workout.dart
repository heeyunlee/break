import 'package:flutter/foundation.dart';

class Workout {
  Workout({
    @required this.workoutId,
    @required this.workoutOwnerId,
    @required this.workoutTitle,
    @required this.mainMuscleGroup,
    @required this.secondaryMuscleGroup,
    @required this.description,
    @required this.equipmentRequired,
    this.imageUrl,
    this.isBodyWeightWorkout,
    // TODO: Add these data later
    // this.forceType,
    // this.exerciseType,
    // this.mechanics,
    // this.experienceLevel,
    // this.instructions,
    // this.tips,
  });

  final String workoutId;
  final String workoutOwnerId;
  final String workoutTitle;
  final String mainMuscleGroup;
  final List secondaryMuscleGroup;
  final String description;
  final String equipmentRequired;
  final String imageUrl;
  final bool isBodyWeightWorkout;
  // TODO: ADD these data later
  // final String forceType;
  // final String exerciseType;
  // final String mechanics;
  // final String experienceLevel;
  // final String instructions;
  // final String tips;

  factory Workout.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String workoutOwnerId = data['workoutOwnerId'];
    final String workoutTitle = data['workoutTitle'];
    final String mainMuscleGroup = data['mainMuscleGroup'];
    final List secondaryMuscleGroup = data['secondaryMuscleGroup'];
    final String description = data['description'];
    final String equipmentRequired = data['equipmentRequired'];
    final String imageUrl = data['imageUrl'];
    final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
    // TODO: Add these later
    // final String forceType = data['forceType'];
    // final String exerciseType = data['exerciseType'];
    // final String mechanics = data['mechanics'];
    // final String experienceLevel = data['experienceLevel'];
    // final String instructions = data['instructions'];
    // final String tips = data['tips'];

    return Workout(
      workoutId: documentId,
      workoutOwnerId: workoutOwnerId,
      workoutTitle: workoutTitle,
      mainMuscleGroup: mainMuscleGroup,
      secondaryMuscleGroup: secondaryMuscleGroup,
      description: description,
      equipmentRequired: equipmentRequired,
      imageUrl: imageUrl,
      isBodyWeightWorkout: isBodyWeightWorkout,
      // forceType: forceType,
      // exerciseType: exerciseType,
      // mechanics: mechanics,
      // experienceLevel: experienceLevel,
      // instructions: instructions,
      // tips: tips,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workoutOwnerId': workoutOwnerId,
      'workoutTitle': workoutTitle,
      'mainMuscleGroup': mainMuscleGroup,
      'secondaryMuscleGroup': secondaryMuscleGroup,
      'description': description,
      'equipmentRequired': equipmentRequired,
      'imageUrl': imageUrl,
      'isBodyWeightWorkout': isBodyWeightWorkout,
      // 'forceType': forceType,
      // 'exerciseType': exerciseType,
      // 'mechanics': mechanics,
      // 'experienceLevel': experienceLevel,
      // 'instructions': instructions,
      // 'tips': tips,
    };
  }
}
