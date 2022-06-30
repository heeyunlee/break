import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextWorkoutSetButton extends ConsumerWidget {
  const NextWorkoutSetButton({
    Key? key,
    this.iconSize = 48,
  }) : super(key: key);

  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(miniplayerModelProvider);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toNextSet,
      child: IconButton(
        iconSize: iconSize!,
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: const Icon(Icons.skip_next_rounded),
        onPressed: model.isNextButtonDisabled() ? null : model.nextWorkoutSet,
      ),
    );
  }
}
