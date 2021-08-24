import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/workout_for_youtube.dart';
import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

class WatchTab extends StatelessWidget {
  const WatchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[WatchTab] building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Watch', style: TextStyles.subtitle2),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text('BETA', style: TextStyles.button2),
              ),
            ),
          ],
        ),
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            YoutubeVideoCard(
              heroTag: '1',
              youtubeVideo: YoutubeVideo(
                youtubeVideoId: 'asd',
                videoId: 'Tz9d7By2ytQ',
                thumnail: 'assets/test/maxresdefault.jpeg',
                title:
                    'NO GYM FULL BODY WORKOUT (feat. 5 min Tabata) | 5분 전신 타바타 운동',
                mainMuscleGroups: [MainMuscleGroup.fullBody],
                duration: Duration(minutes: 5, seconds: 23),
                authorName: 'Allblanc',
                authorProfilePicture: 'assets/test/maxresdefault.jpeg',
                location: Location.atHome,
                blurHash: 'L9Ih4{4T0j_39x4T?wR4.Sk9xF-T',
                videoUrl: 'https://www.youtube.com/watch?v=Tz9d7By2ytQ',
                workouts: [
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Warm Up',
                    translatedWorkoutTitle: {
                      'en': 'Warm Up',
                      'ko': '웜 업',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 3),
                    duration: Duration(seconds: 10),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Jumping Jacks',
                    translatedWorkoutTitle: {
                      'en': 'Jumping Jacks',
                      'ko': '점핑 잭',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 13),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Mountain Climbers',
                    translatedWorkoutTitle: {
                      'en': 'Mountain Climbers',
                      'ko': '마운틴 클라이밍',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 43),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Squat Side Kick',
                    translatedWorkoutTitle: {
                      'en': 'Squat Side Kick',
                      'ko': '스쿼트 사이트 킥',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 73),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Squat Jump',
                    translatedWorkoutTitle: {
                      'en': 'Squat Jump',
                      'ko': '스쿼트 점프',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 103),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Push Ups',
                    translatedWorkoutTitle: {
                      'en': 'Push Ups',
                      'ko': '푸시 업',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 133),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Plank Push Ups',
                    translatedWorkoutTitle: {
                      'en': 'Plank Push Ups',
                      'ko': '플랭크 푸시 업',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 163),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Side Leg Raise (Left)',
                    translatedWorkoutTitle: {
                      'en': 'Side Leg Raise (Left)',
                      'ko': '사이드 레그 레이즈 (왼쪽)',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 193),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Side Leg Raise (Left)',
                    translatedWorkoutTitle: {
                      'en': 'Side Leg Raise (Right)',
                      'ko': '사이드 레그 레이즈 (오른쪽)',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 223),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'T Rotation',
                    translatedWorkoutTitle: {
                      'en': 'T Rotation',
                      'ko': 'T 로테이션',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 253),
                    duration: Duration(seconds: 30),
                  ),
                  WorkoutForYoutube(
                    isRepsBased: false,
                    workoutId: 'workoutId',
                    workoutTitle: 'Hip Bridge',
                    translatedWorkoutTitle: {
                      'en': 'Hip Bridge',
                      'ko': '힙 브릿지',
                    },
                    workoutForYoutubeId: 'workoutForYoutubeId',
                    position: Duration(seconds: 283),
                    duration: Duration(seconds: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kBottomNavigationBarHeight + 24),
          ],
        ),
      ),
    );
  }

  // InkWell _buildCard(BuildContext context, Size size) {
  //   return InkWell(
  //     onTap: () => YoutubeScreen.show(context),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Card(
  //             color: Colors.transparent,
  //             margin: EdgeInsets.symmetric(vertical: 8),
  //             clipBehavior: Clip.antiAliasWithSaveLayer,
  //             child: Stack(
  //               alignment: Alignment(0, 0),
  //               children: [
  //                 Image.asset(
  //                   'assets/test/maxresdefault.jpeg',
  //                   width: double.infinity,
  //                   height: 220,
  //                   fit: BoxFit.cover,
  //                 ),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       begin: Alignment(0, -1.00),
  //                       end: Alignment(0, 1.00),
  //                       colors: [
  //                         Colors.transparent,
  //                         Colors.black87,
  //                       ],
  //                     ),
  //                   ),
  //                   width: double.infinity,
  //                   height: 220,
  //                 ),
  //                 Positioned(
  //                   bottom: 16,
  //                   child: SizedBox(
  //                     width: size.width - 64,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'NO GYM FULL BODY WORKOUT (feat. 5 min Tabata) | 5분 전신 타바타 운동',
  //                           style: TextStyles.body1,
  //                           overflow: TextOverflow.fade,
  //                           softWrap: true,
  //                           maxLines: 2,
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           'Full Body   •   5 Mins   •   At Home',
  //                           style: TextStyles.body2_grey,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Image.asset(
  //                   'assets/test/yt_icon_rgb.png',
  //                   height: 32,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8),
  //                 child: CircleAvatar(radius: 12),
  //               ),
  //               Text('AllBlac', style: TextStyles.body2),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
