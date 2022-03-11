import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';

class PreviousWorkoutSetButton extends ConsumerWidget {
  const PreviousWorkoutSetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(miniplayerModelProvider);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousSet,
      child: IconButton(
        iconSize: 48,
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: const Icon(Icons.skip_previous_rounded),
        onPressed:
            model.isPreviousButtonDisabled() ? null : model.previousWorkoutSet,
      ),
    );
  }
}
