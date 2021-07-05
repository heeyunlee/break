import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../progress_tab_model.dart';

class BlurredBackground extends StatelessWidget {
  final ProgressTabModel model;
  final int? imageIndex;

  const BlurredBackground({
    Key? key,
    required this.model,
    required this.imageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: model.blurTween.value,
            sigmaY: model.blurTween.value,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -0.5),
                end: Alignment(0, 1),
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(model.brightnessTween.value),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
