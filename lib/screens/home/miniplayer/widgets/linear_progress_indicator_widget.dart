import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';

import '../miniplayer_model.dart';

class LinearProgressIndicatorWidget extends StatelessWidget {
  final double width;
  final double? radius;
  final MiniplayerModel model;

  const LinearProgressIndicatorWidget({
    required this.width,
    this.radius = 2,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final progress = model.currentIndex / model.setsLength;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: Container(
            color: Colors.grey[800],
            height: 4,
            width: width,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: Container(
            color: kPrimaryColor,
            height: 4,
            width: (width) * progress,
          ),
        ),
      ],
    );
  }
}
