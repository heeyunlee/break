import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextWorkoutSetButton extends ConsumerWidget {
  final double? iconSize;

  const NextWorkoutSetButton({
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(miniplayerModelProvider);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toNextSet,
      child: IconButton(
        iconSize: iconSize!,
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: Icon(Icons.skip_next_rounded),
        onPressed: model.isNextButtonDisabled() ? null : model.nextWorkoutSet,
      ),
    );
  }
}
