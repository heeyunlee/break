import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view_models/progress_tab_model.dart';
import 'package:workout_player/widgets/widgets.dart';

class BlurredBackground extends ConsumerWidget {
  const BlurredBackground({
    Key? key,
    required this.imageIndex,
  }) : super(key: key);

  final int? imageIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(progressTabModelProvider);
    final miniplayerModel = ref.watch(miniplayerModelProvider);

    final bool isRoutineOrNull = miniplayerModel.currentWorkout == null ||
        miniplayerModel.currentWorkout.runtimeType == Routine;

    return AnimatedBuilder(
      animation: model.animationController,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AdaptiveCachedNetworkImage.provider(
              context,
              imageUrl: ProgressTabModel.bgURL[imageIndex ?? 0],
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: isRoutineOrNull ? model.blurTween.value : 0,
              sigmaY: isRoutineOrNull ? model.blurTween.value : 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0, -0.5),
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(model.brightnessTween.value),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
