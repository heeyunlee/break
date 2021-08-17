import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view_models/log_routine_screen_model.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class LogRoutineButton extends StatelessWidget {
  final Database database;
  final RoutineDetailScreenClass data;
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
      onPressed: () => LogRoutineModel.show(
        context,
        database: database,
        data: data,
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