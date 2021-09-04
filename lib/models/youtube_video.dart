import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/workout_for_youtube.dart';
import 'package:workout_player/utils/formatter.dart';

class YoutubeVideo {
  const YoutubeVideo({
    required this.youtubeVideoId,
    required this.videoId,
    required this.thumnail,
    required this.title,
    required this.mainMuscleGroups,
    required this.duration,
    required this.location,
    required this.authorName,
    required this.authorProfilePicture,
    required this.videoUrl,
    required this.blurHash,
    required this.workouts,
    required this.equipmentsRequired,
    required this.caloriesBurnt,
    required this.totalWeights,
  });

  final String youtubeVideoId;
  final String videoId;
  final String thumnail;
  final String title;
  final List<MainMuscleGroup?> mainMuscleGroups;
  final Duration duration;
  final Location location;
  final String authorName;
  final String authorProfilePicture;
  final String videoUrl;
  final String blurHash;
  final List<WorkoutForYoutube> workouts;
  final List<EquipmentRequired?> equipmentsRequired;
  final num caloriesBurnt;
  final num totalWeights;

  Map<String, dynamic> toMap() {
    return {
      'youtubeVideoId': youtubeVideoId,
      'videoId': videoId,
      'thumnail': thumnail,
      'title': title,
      'mainMuscleGroups': EnumToString.toList(mainMuscleGroups),
      'duration': duration.toString(),
      'location': EnumToString.convertToString(location),
      'authorName': authorName,
      'authorProfilePicture': authorProfilePicture,
      'videoUrl': videoUrl,
      'blurHash': blurHash,
      'workouts': workouts
          .map<Map<String, dynamic>>((workout) => workout.toMap())
          .toList(),
      'equipmentsRequired': EnumToString.toList(equipmentsRequired),
      'caloriesBurnt': caloriesBurnt,
      'totalWeights': totalWeights,
    };
  }

  factory YoutubeVideo.fromMap(Map<String, dynamic>? map, String id) {
    if (map != null) {
      final String videoId = map['videoId'].toString();
      final String thumnail = map['thumnail'].toString();
      final String title = map['title'].toString();
      final List<MainMuscleGroup?> mainMuscleGroups = EnumToString.fromList(
          MainMuscleGroup.values, map['mainMuscleGroups'] as List<dynamic>);
      final Duration duration =
          Formatter.stringToDuration(map['duration'].toString());
      final Location location =
          EnumToString.fromString(Location.values, map['location'].toString())!;
      final String authorName = map['authorName'].toString();
      final String authorProfilePicture =
          map['authorProfilePicture'].toString();
      final String videoUrl = map['videoUrl'].toString();
      final String blurHash = map['blurHash'].toString();
      final List<WorkoutForYoutube> workouts =
          (map['workouts'] as List<dynamic>)
              .map<WorkoutForYoutube>((workout) =>
                  WorkoutForYoutube.fromMap(workout as Map<String, dynamic>))
              .toList();
      final List<EquipmentRequired?> equipmentsRequired = EnumToString.fromList(
          EquipmentRequired.values, map['equipmentsRequired'] as List<dynamic>);
      final num caloriesBurnt = num.parse(map['caloriesBurnt'].toString());
      final num totalWeights = num.parse(map['totalWeights'].toString());

      return YoutubeVideo(
        youtubeVideoId: id,
        videoId: videoId,
        thumnail: thumnail,
        title: title,
        mainMuscleGroups: mainMuscleGroups,
        duration: duration,
        location: location,
        authorName: authorName,
        authorProfilePicture: authorProfilePicture,
        videoUrl: videoUrl,
        blurHash: blurHash,
        workouts: workouts,
        equipmentsRequired: equipmentsRequired,
        caloriesBurnt: caloriesBurnt,
        totalWeights: totalWeights,
      );
    } else {
      throw '';
    }
  }

  YoutubeVideo copyWith({
    String? youtubeVideoId,
    String? videoId,
    String? thumnail,
    String? title,
    List<MainMuscleGroup?>? mainMuscleGroups,
    Duration? duration,
    Location? location,
    String? authorName,
    String? authorProfilePicture,
    String? videoUrl,
    String? blurHash,
    List<WorkoutForYoutube>? workouts,
    List<EquipmentRequired?>? equipmentsRequired,
    num? caloriesBurnt,
    num? totalWeights,
  }) {
    return YoutubeVideo(
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      videoId: videoId ?? this.videoId,
      thumnail: thumnail ?? this.thumnail,
      title: title ?? this.title,
      mainMuscleGroups: mainMuscleGroups ?? this.mainMuscleGroups,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      authorName: authorName ?? this.authorName,
      authorProfilePicture: authorProfilePicture ?? this.authorProfilePicture,
      videoUrl: videoUrl ?? this.videoUrl,
      blurHash: blurHash ?? this.blurHash,
      workouts: workouts ?? this.workouts,
      equipmentsRequired: equipmentsRequired ?? this.equipmentsRequired,
      caloriesBurnt: caloriesBurnt ?? this.caloriesBurnt,
      totalWeights: totalWeights ?? this.totalWeights,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory YoutubeVideo.fromJson(String source) =>
  //     YoutubeVideo.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is YoutubeVideo &&
        other.youtubeVideoId == youtubeVideoId &&
        other.videoId == videoId &&
        other.thumnail == thumnail &&
        other.title == title &&
        listEquals(other.mainMuscleGroups, mainMuscleGroups) &&
        other.duration == duration &&
        other.location == location &&
        other.authorName == authorName &&
        other.authorProfilePicture == authorProfilePicture &&
        other.videoUrl == videoUrl &&
        other.blurHash == blurHash &&
        listEquals(other.workouts, workouts) &&
        listEquals(other.equipmentsRequired, equipmentsRequired) &&
        other.caloriesBurnt == caloriesBurnt &&
        other.totalWeights == totalWeights;
  }

  @override
  int get hashCode {
    return youtubeVideoId.hashCode ^
        videoId.hashCode ^
        thumnail.hashCode ^
        title.hashCode ^
        mainMuscleGroups.hashCode ^
        duration.hashCode ^
        location.hashCode ^
        authorName.hashCode ^
        authorProfilePicture.hashCode ^
        videoUrl.hashCode ^
        blurHash.hashCode ^
        workouts.hashCode ^
        equipmentsRequired.hashCode ^
        caloriesBurnt.hashCode ^
        totalWeights.hashCode;
  }

  @override
  String toString() {
    return 'YoutubeVideo(youtubeVideoId: $youtubeVideoId, videoId: $videoId, thumnail: $thumnail, title: $title, mainMuscleGroups: $mainMuscleGroups, duration: $duration, location: $location, authorName: $authorName, authorProfilePicture: $authorProfilePicture, videoUrl: $videoUrl, blurHash: $blurHash, workouts: $workouts, equipmentsRequired: $equipmentsRequired, caloriesBurnt: $caloriesBurnt, totalWeights: $totalWeights)';
  }
}
