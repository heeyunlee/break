import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class StartRoutineButton extends ConsumerWidget {
  final RoutineDetailScreenClass data;

  const StartRoutineButton({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final model = watch(miniplayerModelProvider);

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
