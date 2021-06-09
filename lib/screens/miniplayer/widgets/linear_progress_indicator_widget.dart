import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';

import '../../../constants.dart';

class LinearProgressIndicatorWidget extends ConsumerWidget {
  final double width;
  final double? radius;

  const LinearProgressIndicatorWidget({
    required this.width,
    this.radius = 2,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final miniplayerIndex = watch(miniplayerIndexProvider);

    final progress =
        miniplayerIndex.currentIndex / miniplayerIndex.routineLength;

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