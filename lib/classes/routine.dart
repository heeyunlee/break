import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';

import 'enum/unit_of_mass.dart';

/// Class of a `Routine` is a collection of [Workout]s with some customizable
/// fields such as [MainMuscleGroup], [EquipmentRequired], and [Location] to
/// make it more personalized.
///
/// In a nutshell, it is a same concept as a playlist in a music or video player,
/// where playlist (`Routine`) is a collection of music/videos (`Workouts`) with
/// specific genre (`MainMuscleGroup`, `EquipmentRequired`, etc.).
///
/// It contains a list of [RoutineWorkout]s, which is a extension of [Workout]s
/// but refactored for Routine.
///
/// ## Roadmap
///
/// ### Refactoring
/// * TODO: create enum value for trainingLevel (difficulty)
/// * TODO: create enum value for location
///
/// ### Enhancement
///
class Routine {
  const Routine({
    required this.routineId,
    required this.routineOwnerId,
    required this.routineOwnerUserName,
    required this.routineTitle,
    required this.lastEditedDate,
    required this.routineCreatedDate,
    required this.imageUrl,
    required this.totalWeights,
    required this.duration,
    required this.trainingLevel,
    required this.isPublic,
    required this.location,
    this.mainMuscleGroup,
    this.secondMuscleGroup,
    this.description,
    this.averageTotalCalories,
    this.equipmentRequired,
    this.initialUnitOfMass,
    this.thumbnailImageUrl,
    this.mainMuscleGroupEnum,
    this.equipmentRequiredEnum,
    this.unitOfMassEnum,
  });

  final String routineId;
  final String routineOwnerId;
  final String routineOwnerUserName;
  final String routineTitle;
  final Timestamp lastEditedDate;
  final Timestamp routineCreatedDate;
  final String imageUrl;
  final num totalWeights;
  final int duration;
  final int trainingLevel;
  final bool isPublic;
  final String location;
  final List<dynamic>? mainMuscleGroup; // depreciated
  final List<dynamic>? secondMuscleGroup; // depreciated
  final String? description; // Nullable
  final int? averageTotalCalories; // Nullable
  final List<dynamic>? equipmentRequired; // depreciated
  final int? initialUnitOfMass; // depreciated
  final String? thumbnailImageUrl; // Nullable
  final List<MainMuscleGroup?>? mainMuscleGroupEnum; // Nullable
  final List<EquipmentRequired?>? equipmentRequiredEnum; // Nullable
  final UnitOfMass? unitOfMassEnum; // Nullable

  factory Routine.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String routineOwnerId = data['routineOwnerId'];
      final String routineOwnerUserName = data['routineOwnerUserName'];
      final String routineTitle = data['routineTitle'];
      final Timestamp lastEditedDate = data['lastEditedDate'];
      final Timestamp routineCreatedDate = data['routineCreatedDate'];
      final List<dynamic>? mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
      final String? description = data['description'];
      final String imageUrl = data['imageUrl'];
      final num totalWeights = data['totalWeights'];
      final int? averageTotalCalories = data['averageTotalCalories'];
      final int duration = data['duration'];
      final List<dynamic>? equipmentRequired = data['equipmentRequired'];
      final int trainingLevel = data['trainingLevel'];
      final bool isPublic = data['isPublic'];
      final int? initialUnitOfMass = data['initialUnitOfMass'];
      final String location = data['location'];
      final String? thumbnailImageUrl = data['thumbnailImageUrl'];
      final List<MainMuscleGroup?>? mainMuscleGroupEnum =
          (data['mainMuscleGroupEnum'] != null)
              ? EnumToString.fromList(
                  MainMuscleGroup.values,
                  data['mainMuscleGroupEnum'],
                )
              : null;

      final List<EquipmentRequired?>? equipmentRequiredEnum =
          (data['equipmentRequiredEnum'] != null)
              ? EnumToString.fromList(
                  EquipmentRequired.values,
                  data['equipmentRequiredEnum'],
                )
              : null;

      final UnitOfMass? unitOfMassEnum = (data['unitOfMassEnum'] != null)
          ? EnumToString.fromString<UnitOfMass>(
              UnitOfMass.values,
              data['unitOfMassEnum'],
            )
          : null;

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
        mainMuscleGroupEnum: mainMuscleGroupEnum,
        equipmentRequiredEnum: equipmentRequiredEnum,
        unitOfMassEnum: unitOfMassEnum,
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
      'mainMuscleGroupEnum': mainMuscleGroupEnum
          ?.map((e) => EnumToString.convertToString(e))
          .toList(),
      'equipmentRequiredEnum': equipmentRequiredEnum
          ?.map((e) => EnumToString.convertToString(e))
          .toList(),
      'unitOfMassEnum': EnumToString.convertToString(unitOfMassEnum),
    };
  }
}
