import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class AppBarTitleWidget extends ConsumerWidget {
  const AppBarTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(miniplayerModelProvider);
    final homeModel = watch(homeScreenModelProvider);
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2),
      child: TextButton(
        onPressed: () => model.jumpToCurrentWorkout(homeModel),
        child: Text(
          getTitle(model),
          style: TextStyles.body2_w900,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String getTitle(MiniplayerModel model) {
    if (model.currentWorkout.runtimeType == Routine) {
      final routine = model.currentWorkout as Routine;
      return routine.routineTitle;
    } else {
      final video = model.currentWorkout as YoutubeVideo;

      return video.title;
    }
  }
}
