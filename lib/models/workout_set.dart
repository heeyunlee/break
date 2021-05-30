class WorkoutSet {
  final String workoutSetId;
  final bool isRest;
  final int index;
  final String setTitle;
  final num? weights; // Nullable
  final int? reps; // Nullable
  final int? restTime; // Nullable
  final int? setIndex; // Nullable
  final int? restIndex; // Nullable

  const WorkoutSet({
    required this.workoutSetId,
    required this.isRest,
    required this.index,
    required this.setTitle,
    this.weights,
    this.reps,
    this.restTime,
    this.setIndex,
    this.restIndex,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic>? data) {
    if (data != null) {
      final String workoutSetId = data['workoutSetId'];
      final bool isRest = data['isRest'];
      final int index = data['index'];
      final String setTitle = data['setTitle'];
      final num? weights = data['weights'];
      final int? reps = data['reps'];
      final int? restTime = data['restTime'];
      final int? setIndex = data['setIndex'];
      final int? restIndex = data['restIndex'];

      return WorkoutSet(
        workoutSetId: workoutSetId,
        isRest: isRest,
        index: index,
        setTitle: setTitle,
        weights: weights,
        reps: reps,
        restTime: restTime,
        setIndex: setIndex,
        restIndex: restIndex,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutSetId': workoutSetId,
      'isRest': isRest,
      'index': index,
      'setTitle': setTitle,
      'weights': weights,
      'reps': reps,
      'restTime': restTime,
      'setIndex': setIndex,
      'restIndex': restIndex,
    };
  }
}
