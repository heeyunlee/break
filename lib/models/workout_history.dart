import 'workout_set.dart';

class WorkoutHistory {
  final String workoutHistoryId;
  final String routineHistoryId;
  final String workoutId;
  final String routineId;
  final String workoutHistoryOwnerId;
  final int index;
  final String workoutTitle;
  final int numberOfSets;
  final int numberOfReps;
  final num totalWeights;
  final List<WorkoutSet>? sets; // Nullable
  final bool isBodyWeightWorkout;
  final int duration;
  final int secondsPerRep;
  final Map<String, dynamic> translated;

  WorkoutHistory({
    required this.workoutHistoryId,
    required this.routineHistoryId,
    required this.workoutId,
    required this.routineId,
    required this.workoutHistoryOwnerId,
    required this.index,
    required this.workoutTitle,
    required this.numberOfSets,
    required this.numberOfReps,
    required this.totalWeights,
    this.sets,
    required this.isBodyWeightWorkout,
    required this.duration,
    required this.secondsPerRep,
    required this.translated,
  });

  factory WorkoutHistory.fromJson(
      Map<String, dynamic> data, String documentId) {
    final String workoutHistoryId = documentId;
    final String routineHistoryId = data['routineHistoryId'];
    final String workoutId = data['workoutId'];
    final String routineId = data['routineId'];
    final String workoutHistoryOwnerId = data['workoutHistoryOwnerId'];
    final int index = data['index'];
    final String workoutTitle = data['workoutTitle'];
    final int numberOfSets = data['numberOfSets'];
    final int numberOfReps = data['numberOfReps'];
    final num totalWeights = data['totalWeights'];
    List<WorkoutSet>? sets = <WorkoutSet>[];
    if (data['sets'] != null) {
      data['sets'].forEach((item) {
        sets.add(WorkoutSet.fromMap(item));
      });
    }
    final bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
    final int duration = data['duration'];
    final int secondsPerRep = data['secondsPerRep'];
    final Map<String, dynamic> translated = data['translated'];

    return WorkoutHistory(
      workoutHistoryId: workoutHistoryId,
      routineHistoryId: routineHistoryId,
      workoutId: workoutId,
      routineId: routineId,
      workoutHistoryOwnerId: workoutHistoryOwnerId,
      index: index,
      workoutTitle: workoutTitle,
      numberOfSets: numberOfSets,
      numberOfReps: numberOfReps,
      totalWeights: totalWeights,
      sets: sets,
      isBodyWeightWorkout: isBodyWeightWorkout,
      duration: duration,
      secondsPerRep: secondsPerRep,
      translated: translated,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['index'] = index;
    data['workoutId'] = workoutId;
    data['routineId'] = routineId;
    data['workoutHistoryOwnerId'] = workoutHistoryOwnerId;
    data['workoutTitle'] = workoutTitle;
    data['numberOfSets'] = numberOfSets;
    data['numberOfReps'] = numberOfReps;
    data['totalWeights'] = totalWeights;
    if (sets != null) {
      data['sets'] = sets!.map((e) => e.toMap()).toList();
    }
    data['isBodyWeightWorkout'] = isBodyWeightWorkout;
    data['duration'] = duration;
    data['secondsPerRep'] = secondsPerRep;
    data['translated'] = translated;

    return data;
  }
}
