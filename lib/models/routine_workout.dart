import 'workout_set.dart';

class RoutineWorkout {
  final String routineWorkoutId;
  final String routineId;
  final String routineWorkoutOwnerId;
  final String workoutId;
  final String workoutTitle;
  final int index;
  final int numberOfSets;
  final int numberOfReps;
  final num totalWeights;
  final List<WorkoutSet>? sets; // Nullable
  final bool isBodyWeightWorkout;
  final int duration;
  final int secondsPerRep;
  final Map<String, dynamic> translated;

  RoutineWorkout({
    required this.routineWorkoutId,
    required this.routineId,
    required this.routineWorkoutOwnerId,
    required this.workoutId,
    required this.workoutTitle,
    required this.index,
    required this.numberOfSets,
    required this.numberOfReps,
    required this.totalWeights,
    this.sets,
    required this.isBodyWeightWorkout,
    required this.duration,
    required this.secondsPerRep,
    required this.translated,
  });

  factory RoutineWorkout.fromJson(
      Map<String, dynamic> data, String documentId) {
    final int index = data['index'];
    final String routineWorkoutId = documentId;
    final String workoutId = data['workoutId'];
    final String routineId = data['routineId'];
    final String routineWorkoutOwnerId = data['routineWorkoutOwnerId'];
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

    return RoutineWorkout(
      index: index,
      routineWorkoutId: routineWorkoutId,
      workoutId: workoutId,
      routineId: routineId,
      routineWorkoutOwnerId: routineWorkoutOwnerId,
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
    data['routineWorkoutOwnerId'] = routineWorkoutOwnerId;
    data['workoutTitle'] = workoutTitle;
    data['numberOfSets'] = numberOfSets;
    data['numberOfReps'] = numberOfReps;
    data['totalWeights'] = totalWeights;
    data['sets'] = sets!.map((e) => e.toMap()).toList();
    data['isBodyWeightWorkout'] = isBodyWeightWorkout;
    data['duration'] = duration;
    data['secondsPerRep'] = secondsPerRep;
    data['translated'] = translated;

    return data;
  }
}
