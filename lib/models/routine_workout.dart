import 'workout_set.dart';

class RoutineWorkout {
  RoutineWorkout({
    required this.index,
    required this.routineWorkoutId,
    required this.routineId,
    required this.routineWorkoutOwnerId,
    required this.workoutId,
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

  int index;
  String routineWorkoutId;
  String routineId;
  String routineWorkoutOwnerId;
  String workoutId;
  String workoutTitle;
  int numberOfSets;
  int numberOfReps;
  num totalWeights;
  List<WorkoutSet>? sets;
  bool isBodyWeightWorkout;
  int duration;
  int secondsPerRep;
  Map<String, dynamic> translated;

  // TODO: Using late here
  RoutineWorkout.fromJson(Map<String, dynamic> data, String documentId) {
    late int index = data['index'];
    late String routineWorkoutId = documentId;
    late String workoutId = data['workoutId'];
    late String routineId = data['routineId'];
    late String routineWorkoutOwnerId = data['routineWorkoutOwnerId'];
    late String workoutTitle = data['workoutTitle'];
    late int numberOfSets = data['numberOfSets'];
    late int numberOfReps = data['numberOfReps'];
    late num totalWeights = data['totalWeights'];
    if (data['sets'] != null) {
      sets = <WorkoutSet>[];
      data['sets'].forEach((set) {
        sets!.add(WorkoutSet.fromMap(set));
      });
    }
    late bool isBodyWeightWorkout = data['isBodyWeightWorkout'];
    late int duration = data['duration'];
    late int secondsPerRep = data['secondsPerRep'];
    late Map<String, dynamic> translated = data['translated'];

    // return RoutineWorkout(
    //   index: index,
    //   routineWorkoutId: routineWorkoutId,
    //   workoutId: workoutId,
    //   routineId: routineId,
    //   routineWorkoutOwnerId: routineWorkoutOwnerId,
    //   workoutTitle: workoutTitle,
    //   numberOfSets: numberOfSets,
    //   numberOfReps: numberOfReps,
    //   totalWeights: totalWeights,
    //   sets: sets,
    //   isBodyWeightWorkout: isBodyWeightWorkout,
    //   duration: duration,
    //   secondsPerRep: secondsPerRep,
    //   translated: translated,
    // );
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
