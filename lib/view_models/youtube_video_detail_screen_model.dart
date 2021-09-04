import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/workout_for_youtube.dart';

import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/services/database.dart';
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

  /// DELETE WORKOUT SET
  Future<void> update(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);

    // Punch Up + Side Tap
    // Standing Twist Crunch
    // Boxing Leg Curl
    // Plank Side Tap
    // Mountain Cross Climber

    try {
      const workout = WorkoutForYoutube(
        workoutForYoutubeId: 'workoutForYoutubeId',
        workoutId: 'workoutId',
        workoutTitle: 'Move G-4',
        translatedWorkoutTitle: {
          'en': 'Move G-4',
          'ko': '무브 G-4',
        },
        position: Duration(
          minutes: 18,
          seconds: 12,
        ),
        isRepsBased: false,
        duration: Duration(
          seconds: 20,
          minutes: 0,
        ),
      );

      // const workout = WorkoutForYoutube(
      //   workoutForYoutubeId: 'workoutForYoutubeId',
      //   workoutId: 'workoutId',
      //   workoutTitle: 'Rest',
      //   translatedWorkoutTitle: {
      //     'en': 'Rest',
      //     'ko': '휴식',
      //   },
      //   position: Duration(
      //     minutes: 18,
      //     seconds: 2,
      //   ),
      //   isRepsBased: false,
      //   duration: Duration(
      //     seconds: 10,
      //     minutes: 0,
      //   ),
      //   isRest: true,
      // );

      final updatedVideo = {
        'workouts': FieldValue.arrayUnion([workout.toMap()]),
      };

      await database.updatedYoutubeVideo(video, updatedVideo);
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  static String youtubeUrlFromId(String id, {int seconds = 0}) =>
      'https://www.youtube.com/watch?v=$id&t=$seconds';
}
