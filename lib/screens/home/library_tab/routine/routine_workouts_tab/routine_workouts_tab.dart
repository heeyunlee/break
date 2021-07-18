import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/auth_and_database.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home/library_tab/routine/add_workout/add_workouts_to_routine.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_workouts_tab/reorder_routine_workouts_button.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';

import 'routine_workout_card/routine_workout_card.dart';

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
    return CustomStreamBuilderWidget<List<RoutineWorkout>>(
        stream: database.routineWorkoutsStream(routine.routineId),
        hasDataWidget: (context, list) {
          bool isOwner = auth.currentUser!.uid == routine.routineOwnerId;
          // Widgets to show only if one's routine's owner
          final List<Widget> routineOwnerWidgets = [
            const Divider(endIndent: 8, indent: 8, color: Colors.white12),
            const SizedBox(height: 16),
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
                routineWorkouts: list,
                authAndDatabase: AuthAndDatabase(
                  database: database,
                  auth: auth,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ReorderRoutineWorkoutsButton(routine: routine, list: list),
          ];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (list.isEmpty)
                  //   EmptyContent(message: S.current.routineWorkoutEmptyText),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    // child: ImplicitlyAnimatedList<RoutineWorkout>(
                    //   shrinkWrap: true,
                    //   items: list,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   areItemsTheSame: (a, b) => false,
                    //   // areItemsTheSame: (a, b) =>
                    //   //     a.routineWorkoutId == b.routineWorkoutId,
                    //   removeDuration: Duration(milliseconds: 200),
                    //   insertDuration: Duration(milliseconds: 200),
                    //   itemBuilder: (context, animation, item, index) {
                    //     return SizeFadeTransition(
                    //       sizeFraction: 0.7,
                    //       curve: Curves.easeInOut,
                    //       animation: animation,
                    //       child: RoutineWorkoutCard(
                    //         database: database,
                    //         routine: routine,
                    //         routineWorkout: item,
                    //         auth: auth,
                    //         // key: UniqueKey(),
                    //         // model: RoutineWorkoutCardModel(),
                    //       ),
                    //     );
                    //   },
                    // ),

                    child: ListItemBuilder<RoutineWorkout?>(
                      items: list,
                      emptyContentTitle: S.current.routineWorkoutEmptyText,
                      itemBuilder: (context, routineWorkout, index) {
                        return RoutineWorkoutCard(
                          authAndDatabase: AuthAndDatabase(
                            auth: auth,
                            database: database,
                          ),
                          routine: routine,
                          routineWorkout: routineWorkout!,
                        );
                      },
                    ),
                  ),
                  if (isOwner) ...routineOwnerWidgets,
                  const SizedBox(height: 160),
                ],
              ),
            ),
          );
        });
  }
}
