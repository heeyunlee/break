import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';
import 'package:workout_player/styles/text_styles.dart';

class ExpandedMiniplayerTitle extends ConsumerWidget {
  final double? horzPadding;
  final double? vertPadding;
  final TextStyle? textStyle;

  const ExpandedMiniplayerTitle({
    this.horzPadding = 24,
    this.vertPadding = 4,
    this.textStyle = TextStyles.headline5,
  });
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerProvider = watch(miniplayerProviderNotifierProvider);
    final workoutSet = miniplayerProvider.currentWorkoutSet;

    if (workoutSet != null) {
      final setTitle = (workoutSet.isRest)
          ? S.current.rest
          : '${S.current.set} ${workoutSet.setIndex}';

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horzPadding!,
          vertical: vertPadding!,
        ),
        child: Text(setTitle, style: textStyle),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horzPadding!,
          vertical: vertPadding!,
        ),
        child: Text(S.current.noWorkoutSetTitle, style: textStyle),
      );
    }
  }
}
