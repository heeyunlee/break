import 'package:cloud_firestore/cloud_firestore.dart';

class Routine {
  Routine({
    required this.routineId,
    required this.routineOwnerId,
    required this.routineOwnerUserName,
    required this.routineTitle,
    required this.lastEditedDate,
    required this.routineCreatedDate,
    required this.mainMuscleGroup,
    this.secondMuscleGroup,
    this.description,
    required this.imageUrl,
    required this.totalWeights,
    this.averageTotalCalories,
    required this.duration,
    required this.equipmentRequired,
    required this.trainingLevel,
    required this.isPublic,
    required this.initialUnitOfMass,
    required this.location,
    this.thumbnailImageUrl,
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
  final List<dynamic>? secondMuscleGroup;
  final String? description;
  final String imageUrl;
  final num totalWeights;
  final int? averageTotalCalories;
  final int duration;
  final List<dynamic> equipmentRequired;
  final int trainingLevel;
  final bool isPublic;
  final int initialUnitOfMass;
  final String location;
  final String? thumbnailImageUrl;
  // final String tags;
  // final String routineGoal;
  // final String workoutType;

  factory Routine.fromMap(Map<String, dynamic> data, String documentId) {
    // if (data == null) {
    //   return null;
    // }
    final String routineOwnerId = data['routineOwnerId'];
    final String routineOwnerUserName = data['routineOwnerUserName'];
    final String routineTitle = data['routineTitle'];
    final Timestamp lastEditedDate = data['lastEditedDate'];
    final Timestamp routineCreatedDate = data['routineCreatedDate'];
    final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
    final List<dynamic> secondMuscleGroup = data['secondMuscleGroup'];
    final String description = data['description'];
    final String imageUrl = data['imageUrl'];
    final num totalWeights = data['totalWeights'];
    final int averageTotalCalories = data['averageTotalCalories'];
    final int duration = data['duration'];
    final List<dynamic> equipmentRequired = data['equipmentRequired'];
    final int trainingLevel = data['trainingLevel'];
    final bool isPublic = data['isPublic'];
    final int initialUnitOfMass = data['initialUnitOfMass'];
    final String location = data['location'];
    final String thumbnailImageUrl = data['thumbnailImageUrl'];
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
      location: location,
      thumbnailImageUrl: thumbnailImageUrl,
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
      'location': location,
      'thumbnailImageUrl': thumbnailImageUrl,
      // 'tags': tags,
      // 'routineGoal': routineGoal,
      // 'workoutType': workoutType,
    };
  }
}
