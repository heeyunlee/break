import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/screens/home/progress_tab/progress_tab_model.dart';

class BlurredBackgroundPreviewWidget extends StatelessWidget {
  const BlurredBackgroundPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(ProgressTabModel.bgURL[2]),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -0.5),
              end: Alignment(0, 1),
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
