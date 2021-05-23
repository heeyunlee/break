import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/workout_medium_card.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/shimmer/routine_workout_shimmer.dart';

import '../log_routine/log_routine_screen.dart';
import 'routine_start_button.dart';

class RoutineWorkoutsListWidget extends StatelessWidget {
  final Routine routine;
  final Database database;
  final AuthBase auth;
  final User user;

  const RoutineWorkoutsListWidget({
    Key? key,
    required this.routine,
    required this.database,
    required this.auth,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilderWidget<List<RoutineWorkout>>(
      loadingWidget: RoutineWorkoutShimmer(),
      stream: database.routineWorkoutsStream(routine),
      hasDataWidget:
          (BuildContext context, AsyncSnapshot<List<RoutineWorkout>> snapshot) {
        return Column(
          children: [
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size((size.width - 48) / 2, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: kPrimaryColor),
                  ),
                  onPressed: () => LogRoutineScreen.show(
                    context,
                    routine: routine,
                    database: database,
                    auth: auth,
                    user: user,
                  ),
                  child: Text(S.current.logRoutine, style: kButtonText),
                ),
                const SizedBox(width: 16),
                RoutineStartButton(
                  routine: routine,
                  snapshot: snapshot,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(endIndent: 8, indent: 8, color: kGrey800),
            const SizedBox(height: 8),
            ListItemBuilder<RoutineWorkout>(
              emptyContentTitle: S.current.routineWorkoutEmptyText,
              snapshot: snapshot,
              itemBuilder: (context, routineWorkout) => WorkoutMediumCard(
                database: database,
                routine: routine,
                routineWorkout: routineWorkout,
                auth: auth,
              ),
            ),
          ],
        );
      },
    );
  }
}
