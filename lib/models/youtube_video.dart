import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/workout_for_youtube.dart';

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'youtubeVideoId': youtubeVideoId,
      'videoId': videoId,
      'thumnail': thumnail,
      'title': title,
      'mainMuscleGroups': EnumToString.toList(mainMuscleGroups),
      'duration': duration,
      'location': EnumToString.convertToString(location),
      'authorName': authorName,
      'authorProfilePicture': authorProfilePicture,
      'videoUrl': videoUrl,
      'blurHash': blurHash,
      'workouts': workouts.map((workout) => workout.toMap()).toList(),
    };
  }

  factory YoutubeVideo.fromMap(Map<String, dynamic> map) {
    final String id = map['youtubeVideoId'];
    final String videoId = map['videoId'];
    final String thumnail = map['thumnail'];
    final String title = map['title'];
    final List<MainMuscleGroup?> mainMuscleGroups =
        EnumToString.fromList(MainMuscleGroup.values, map['mainMuscleGroups']);
    final Duration duration = map['duration'];
    final Location location =
        EnumToString.fromString(Location.values, map['location'])!;
    final String authorName = map['authorName'];
    final String authorProfilePicture = map['authorProfilePicture'];
    final String videoUrl = map['videoUrl'];
    final String blurHash = map['blurHash'];
    final List<WorkoutForYoutube> workouts =
        map['workouts']?.map((workout) => workout.toMap()).toList();

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
    );
  }

  String toJson() => json.encode(toMap());

  factory YoutubeVideo.fromJson(String source) =>
      YoutubeVideo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'YoutubeVideo(youtubeVideoId: $youtubeVideoId, videoId: $videoId, thumnail: $thumnail, title: $title, mainMuscleGroups: $mainMuscleGroups, duration: $duration, location: $location, authorName: $authorName, authorProfilePicture: $authorProfilePicture, videoUrl: $videoUrl, blurHash: $blurHash, workouts: $workouts)';
  }

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
        listEquals(other.workouts, workouts);
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
        workouts.hashCode;
  }
}
