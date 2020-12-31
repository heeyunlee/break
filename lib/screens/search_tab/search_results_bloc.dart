// import 'package:flutter/foundation.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:workout_player/models/routine.dart';
// import 'package:workout_player/models/workout.dart';
// import 'package:workout_player/models/workout_and_routine.dart';
// import 'package:workout_player/services/database.dart';
//
// class SearchResultsBloc {
//   SearchResultsBloc({@required this.database});
//   final Database database;
//
//   /// combine List<Workout>, List<Routine> into List<WorkoutAndRoutine>
//   Stream<List<WorkoutAndRoutine>> get _allWorkoutsAndRoutinesStream =>
//       Rx.combineLatest2(
//         database.routinesStream(),
//         database.workoutsStream(),
//         _workoutsRoutinesCombiner,
//       );
//
//   static List<WorkoutAndRoutine> _workoutsRoutinesCombiner(
//       List<Workout> workouts, List<Routine> routines) {
//     return d;
//   }
// }
