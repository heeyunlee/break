import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/watch/youtube_workout_list_tile.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

String youtubeUrlFromId(String id, {int seconds = 0}) =>
    'https://www.youtube.com/watch?v=$id&t=$seconds';

class YoutubeVideoDetailScreen extends StatelessWidget {
  const YoutubeVideoDetailScreen({
    Key? key,
    required this.youtubeVideo,
    required this.heroTag,
  }) : super(key: key);

  final YoutubeVideo youtubeVideo;
  final String heroTag;

  static void show(
    BuildContext context, {
    required YoutubeVideo youtubeVideo,
    required String heroTag,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => YoutubeVideoDetailScreen(
        youtubeVideo: youtubeVideo,
        heroTag: heroTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: kAppBarColor,
            floating: false,
            pinned: true,
            snap: false,
            stretch: true,
            brightness: Brightness.dark,
            expandedHeight: size.height / 2,
            actions: [
              TextButton(
                onPressed: () => launch(youtubeUrlFromId(youtubeVideo.videoId)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      'Open YouTube',
                      style: TextStyles.button2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  SizedBox(
                    height: size.width / 2,
                    width: size.width,
                    child: BlurHash(
                      hash: youtubeVideo.blurHash,
                      imageFit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0, 0.85),
                        colors: [
                          Colors.transparent,
                          kBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-1, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: heroTag,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                youtubeVideo.thumnail,
                                height: 150,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            youtubeVideo.title,
                            style: TextStyles.subtitle1,
                            maxLines: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: MaxWidthRaisedButton(
                              icon: const Icon(Icons.play_arrow_rounded),
                              onPressed: () => context
                                  .read(miniplayerModelProvider)
                                  .startYouTubeWorkout(youtubeVideo),
                              buttonText: S.current.startNow,
                              color: kPrimaryColor,
                              width: size.width - 32,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                Formatter.getJoinedMainMuscleGroups(
                                  null,
                                  youtubeVideo.mainMuscleGroups,
                                ),
                                style: TextStyles.body2_grey,
                              ),
                              const Text(
                                '   •   ',
                                style: TextStyles.body2_grey,
                              ),
                              Text(
                                '${youtubeVideo.duration.inMinutes} ${S.current.minutes}',
                                style: TextStyles.body2_grey,
                              ),
                              const Text(
                                '   •   ',
                                style: TextStyles.body2_grey,
                              ),
                              Text(
                                EnumToString.convertToString(
                                  youtubeVideo.location,
                                  camelCase: true,
                                ),
                                style: TextStyles.body2_grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                  youtubeVideo.authorProfilePicture,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                youtubeVideo.authorName,
                                style: TextStyles.body2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        'In This Workout',
                        style: TextStyles.headline6,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: youtubeVideo.workouts.length,
                      itemBuilder: (context, index) {
                        return YoutubeWorkoutListTile(
                          workout: youtubeVideo.workouts[index],
                        );
                      },
                    ),
                    SizedBox(height: kBottomNavigationBarHeight + 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
