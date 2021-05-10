import 'workout_set.dart';

class WorkoutHistory {
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

  String workoutHistoryId;
  String routineHistoryId;
  String workoutId;
  String routineId;
  String workoutHistoryOwnerId;
  int index;
  String workoutTitle;
  int numberOfSets;
  int numberOfReps;
  num totalWeights;
  List<WorkoutSet>? sets;
  bool isBodyWeightWorkout;
  int duration;
  int secondsPerRep;
  Map<String, dynamic> translated;

  WorkoutHistory.fromJson(Map<String, dynamic> data, String documentId) {
    workoutHistoryId = documentId;
    index = data['index'];
    workoutId = data['workoutId'];
    routineId = data['routineId'];
    workoutHistoryOwnerId = data['workoutHistoryOwnerId'];
    workoutTitle = data['workoutTitle'];
    numberOfSets = data['numberOfSets'];
    numberOfReps = data['numberOfReps'];
    totalWeights = data['totalWeights'];
    if (data['sets'] != null) {
      sets = <WorkoutSet>[];
      data['sets'].forEach((set) {
        sets!.add(WorkoutSet.fromMap(set));
      });
    }
    isBodyWeightWorkout = data['isBodyWeightWorkout'];
    duration = data['duration'];
    secondsPerRep = data['secondsPerRep'];
    translated = data['translated'];
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
