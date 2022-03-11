import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CloseMiniplayerButton extends ConsumerWidget {
  const CloseMiniplayerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () => ref.read(miniplayerModelProvider).endWorkout(context),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          S.current.endMiniplayerButtonText,
          style: TextStyles.button1,
        ),
      ),
    );
  }
}
