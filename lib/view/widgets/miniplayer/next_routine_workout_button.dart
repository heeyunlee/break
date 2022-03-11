import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';

class NextWRoutineorkoutButton extends ConsumerWidget {
  const NextWRoutineorkoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(miniplayerModelProvider);

    return Tooltip(
      verticalOffset: -56,
      message: S.current.toPreviousWorkout,
      child: IconButton(
        disabledColor: Colors.grey[700],
        color: Colors.white,
        icon: const Icon(CupertinoIcons.forward_end_alt_fill),
        onPressed:
            model.isForwardButtonDisabled() ? null : model.nextRoutineWorkout,
      ),
    );
  }
}
