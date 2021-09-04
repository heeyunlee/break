import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

import 'package:workout_player/models/workout_for_youtube.dart';

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
    required this.routineHistoryType,
    this.youtubeWorkouts,
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
  final String? routineHistoryType;
  final List<WorkoutForYoutube>? youtubeWorkouts;

  factory RoutineHistory.fromJson(
      Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'].toString();
      final String username = data['username'].toString();
      final String routineId = data['routineId'].toString();
      final String routineTitle = data['routineTitle'].toString();
      final bool isPublic = data['isPublic'] as bool;
      final Timestamp workoutStartTime = data['workoutStartTime'] as Timestamp;
      final Timestamp workoutEndTime = data['workoutEndTime'] as Timestamp;
      final num totalWeights = num.parse(data['totalWeights'].toString());
      final num? totalCalories =
          num.tryParse(data['totalCalories']?.toString() ?? '');
      final int totalDuration = int.parse(data['totalDuration'].toString());
      final bool? earnedBadges = data['earnedBadges'] as bool?;
      final String? notes = data['notes']?.toString();
      final List<dynamic>? mainMuscleGroup =
          data['mainMuscleGroup'] as List<dynamic>?;
      final List<dynamic>? secondMuscleGroup =
          data['secondMuscleGroup'] as List<dynamic>?;
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'] as bool;
      final DateTime workoutDate = (data['workoutDate'] as Timestamp).toDate();
      final String imageUrl = data['imageUrl'].toString();
      final int? unitOfMass =
          int.tryParse(data['unitOfMass']?.toString() ?? '');

      final List<dynamic>? equipmentRequired =
          data['equipmentRequired'] as List<dynamic>?;

      final num? effort = num.tryParse(data['effort']?.toString() ?? '');
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
              data['unitOfMassEnum'].toString(),
            )
          : null;

      final String? routineHistoryType = data['routineHistoryType']?.toString();
      final List<WorkoutForYoutube>? youtubeWorkouts =
          (data['youtubeWorkouts'] as List<dynamic>?)
              ?.map<WorkoutForYoutube>((workout) =>
                  WorkoutForYoutube.fromMap(workout as Map<String, dynamic>))
              .toList();

      final routineHistory = RoutineHistory(
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
        routineHistoryType: routineHistoryType,
        youtubeWorkouts: youtubeWorkouts,
      );

      return routineHistory;
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
      'routineHistoryType': routineHistoryType,
      'youtubeWorkouts': youtubeWorkouts
          ?.map<Map<String, dynamic>>((workout) => workout.toMap())
          .toList()
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
    String? routineHistoryType,
    List<WorkoutForYoutube>? youtubeWorkouts,
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
      routineHistoryType: routineHistoryType ?? this.routineHistoryType,
      youtubeWorkouts: youtubeWorkouts ?? this.youtubeWorkouts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoutineHistory &&
        other.routineHistoryId == routineHistoryId &&
        other.userId == userId &&
        other.username == username &&
        other.routineId == routineId &&
        other.routineTitle == routineTitle &&
        other.isPublic == isPublic &&
        other.workoutStartTime == workoutStartTime &&
        other.workoutEndTime == workoutEndTime &&
        other.totalWeights == totalWeights &&
        other.totalCalories == totalCalories &&
        other.totalDuration == totalDuration &&
        other.earnedBadges == earnedBadges &&
        other.notes == notes &&
        listEquals(other.mainMuscleGroup, mainMuscleGroup) &&
        listEquals(other.secondMuscleGroup, secondMuscleGroup) &&
        other.isBodyWeightWorkout == isBodyWeightWorkout &&
        other.workoutDate == workoutDate &&
        other.imageUrl == imageUrl &&
        other.unitOfMass == unitOfMass &&
        listEquals(other.equipmentRequired, equipmentRequired) &&
        other.effort == effort &&
        listEquals(other.mainMuscleGroupEnum, mainMuscleGroupEnum) &&
        listEquals(other.equipmentRequiredEnum, equipmentRequiredEnum) &&
        other.unitOfMassEnum == unitOfMassEnum &&
        other.routineHistoryType == routineHistoryType &&
        listEquals(other.youtubeWorkouts, youtubeWorkouts);
  }

  @override
  int get hashCode {
    return routineHistoryId.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        routineId.hashCode ^
        routineTitle.hashCode ^
        isPublic.hashCode ^
        workoutStartTime.hashCode ^
        workoutEndTime.hashCode ^
        totalWeights.hashCode ^
        totalCalories.hashCode ^
        totalDuration.hashCode ^
        earnedBadges.hashCode ^
        notes.hashCode ^
        mainMuscleGroup.hashCode ^
        secondMuscleGroup.hashCode ^
        isBodyWeightWorkout.hashCode ^
        workoutDate.hashCode ^
        imageUrl.hashCode ^
        unitOfMass.hashCode ^
        equipmentRequired.hashCode ^
        effort.hashCode ^
        mainMuscleGroupEnum.hashCode ^
        equipmentRequiredEnum.hashCode ^
        unitOfMassEnum.hashCode ^
        routineHistoryType.hashCode ^
        youtubeWorkouts.hashCode;
  }

  @override
  String toString() {
    return 'RoutineHistory(routineHistoryId: $routineHistoryId, userId: $userId, username: $username, routineId: $routineId, routineTitle: $routineTitle, isPublic: $isPublic, workoutStartTime: $workoutStartTime, workoutEndTime: $workoutEndTime, totalWeights: $totalWeights, totalCalories: $totalCalories, totalDuration: $totalDuration, earnedBadges: $earnedBadges, notes: $notes, mainMuscleGroup: $mainMuscleGroup, secondMuscleGroup: $secondMuscleGroup, isBodyWeightWorkout: $isBodyWeightWorkout, workoutDate: $workoutDate, imageUrl: $imageUrl, unitOfMass: $unitOfMass, equipmentRequired: $equipmentRequired, effort: $effort, mainMuscleGroupEnum: $mainMuscleGroupEnum, equipmentRequiredEnum: $equipmentRequiredEnum, unitOfMassEnum: $unitOfMassEnum, routineHistoryType: $routineHistoryType, youtubeWorkouts: $youtubeWorkouts)';
  }
}
