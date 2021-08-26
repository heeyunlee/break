import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:workout_player/view_models/progress_tab_model.dart';

class BlurredBackground extends StatelessWidget {
  final ProgressTabModel model;
  final MiniplayerModel miniplayerModel;
  final int? imageIndex;

  const BlurredBackground({
    Key? key,
    required this.model,
    required this.miniplayerModel,
    required this.imageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRoutineOrNull = miniplayerModel.currentWorkout == null ||
        miniplayerModel.currentWorkout.runtimeType == Routine;

    return AnimatedBuilder(
      animation: model.animationController,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              ProgressTabModel.bgURL[imageIndex ?? 0],
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
