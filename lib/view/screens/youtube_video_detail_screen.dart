import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/watch/youtube_workout_list_tile.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:workout_player/view_models/youtube_video_detail_screen_model.dart';

// String youtubeUrlFromId(String id, {int seconds = 0}) =>
//     'https://www.youtube.com/watch?v=$id&t=$seconds';

class YoutubeVideoDetailScreen extends StatelessWidget {
  const YoutubeVideoDetailScreen({
    Key? key,
    // required this.youtubeVideo,
    required this.model,
    required this.heroTag,
  }) : super(key: key);

  // final YoutubeVideo? youtubeVideo;
  final YoutubeVideoDetailScreenModel model;
  final String heroTag;

  static void show(
    BuildContext context, {
    required YoutubeVideo youtubeVideo,
    required String heroTag,
    // required YoutubeVideoDetailScreenModel model,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => Consumer(
        builder: (context, watch, child) => YoutubeVideoDetailScreen(
          // youtubeVideo: youtubeVideo,
          heroTag: heroTag,
          model: watch(youtubeVideoDetailScreenModelProvider(youtubeVideo)),
        ),
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
            // floating: false,
            pinned: true,
            // snap: false,
            stretch: true,
            brightness: Brightness.dark,
            leading: const AppBarBackButton(),
            expandedHeight: size.height / 2,
            actions: [
              TextButton(
                onPressed: () => model.launchYoutube(context),
                // onPressed: () => launch(youtubeUrlFromId(youtubeVideo.videoId)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
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
                      hash: model.blurHash,
                      // hash: youtubeVideo.blurHash,
                      imageFit: BoxFit.cover,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment(0, 0.85),
                        colors: [
                          Colors.transparent,
                          kBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
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
                              child: CachedNetworkImage(
                                height: 150,
                                fit: BoxFit.fitWidth,
                                // imageUrl: youtubeVideo.thumnail,
                                imageUrl: model.thumbnail,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            // youtubeVideo.title,
                            model.title,
                            style: TextStyles.subtitle1,
                            maxLines: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: MaxWidthRaisedButton(
                              icon: const Icon(Icons.play_arrow_rounded),
                              onPressed: () => context
                                  .read(miniplayerModelProvider)
                                  .startYouTubeWorkout(model.video),
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
                                  // youtubeVideo?.mainMuscleGroups,
                                  model.muscleGroups,
                                ),
                                style: TextStyles.body2Grey,
                              ),
                              const Text(
                                '   •   ',
                                style: TextStyles.body2Grey,
                              ),
                              Text(
                                '${model.duration} ${S.current.minutes}',
                                // '${youtubeVideo?.duration.inMinutes} ${S.current.minutes}',
                                style: TextStyles.body2Grey,
                              ),
                              const Text(
                                '   •   ',
                                style: TextStyles.body2Grey,
                              ),
                              Text(
                                EnumToString.convertToString(
                                  // youtubeVideo?.location,
                                  model.location,
                                  camelCase: true,
                                ),
                                style: TextStyles.body2Grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: CachedNetworkImageProvider(
                                  // youtubeVideo?.authorProfilePicture,
                                  model.profileUrl,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                // youtubeVideo?.authorName ?? '',
                                model.authorName,
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
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      // TODO: translate here
                      child: Text(
                        'In This Workout',
                        style: TextStyles.headline6,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: model.video.workouts.length,
                      // itemCount: youtubeVideo.workouts.length,
                      itemBuilder: (context, index) {
                        return YoutubeWorkoutListTile(
                          workout: model.video.workouts[index],
                          // workout: youtubeVideo.workouts[index],
                        );
                      },
                    ),
                    const SizedBox(height: kBottomNavigationBarHeight + 32),
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
