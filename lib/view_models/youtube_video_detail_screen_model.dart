import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

// String youtubeUrlFromId(String id, {int seconds = 0}) =>
//     'https://www.youtube.com/watch?v=$id&t=$seconds';

final youtubeVideoDetailScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<YoutubeVideoDetailScreenModel, YoutubeVideo>(
  (ref, data) => YoutubeVideoDetailScreenModel(video: data),
);

class YoutubeVideoDetailScreenModel with ChangeNotifier {
  final YoutubeVideo video;

  YoutubeVideoDetailScreenModel({
    required this.video,
  }) {
    blurHash = video.blurHash;
    thumbnail = video.thumnail;
    title = video.title;
    muscleGroups = video.mainMuscleGroups;
    duration = video.duration.inMinutes;
    location = video.location;
    profileUrl = video.authorProfilePicture;
    authorName = video.authorName;
  }

  late String blurHash;
  late String thumbnail;
  late String title;
  late List<MainMuscleGroup?> muscleGroups;
  late int duration;
  late Location location;
  late String profileUrl;
  late String authorName;

  Future<void> launchYoutube(BuildContext context, {int seconds = 0}) async {
    final url = youtubeUrlFromId(video.videoId, seconds: seconds);
    final canLaunches = await canLaunch(url);

    if (canLaunches) {
      await launch(url);
    } else {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: 'Cannot launch: $url',
      );
    }
  }

  static String youtubeUrlFromId(String id, {int seconds = 0}) =>
      'https://www.youtube.com/watch?v=$id&t=$seconds';
}
