import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/features/screens/log_routine_screen.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class LogRoutineButton extends StatelessWidget {
  final RoutineDetailScreenClass data;

  const LogRoutineButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return OutlinedButton(
      style: ButtonStyles.outlined1(context),
      onPressed: () => LogRoutineScreen.show(
        context,
        data: data,
      ),
      child: SizedBox(
        height: 48,
        width: (size.width - 112) / 2,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.create_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(S.current.logRoutine, style: TextStyles.button1),
            ],
          ),
        ),
      ),
    );
  }
}
