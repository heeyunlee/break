import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/log_routine/log_routine_screen.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import '../../../../styles/constants.dart';

class LogStartRoutineButtonWidget extends StatelessWidget {
  final Database database;
  final User user;
  final Routine routine;
  final AsyncValue<List<RoutineWorkout?>> asyncValue;

  const LogStartRoutineButtonWidget({
    Key? key,
    required this.database,
    required this.user,
    required this.routine,
    required this.asyncValue,
  }) : super(key: key);

  void _startRoutine(BuildContext context) {
    asyncValue.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => _showAlertDialogs(context),
      data: (items) {
        if (items.isNotEmpty) {
          if (items[0]!.sets!.isNotEmpty) {
            context.read(miniplayerProviderNotifierProvider.notifier).initiate(
                  routine: routine,
                  routineWorkouts: items,
                  routineWorkout: items[0],
                  workoutSet: items[0]!.sets![0],
                );
          } else {
            context.read(miniplayerProviderNotifierProvider.notifier).initiate(
                  routine: routine,
                  routineWorkouts: items,
                  routineWorkout: items[0],
                  workoutSet: null,
                );
          }

          // setting isWorkoutPaused to false
          context.read(isWorkoutPausedProvider).setBoolean(false);

          // Setting Routine Length
          int routineLength = 0;
          for (int i = 0; i < items.length; i++) {
            int length = 0;

            if (items[i]!.sets != null) {
              length = items[i]!.sets!.length;
              print('set length $length');
            }

            routineLength = routineLength + length;
            print('routine length is $routineLength');
          }

          // Setting indexes
          context
              .read(miniplayerIndexProvider)
              .setEveryIndexToDefault(routineLength);

          context.read(miniplayerIndexProvider).setRoutineLength(routineLength);

          // Expanding miniplayer
          context
              .read(miniplayerControllerProvider)
              .state
              .animateToHeight(state: PanelState.MAX);
        } else {
          showAlertDialog(
            context,
            title: S.current.emptyRoutineAlertTitle,
            content: S.current.addWorkoutToRoutine,
            defaultActionText: S.current.ok,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        asyncValue.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Icon(Icons.error_rounded),
          data: (data) => OutlinedButton(
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
              user: user,
              routineWorkouts: data,
            ),
            child: Text(S.current.logRoutine, style: kButtonText),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _startRoutine(context),
          style: ElevatedButton.styleFrom(
            minimumSize: Size((size.width - 48) / 2, 48),
            primary: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(S.current.startRoutine, style: kButtonText),
        ),
      ],
    );
  }

  Future<void> _showAlertDialogs(BuildContext context) {
    return showExceptionAlertDialog(
      context,
      exception: 'Error',
      title: S.current.errorOccuredMessage,
    );
  }
}
