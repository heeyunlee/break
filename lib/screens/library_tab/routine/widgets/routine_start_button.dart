import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';

import '../../../../constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/routine.dart';

class RoutineStartButton extends StatelessWidget {
  final Routine routine;
  final AsyncSnapshot<List<RoutineWorkout>> snapshot;

  const RoutineStartButton({
    Key? key,
    required this.routine,
    required this.snapshot,
  }) : super(key: key);

  void _onPressed(BuildContext context) {
    if (snapshot.hasData) {
      final items = snapshot.data!;
      if (items.isNotEmpty) {
        context.read(selectedRoutineProvider).state = routine;
        context
            .read(miniplayerControllerProvider)
            .state
            .animateToHeight(state: PanelState.MAX);
        context.read(isWorkoutPausedProvider).setBoolean(false);
        context.read(selectedRoutineWorkoutsProvider).state = items;
        context.read(miniplayerIndexProvider).setEveryIndexToDefault();
        context.read(currentRoutineWorkoutProvider).state = items[0];
        context.read(currentWorkoutSetProvider).state = items[0].sets?[0];

        // Setting Routine Length HERE
        int routineLength = 0;
        for (int i = 0; i < items.length; i++) {
          int length = 0;

          if (items[i].sets != null) {
            length = items[i].sets!.length;
          }

          routineLength = routineLength + length;
        }
        context.read(miniplayerIndexProvider).setRoutineLength(routineLength);
      } else {
        showAlertDialog(
          context,
          title: S.current.emptyRoutineAlertTitle,
          content: S.current.addWorkoutToRoutine,
          defaultActionText: S.current.ok,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () => _onPressed(context),
      style: ElevatedButton.styleFrom(
        minimumSize: Size((size.width - 48) / 2, 48),
        primary: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(S.current.startRoutine, style: kButtonText),
    );
  }
}
