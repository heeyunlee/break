import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/combined/routine_and_routine_workouts.dart';
import 'package:workout_player/screens/home/miniplayer/miniplayer_model.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';

class StartRoutineButton extends ConsumerWidget {
  final RoutineAndRoutineWorkouts data;

  const StartRoutineButton({Key? key, required this.data}) : super(key: key);

  void _startRoutine(
    BuildContext context,
    MiniplayerModel model,
  ) {
    final items = data.routineWorkouts!;

    if (items.isNotEmpty) {
      if (items[0].sets.isNotEmpty) {
        model.setMiniplayerValues(
          routine: data.routine,
          routineWorkouts: items,
          routineWorkout: items[0],
          workoutSet: items[0].sets[0],
        );
      } else {
        model.setMiniplayerValues(
          routine: data.routine,
          routineWorkouts: items,
          routineWorkout: items[0],
          workoutSet: null,
        );
      }

      model.setIsWorkoutPaused(false);

      // Setting Routine Length
      int routineLength = 0;
      for (int i = 0; i < items.length; i++) {
        int length = 0;

        length = items[i].sets.length;

        routineLength = routineLength + length;
      }

      model.setIndexesToDefault();
      model.setSetsLength(routineLength);
      model.miniplayerController.animateToHeight(state: PanelState.MAX);
    } else {
      showAlertDialog(
        context,
        title: S.current.emptyRoutineAlertTitle,
        content: S.current.addWorkoutToRoutine,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () => _startRoutine(
        context,
        watch(miniplayerModelProvider),
      ),
      style: ButtonStyles.elevated1,
      child: SizedBox(
        height: 48,
        width: (size.width - 112) / 2,
        child: Center(
          child: Text(S.current.startRoutine, style: TextStyles.button1),
        ),
      ),
    );
  }
}
