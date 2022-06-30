import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

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
/// * TODO(heeyunlee): create enum value for trainingLevel (difficulty)
/// * TODO(heeyunlee): create enum value for location
/// * TODO(heeyunlee): rid of depreciated non-enum values
///
/// ### Enhancement
/// * TODO(heeyunlee): create `type,` which could be either weight training,
/// cardio, yoga, stretching, video routine, etc., so the input constructor for
/// [RoutineWorkout] could be more diversified
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
      final String routineOwnerId = data['routineOwnerId'].toString();
      final String routineOwnerUserName =
          data['routineOwnerUserName'].toString();
      final String routineTitle = data['routineTitle'].toString();
      final Timestamp lastEditedDate = data['lastEditedDate'] as Timestamp;
      final Timestamp routineCreatedDate =
          data['routineCreatedDate'] as Timestamp;
      final List<dynamic>? mainMuscleGroup =
          data['mainMuscleGroup'] as List<dynamic>?;
      final List<dynamic>? secondMuscleGroup =
          data['secondMuscleGroup'] as List<dynamic>?;
      final String? description = data['description']?.toString();
      final String imageUrl = data['imageUrl'].toString();
      final num totalWeights = data['totalWeights'] as num;
      final int? averageTotalCalories =
          int.tryParse(data['averageTotalCalories'].toString());
      final int duration = data['duration'] as int;
      final List<dynamic>? equipmentRequired =
          data['equipmentRequired'] as List<dynamic>?;
      final int trainingLevel = data['trainingLevel'] as int;
      final bool isPublic = data['isPublic'] as bool;
      final int? initialUnitOfMass = data['initialUnitOfMass'] as int?;
      final String location = data['location'] as String;
      final String? thumbnailImageUrl = data['thumbnailImageUrl'] as String?;
      final List<MainMuscleGroup?>? mainMuscleGroupEnum =
          (data['mainMuscleGroupEnum'] != null)
              ? EnumToString.fromList(
                  MainMuscleGroup.values,
                  data['mainMuscleGroupEnum'] as List<dynamic>,
                )
              : null;

      final List<EquipmentRequired?>? equipmentRequiredEnum =
          (data['equipmentRequiredEnum'] != null)
              ? EnumToString.fromList(
                  EquipmentRequired.values,
                  data['equipmentRequiredEnum'] as List<dynamic>,
                )
              : null;

      final UnitOfMass? unitOfMassEnum = (data['unitOfMassEnum'] != null)
          ? EnumToString.fromString<UnitOfMass>(
              UnitOfMass.values,
              data['unitOfMassEnum'] as String,
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
