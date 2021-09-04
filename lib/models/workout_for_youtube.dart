import 'package:flutter/foundation.dart';

import 'package:workout_player/utils/formatter.dart';

class WorkoutForYoutube {
  const WorkoutForYoutube({
    required this.workoutForYoutubeId,
    required this.workoutId,
    required this.workoutTitle,
    required this.translatedWorkoutTitle,
    required this.position,
    required this.isRepsBased,
    this.reps,
    this.duration,
    this.isRest,
  });

  final String workoutForYoutubeId;
  final String workoutId;
  final String workoutTitle;
  final Map<String, dynamic> translatedWorkoutTitle;
  final Duration position;
  final bool isRepsBased;
  final int? reps;
  final Duration? duration;
  final bool? isRest;

  Map<String, dynamic> toMap() {
    return {
      'workoutForYoutubeId': workoutForYoutubeId,
      'workoutId': workoutId,
      'workoutTitle': workoutTitle,
      'translatedWorkoutTitle': translatedWorkoutTitle,
      'position': position.toString(),
      'isRepsBased': isRepsBased,
      'reps': reps,
      'duration': duration.toString(),
      'isRest': isRest,
    };
  }

  factory WorkoutForYoutube.fromMap(Map<String, dynamic> map) {
    final String id = map['workoutForYoutubeId'].toString();
    final String workoutId = map['workoutId'].toString();
    final String workoutTitle = map['workoutTitle'].toString();
    final Map<String, dynamic> translatedWorkoutTitle =
        map['translatedWorkoutTitle'] as Map<String, dynamic>;
    final Duration position =
        Formatter.stringToDuration(map['position']?.toString() ?? '');
    final bool isRepsBased = map['isRepsBased'] as bool;
    final int? reps = int.tryParse(map['reps']?.toString() ?? '');
    final Duration? duration = (map['duration'] != null)
        ? Formatter.stringToDuration(map['duration'].toString())
        : null;
    final bool? isRest = map['isRest'] as bool?;

    return WorkoutForYoutube(
      workoutForYoutubeId: id,
      workoutId: workoutId,
      workoutTitle: workoutTitle,
      translatedWorkoutTitle: translatedWorkoutTitle,
      position: position,
      isRepsBased: isRepsBased,
      reps: reps,
      duration: duration,
      isRest: isRest,
    );
  }

  WorkoutForYoutube copyWith({
    String? workoutForYoutubeId,
    String? workoutId,
    String? workoutTitle,
    Map<String, dynamic>? translatedWorkoutTitle,
    Duration? position,
    bool? isRepsBased,
    int? reps,
    Duration? duration,
    bool? isRest,
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
      isRest: isRest ?? this.isRest,
    );
  }

  @override
  String toString() {
    return 'WorkoutForYoutube(workoutForYoutubeId: $workoutForYoutubeId, workoutId: $workoutId, workoutTitle: $workoutTitle, translatedWorkoutTitle: $translatedWorkoutTitle, position: $position, isRepsBased: $isRepsBased, reps: $reps, duration: $duration, isRest: $isRest)';
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
        other.duration == duration &&
        other.isRest == isRest;
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
        duration.hashCode ^
        isRest.hashCode;
  }
}
