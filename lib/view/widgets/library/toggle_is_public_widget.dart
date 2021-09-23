import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view_models/log_routine_screen_model.dart';
import 'package:workout_player/styles/text_styles.dart';

class ToggleIsPublicWidget extends ConsumerWidget {
  const ToggleIsPublicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(logRoutineModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          S.current.makeItVisibleTo,
          style: TextStyles.body2Light,
        ),
        SizedBox(
          width: 72,
          child: Text(
            (model.isPublic) ? S.current.everyone : S.current.justMe,
            style: TextStyles.body2W900,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          (model.isPublic) ? Icons.public_rounded : Icons.public_off_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Switch(
          value: model.isPublic,
          activeColor: ThemeColors.primary500,
          onChanged: model.onIsPublicChanged,
        ),
      ],
    );
  }
}
