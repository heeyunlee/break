import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Workout {
  final String workoutId;
  final String workoutOwnerId;
  final String workoutOwnerUserName;
  final String workoutTitle;
  final List<dynamic> mainMuscleGroup;
  final List<dynamic>? secondaryMuscleGroup; // Nullable
  final String description;
  final List<dynamic> equipmentRequired;
  final String imageUrl;
  final bool isBodyWeightWorkout;
  final Timestamp lastEditedDate;
  final Timestamp workoutCreatedDate;
  final int difficulty;
  final String? instructions; // Nullable
  final String? tips; // Nullable
  final int secondsPerRep;
  final bool isPublic;
  final String location;
  final Map<String, dynamic> translated;
  final String? thumbnailImageUrl; // Nullable
  final List<dynamic>? tags; // Nullable
  final Map<String, dynamic>? translatedDescription; // Nullable

  const Workout({
    required this.workoutId,
    required this.workoutOwnerId,
    required this.workoutOwnerUserName,
    required this.workoutTitle,
    required this.mainMuscleGroup,
    required this.secondaryMuscleGroup,
    required this.description,
    required this.equipmentRequired,
    required this.imageUrl,
    required this.isBodyWeightWorkout,
    required this.lastEditedDate,
    required this.workoutCreatedDate,
    required this.difficulty,
    this.instructions,
    this.tips,
    required this.secondsPerRep,
    required this.isPublic,
    required this.location,
    required this.translated,
    this.thumbnailImageUrl,
    this.tags,
    this.translatedDescription,
  });

  factory Workout.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String workoutOwnerId = data['workoutOwnerId'];
      final String workoutOwnerUserName = data['workoutOwnerUserName'];
      final String workoutTitle = data['workoutTitle'];
      final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondaryMuscleGroup = data['secondaryMuscleGroup'];
      final String description = data['description'];
      final List<dynamic> equipmentRequired = data['equipmentRequired'];
      final String imageUrl = data['imageUrl'];
      // final bool isBodyWeightWorkout =
      //     (data['isBodyWeightWorkout'].runtimeType == bool)
      //         ? data['isBodyWeightWorkout']
      //         : data['isBodyWeightWorkout'].parseBool();
      final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];

      final Timestamp lastEditedDate = data['lastEditedDate'];
      final Timestamp workoutCreatedDate = data['workoutCreatedDate'];
      final int difficulty = data['difficulty'];
      // final int difficulty = (data['difficulty'].runtimeType == int)
      //     ? data['difficulty']
      //     : int.parse(data['difficulty']);

      final String? instructions = data['instructions'];
      final String? tips = data['tips'];
      final int secondsPerRep = data['secondsPerRep'];
      final bool isPublic = data['isPublic'];
      final String location = data['location'];
      final Map<String, dynamic> translated = data['translated'];
      final String? thumbnailImageUrl = data['thumbnailImageUrl'];
      final List<dynamic>? tags = data['tags'];
      final Map<String, dynamic>? translatedDescription =
          data['translatedDescription'];

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
        secondsPerRep: secondsPerRep,
        isPublic: isPublic,
        location: location,
        translated: translated,
        thumbnailImageUrl: thumbnailImageUrl,
        tags: tags,
        translatedDescription: translatedDescription,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
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
      'secondsPerRep': secondsPerRep,
      'isPublic': isPublic,
      'location': location,
      'translated': translated,
      'thumbnailImageUrl': thumbnailImageUrl,
      'tags': tags,
      'translatedDescription': translatedDescription,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Workout &&
        other.workoutId == workoutId &&
        other.workoutOwnerId == workoutOwnerId &&
        other.workoutOwnerUserName == workoutOwnerUserName &&
        other.workoutTitle == workoutTitle &&
        listEquals(other.mainMuscleGroup, mainMuscleGroup) &&
        listEquals(other.secondaryMuscleGroup, secondaryMuscleGroup) &&
        other.description == description &&
        listEquals(other.equipmentRequired, equipmentRequired) &&
        other.imageUrl == imageUrl &&
        other.isBodyWeightWorkout == isBodyWeightWorkout &&
        other.lastEditedDate == lastEditedDate &&
        other.workoutCreatedDate == workoutCreatedDate &&
        other.difficulty == difficulty &&
        other.instructions == instructions &&
        other.tips == tips &&
        other.secondsPerRep == secondsPerRep &&
        other.isPublic == isPublic &&
        other.location == location &&
        mapEquals(other.translated, translated) &&
        other.thumbnailImageUrl == thumbnailImageUrl &&
        listEquals(other.tags, tags) &&
        mapEquals(other.translatedDescription, translatedDescription);
  }

  @override
  int get hashCode {
    return workoutId.hashCode ^
        workoutOwnerId.hashCode ^
        workoutOwnerUserName.hashCode ^
        workoutTitle.hashCode ^
        mainMuscleGroup.hashCode ^
        secondaryMuscleGroup.hashCode ^
        description.hashCode ^
        equipmentRequired.hashCode ^
        imageUrl.hashCode ^
        isBodyWeightWorkout.hashCode ^
        lastEditedDate.hashCode ^
        workoutCreatedDate.hashCode ^
        difficulty.hashCode ^
        instructions.hashCode ^
        tips.hashCode ^
        secondsPerRep.hashCode ^
        isPublic.hashCode ^
        location.hashCode ^
        translated.hashCode ^
        thumbnailImageUrl.hashCode ^
        tags.hashCode ^
        translatedDescription.hashCode;
  }
}
