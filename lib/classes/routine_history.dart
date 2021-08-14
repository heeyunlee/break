import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'enum/equipment_required.dart';
import 'enum/main_muscle_group.dart';
import 'enum/unit_of_mass.dart';

class RoutineHistory {
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
    this.mainMuscleGroup,
    this.secondMuscleGroup,
    required this.isBodyWeightWorkout,
    required this.workoutDate,
    required this.imageUrl,
    this.unitOfMass,
    this.equipmentRequired,
    this.effort,
    this.mainMuscleGroupEnum,
    this.equipmentRequiredEnum,
    this.unitOfMassEnum,
  });

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
  final List<dynamic>? mainMuscleGroup;
  final List<dynamic>? secondMuscleGroup; // Nullable
  final bool isBodyWeightWorkout;
  final DateTime workoutDate;
  final String imageUrl;
  final int? unitOfMass;
  final List<dynamic>? equipmentRequired;
  final num? effort; // Nullable
  final List<MainMuscleGroup?>? mainMuscleGroupEnum; // Nullable
  final List<EquipmentRequired?>? equipmentRequiredEnum; // Nullable
  final UnitOfMass? unitOfMassEnum; // Nullable

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
      final List<dynamic>? mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
      final DateTime workoutDate = data['workoutDate'].toDate();
      final String imageUrl = data['imageUrl'];
      final int? unitOfMass = data['unitOfMass'];
      final List<dynamic>? equipmentRequired = data['equipmentRequired'];
      final num? effort = data['effort'];
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
      'mainMuscleGroupEnum': mainMuscleGroupEnum
          ?.map((e) => EnumToString.convertToString(e))
          .toList(),
      'equipmentRequiredEnum': equipmentRequiredEnum
          ?.map((e) => EnumToString.convertToString(e))
          .toList(),
      'unitOfMassEnum': (unitOfMassEnum != null)
          ? EnumToString.convertToString(unitOfMassEnum)
          : null,
    };
  }

  RoutineHistory copyWith({
    String? routineHistoryId,
    String? userId,
    String? username,
    String? routineId,
    String? routineTitle,
    bool? isPublic,
    Timestamp? workoutStartTime,
    Timestamp? workoutEndTime,
    num? totalWeights,
    num? totalCalories,
    int? totalDuration,
    bool? earnedBadges,
    String? notes,
    List<dynamic>? mainMuscleGroup,
    List<dynamic>? secondMuscleGroup,
    bool? isBodyWeightWorkout,
    DateTime? workoutDate,
    String? imageUrl,
    int? unitOfMass,
    List<dynamic>? equipmentRequired,
    num? effort,
    List<MainMuscleGroup?>? mainMuscleGroupEnum,
    List<EquipmentRequired?>? equipmentRequiredEnum,
    UnitOfMass? unitOfMassEnum,
  }) {
    return RoutineHistory(
      routineHistoryId: routineHistoryId ?? this.routineHistoryId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      routineId: routineId ?? this.routineId,
      routineTitle: routineTitle ?? this.routineTitle,
      isPublic: isPublic ?? this.isPublic,
      workoutStartTime: workoutStartTime ?? this.workoutStartTime,
      workoutEndTime: workoutEndTime ?? this.workoutEndTime,
      totalWeights: totalWeights ?? this.totalWeights,
      totalCalories: totalCalories ?? this.totalCalories,
      totalDuration: totalDuration ?? this.totalDuration,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      notes: notes ?? this.notes,
      mainMuscleGroup: mainMuscleGroup ?? this.mainMuscleGroup,
      secondMuscleGroup: secondMuscleGroup ?? this.secondMuscleGroup,
      isBodyWeightWorkout: isBodyWeightWorkout ?? this.isBodyWeightWorkout,
      workoutDate: workoutDate ?? this.workoutDate,
      imageUrl: imageUrl ?? this.imageUrl,
      unitOfMass: unitOfMass ?? this.unitOfMass,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      effort: effort ?? this.effort,
      mainMuscleGroupEnum: mainMuscleGroupEnum ?? this.mainMuscleGroupEnum,
      equipmentRequiredEnum:
          equipmentRequiredEnum ?? this.equipmentRequiredEnum,
      unitOfMassEnum: unitOfMassEnum ?? this.unitOfMassEnum,
    );
  }
}
