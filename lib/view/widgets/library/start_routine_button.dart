import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class StartRoutineButton extends StatelessWidget {
  const StartRoutineButton({
    Key? key,
    required this.data,
    required this.model,
  }) : super(key: key);

  final RoutineDetailScreenClass data;
  final MiniplayerModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () => model.startRoutine(context, data),
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
