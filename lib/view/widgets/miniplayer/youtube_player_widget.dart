import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view_models/main_model.dart';
// import 'package:workout_player/view_models/miniplayer_model.dart';
// import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class YoutubePlayerWidget extends ConsumerWidget {
  const YoutubePlayerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    logger.d('[YoutubePlayerWidget] building');

    // final model = watch(miniplayerModelProvider);
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 220,
      width: size.width,
      // child: YoutubePlayerIFrame(
      //   gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      //   controller: model.youtubeController,
      // ),
    );
  }
}
