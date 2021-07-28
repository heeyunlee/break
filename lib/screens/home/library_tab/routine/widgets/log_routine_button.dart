import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/combined/routine_and_routine_workouts.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/screens/home/library_tab/routine/log_routine/log_routine_screen.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class LogRoutineButton extends StatelessWidget {
  final Database database;
  final RoutineAndRoutineWorkouts data;
  final User user;

  const LogRoutineButton({
    Key? key,
    required this.database,
    required this.data,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return OutlinedButton(
      style: ButtonStyles.outlined1,
      onPressed: () => LogRoutineScreen.show(
        context,
        routine: data.routine!,
        database: database,
        uid: user.userId,
        user: user,
        routineWorkouts: data.routineWorkouts!,
      ),
      child: SizedBox(
        height: 48,
        width: (size.width - 112) / 2,
        child: Center(
          child: Text(S.current.logRoutine, style: TextStyles.button1),
        ),
      ),
    );
  }
}
