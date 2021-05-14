import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/routine_workout.dart';

import '../../../../constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/routine.dart';
import '../../../home_screen.dart';

class RoutineStartButton extends StatelessWidget {
  final Routine routine;
  final List<RoutineWorkout> routineWorkouts;

  const RoutineStartButton({
    Key? key,
    required this.routine,
    required this.routineWorkouts,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () {
        context.read(selectedRoutineProvider).state = routine;
        context
            .read(miniplayerControllerProvider)
            .state
            .animateToHeight(state: PanelState.MAX);
        context.read(isWorkoutPausedProvider).setBoolean(false);
        debugPrint('routine title is ${routine.routineTitle}');
        print(routineWorkouts.length);
      },
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
