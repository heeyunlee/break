import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:workout_player/generated/l10n.dart';

import 'enum/equipment_required.dart';
import 'enum/main_muscle_group.dart';

class RoutineHistory {
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
  final int unitOfMass;
  final List<dynamic>? equipmentRequired;
  final num? effort; // Nullable
  final List<MainMuscleGroup?>? mainMuscleGroupEnum; // Nullable
  final List<EquipmentRequired?>? equipmentRequiredEnum; // Nullable

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
    required this.mainMuscleGroup,
    this.secondMuscleGroup,
    required this.isBodyWeightWorkout,
    required this.workoutDate,
    required this.imageUrl,
    required this.unitOfMass,
    required this.equipmentRequired,
    this.effort,
    this.mainMuscleGroupEnum,
    this.equipmentRequiredEnum,
  });

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
      final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
      final DateTime workoutDate = data['workoutDate'].toDate();
      final String imageUrl = data['imageUrl'];
      final int unitOfMass = data['unitOfMass'];
      final List<dynamic> equipmentRequired = data['equipmentRequired'];
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
          .toList()
    };
  }
}

class RoutineHistoryModel {
  String getFirstMainMuscleGroup(RoutineHistory routineHistory) {
    if (routineHistory.mainMuscleGroupEnum != null) {
      return routineHistory.mainMuscleGroupEnum![0]!.translation!;
    } else if (routineHistory.mainMuscleGroup != null) {
      return MainMuscleGroup.values
          .firstWhere((e) => e.toString() == routineHistory.mainMuscleGroup![0])
          .translation!;
    } else {
      return S.current.mainMuscleGroup;
    }
  }

  String getJoinedMainMuscleGroups(RoutineHistory routineHistory) {
    final enums = routineHistory.mainMuscleGroupEnum;
    final strings = routineHistory.mainMuscleGroup;

    if (enums != null) {
      final list = enums.map((muscle) => muscle!.translation!).toList();

      return list.join(', ');
    } else if (strings != null) {
      final list = strings
          .map((muscle) => MainMuscleGroup.values
              .firstWhere((e) => e.toString() == muscle)
              .translation!)
          .toList();

      return list.join(', ');
    } else {
      return S.current.mainMuscleGroup;
    }
  }

  List<String> getListOfMailMuscleGroup(RoutineHistory routineHistory) {
    final enums = routineHistory.mainMuscleGroupEnum;
    final strings = routineHistory.mainMuscleGroup;

    if (enums != null) {
      return enums.map((muscle) => muscle!.translation!).toList();
    } else if (strings != null) {
      return strings
          .map((muscle) => MainMuscleGroup.values
              .firstWhere((e) => e.toString() == muscle)
              .translation!)
          .toList();
    } else {
      return [];
    }
  }

  String getJoinedEquipmentsRequired(RoutineHistory routineHistory) {
    final enums = routineHistory.equipmentRequiredEnum;
    final strings = routineHistory.equipmentRequired;

    if (enums != null) {
      final list = enums.map((equipment) => equipment!.translation!).toList();

      return list.join(', ');
    } else if (strings != null) {
      final list = strings
          .map((equipment) => EquipmentRequired.values
              .firstWhere((e) => e.toString() == equipment)
              .translation!)
          .toList();

      return list.join(', ');
    } else {
      return S.current.equipmentRequired;
    }
  }

  List<String> getListOfEquipments(RoutineHistory routineHistory) {
    final enums = routineHistory.equipmentRequiredEnum;
    final strings = routineHistory.equipmentRequired;

    if (enums != null) {
      return enums.map((equipment) => equipment!.translation!).toList();
    } else if (strings != null) {
      return strings
          .map((equipment) => EquipmentRequired.values
              .firstWhere((e) => e.toString() == equipment)
              .translation!)
          .toList();
    } else {
      return [];
    }
  }
}
