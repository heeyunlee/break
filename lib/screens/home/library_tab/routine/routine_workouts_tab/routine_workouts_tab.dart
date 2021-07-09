import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home/library_tab/routine/add_workout/add_workouts_to_routine.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_workouts_tab/reorder_routine_workouts_button.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';

import 'routine_workout_card.dart';

class RoutineWorkoutsTab extends StatelessWidget {
  final Routine routine;
  final AuthBase auth;
  final Database database;

  const RoutineWorkoutsTab({
    Key? key,
    required this.routine,
    required this.auth,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('build routine workouts tab');

    return CustomStreamBuilderWidget<List<RoutineWorkout?>>(
        stream: database.routineWorkoutsStream(routine.routineId),
        hasDataWidget: (context, list) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListItemBuilder<RoutineWorkout?>(
                      items: list,
                      emptyContentTitle: S.current.routineWorkoutEmptyText,
                      itemBuilder: (context, routineWorkout) =>
                          RoutineWorkoutCard(
                        database: database,
                        routine: routine,
                        routineWorkout: routineWorkout!,
                        auth: auth,
                      ),
                    ),
                  ),
                  if (auth.currentUser!.uid == routine.routineOwnerId)
                    const Divider(
                      endIndent: 8,
                      indent: 8,
                      color: Colors.white12,
                    ),
                  const SizedBox(height: 16),
                  if (auth.currentUser!.uid == routine.routineOwnerId)
                    MaxWidthRaisedButton(
                      icon: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),
                      buttonText: S.current.addWorkoutkButtonText,
                      color: kCardColor,
                      onPressed: () => AddWorkoutsToRoutine.show(
                        context,
                        routine: routine,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (auth.currentUser!.uid == routine.routineOwnerId)
                    ReorderRoutineWorkoutsButton(routine: routine, list: list),
                  const SizedBox(height: 160),
                ],
              ),
            ),
          );
        });
  }
}
