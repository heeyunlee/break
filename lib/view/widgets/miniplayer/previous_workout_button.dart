import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class PreviousWorkoutButton extends ConsumerWidget {
  const PreviousWorkoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(miniplayerModelProvider);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousWorkout,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: const Icon(CupertinoIcons.backward_end_alt_fill),
        onPressed: model.isBackwardButtonDisabled()
            ? null
            : model.previousRoutineWorkout,
      ),
    );
  }
}
