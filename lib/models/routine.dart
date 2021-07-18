import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Routine {
  final String routineId;
  final String routineOwnerId;
  final String routineOwnerUserName;
  final String routineTitle;
  final Timestamp lastEditedDate;
  final Timestamp routineCreatedDate;
  final List<dynamic> mainMuscleGroup;
  final List<dynamic>? secondMuscleGroup; // Nullable
  final String? description; // Nullable
  final String imageUrl;
  final num totalWeights;
  final int? averageTotalCalories; // Nullable
  final int duration;
  final List<dynamic> equipmentRequired;
  final int trainingLevel;
  final bool isPublic;
  final int initialUnitOfMass;
  final String location;
  final String? thumbnailImageUrl; // Nullable

  const Routine({
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
  });

  factory Routine.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String routineOwnerId = data['routineOwnerId'];
      final String routineOwnerUserName = data['routineOwnerUserName'];
      final String routineTitle = data['routineTitle'];
      final Timestamp lastEditedDate = data['lastEditedDate'];
      final Timestamp routineCreatedDate = data['routineCreatedDate'];
      final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
      final String? description = data['description'];
      final String imageUrl = data['imageUrl'];
      final num totalWeights = data['totalWeights'];
      final int? averageTotalCalories = data['averageTotalCalories'];
      final int duration = data['duration'];
      final List<dynamic> equipmentRequired = data['equipmentRequired'];
      final int trainingLevel = data['trainingLevel'];
      final bool isPublic = data['isPublic'];
      final int initialUnitOfMass = data['initialUnitOfMass'];
      final String location = data['location'];
      final String? thumbnailImageUrl = data['thumbnailImageUrl'];

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
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
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
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Routine &&
        other.routineId == routineId &&
        other.routineOwnerId == routineOwnerId &&
        other.routineOwnerUserName == routineOwnerUserName &&
        other.routineTitle == routineTitle &&
        other.lastEditedDate == lastEditedDate &&
        other.routineCreatedDate == routineCreatedDate &&
        listEquals(other.mainMuscleGroup, mainMuscleGroup) &&
        listEquals(other.secondMuscleGroup, secondMuscleGroup) &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.totalWeights == totalWeights &&
        other.averageTotalCalories == averageTotalCalories &&
        other.duration == duration &&
        listEquals(other.equipmentRequired, equipmentRequired) &&
        other.trainingLevel == trainingLevel &&
        other.isPublic == isPublic &&
        other.initialUnitOfMass == initialUnitOfMass &&
        other.location == location &&
        other.thumbnailImageUrl == thumbnailImageUrl;
  }

  @override
  int get hashCode {
    return routineId.hashCode ^
        routineOwnerId.hashCode ^
        routineOwnerUserName.hashCode ^
        routineTitle.hashCode ^
        lastEditedDate.hashCode ^
        routineCreatedDate.hashCode ^
        mainMuscleGroup.hashCode ^
        secondMuscleGroup.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        totalWeights.hashCode ^
        averageTotalCalories.hashCode ^
        duration.hashCode ^
        equipmentRequired.hashCode ^
        trainingLevel.hashCode ^
        isPublic.hashCode ^
        initialUnitOfMass.hashCode ^
        location.hashCode ^
        thumbnailImageUrl.hashCode;
  }
}
