import 'dart:convert';

import 'package:flutter/foundation.dart';

class WorkoutForYoutube {
  final String workoutForYoutubeId;
  final String workoutId;
  final String workoutTitle;
  final Map<String, dynamic> translatedWorkoutTitle;
  final Duration position;
  final bool isRepsBased;
  final int? reps;
  final Duration? duration;

  const WorkoutForYoutube({
    required this.workoutForYoutubeId,
    required this.workoutId,
    required this.workoutTitle,
    required this.translatedWorkoutTitle,
    required this.position,
    required this.isRepsBased,
    this.reps,
    this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'workoutForYoutubeId': workoutForYoutubeId,
      'position': position,
      'isRepsBased': isRepsBased,
      'reps': reps,
      'duration': duration,
    };
  }

  factory WorkoutForYoutube.fromMap(Map<String, dynamic> map) {
    final String id = map['workoutForYoutubeId'];
    final String workoutId = map['workoutId'];
    final String workoutTitle = map['workoutTitle'];
    final Map<String, dynamic> translatedWorkoutTitle =
        map['translatedWorkoutTitle'];
    final Duration position = map['position'];
    final bool isRepsBased = map['isRepsBased'];
    final int? reps = map['reps'];
    final Duration? duration = map['duration'];

    return WorkoutForYoutube(
      workoutForYoutubeId: id,
      workoutId: workoutId,
      workoutTitle: workoutTitle,
      translatedWorkoutTitle: translatedWorkoutTitle,
      position: position,
      isRepsBased: isRepsBased,
      reps: reps,
      duration: duration,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutForYoutube.fromJson(String source) =>
      WorkoutForYoutube.fromMap(json.decode(source));

  WorkoutForYoutube copyWith({
    String? workoutForYoutubeId,
    String? workoutId,
    String? workoutTitle,
    Map<String, dynamic>? translatedWorkoutTitle,
    Duration? position,
    bool? isRepsBased,
    int? reps,
    Duration? duration,
  }) {
    return WorkoutForYoutube(
      workoutForYoutubeId: workoutForYoutubeId ?? this.workoutForYoutubeId,
      workoutId: workoutId ?? this.workoutId,
      workoutTitle: workoutTitle ?? this.workoutTitle,
      translatedWorkoutTitle:
          translatedWorkoutTitle ?? this.translatedWorkoutTitle,
      position: position ?? this.position,
      isRepsBased: isRepsBased ?? this.isRepsBased,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'WorkoutForYoutube(workoutForYoutubeId: $workoutForYoutubeId, workoutId: $workoutId, workoutTitle: $workoutTitle, translatedWorkoutTitle: $translatedWorkoutTitle, position: $position, isRepsBased: $isRepsBased, reps: $reps, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutForYoutube &&
        other.workoutForYoutubeId == workoutForYoutubeId &&
        other.workoutId == workoutId &&
        other.workoutTitle == workoutTitle &&
        mapEquals(other.translatedWorkoutTitle, translatedWorkoutTitle) &&
        other.position == position &&
        other.isRepsBased == isRepsBased &&
        other.reps == reps &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return workoutForYoutubeId.hashCode ^
        workoutId.hashCode ^
        workoutTitle.hashCode ^
        translatedWorkoutTitle.hashCode ^
        position.hashCode ^
        isRepsBased.hashCode ^
        reps.hashCode ^
        duration.hashCode;
  }
}
