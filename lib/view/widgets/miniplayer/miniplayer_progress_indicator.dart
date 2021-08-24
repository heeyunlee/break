import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/youtube_video.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class MiniplayerProgressIndicator extends StatelessWidget {
  const MiniplayerProgressIndicator({
    Key? key,
    this.padding = 0,
    this.radius = 2,
    required this.model,
    required this.isExpanded,
  }) : super(key: key);

  final double? padding;
  final double? radius;
  final MiniplayerModel model;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double progress = 0;

    if (model.currentWorkout.runtimeType == Routine) {
      if (model.currentWorkoutSet != null) {
        progress = model.currentIndex / model.setsLength;
      }

      final formattedProgress = Formatter.numWithoutDecimal(progress * 100);

      assert(progress <= 1);

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding!),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius!),
                  child: Container(
                    color: Colors.grey[800],
                    height: 4,
                    width: size.width,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius!),
                  child: Container(
                    color: kPrimaryColor,
                    height: 4,
                    width: (size.width - padding! * 2) * progress,
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '$formattedProgress %',
                    style: TextStyles.body2,
                  ),
                  const Spacer(),
                  const Text('100 %', style: TextStyles.body2),
                ],
              ),
            ),
        ],
      );
    } else {
      final currentVideo = model.currentWorkout as YoutubeVideo;

      return YoutubeValueBuilder(
        controller: model.youtubeController,
        builder: (context, value) {
          progress = value.position.inSeconds / currentVideo.duration.inSeconds;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding!),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(radius!),
                      child: Container(
                        color: Colors.grey[800],
                        height: 4,
                        width: size.width,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(radius!),
                      child: Container(
                        color: kPrimaryColor,
                        height: 4,
                        width: (size.width - padding! * 2) * progress,
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        Formatter.durationInMMSS(value.position),
                        style: TextStyles.body2,
                      ),
                      const Spacer(),
                      Text(
                        Formatter.durationInMMSS(currentVideo.duration),
                        style: TextStyles.body2,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      );
    }
  }
}
