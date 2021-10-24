import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class StartRoutineButton extends ConsumerWidget {
  const StartRoutineButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  final RoutineDetailScreenClass data;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(miniplayerModelProvider);
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () => model.startRoutine(context, data),
      style: ButtonStyles.elevated1(context),
      child: SizedBox(
        height: 48,
        width: (size.width - 112) / 2,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(S.current.startRoutine, style: TextStyles.button1),
            ],
          ),
        ),
      ),
    );
  }
}
