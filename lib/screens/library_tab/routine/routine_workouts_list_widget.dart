import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/workout_medium_card.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/shimmer/routine_workout_shimmer.dart';

import '../../../dummy_data.dart';

class RoutineWorkoutsListWidget extends StatelessWidget {
  final Routine routine;
  final ListCallback<RoutineWorkout> listCallback;
  final Database database;
  final AuthBase auth;

  const RoutineWorkoutsListWidget({
    Key? key,
    required this.routine,
    required this.listCallback,
    required this.database,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilderWidget<List<RoutineWorkout>>(
        // initialData: routineWorkoutsDummyData,
        loadingWidget: RoutineWorkoutShimmer(),
        stream: database.routineWorkoutsStream(routine),
        hasDataWidget: (context, snapshot) {
          // listCallback(snapshot.data);

          return ListItemBuilder<RoutineWorkout>(
            emptyContentTitle: S.current.routineWorkoutEmptyText,
            snapshot: snapshot as AsyncSnapshot<List<RoutineWorkout>>,
            itemBuilder: (context, routineWorkout) => WorkoutMediumCard(
              database: database,
              routine: routine,
              routineWorkout: routineWorkout,
              auth: auth,
            ),
          );
        });
  }
}
