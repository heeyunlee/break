import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/youtube_video_detail_screen.dart';

class YoutubeVideoCard extends StatelessWidget {
  const YoutubeVideoCard({
    Key? key,
    required this.youtubeVideo,
    required this.heroTag,
    this.height = 220,
    this.width,
  }) : super(key: key);

  final YoutubeVideo youtubeVideo;
  final String heroTag;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => YoutubeVideoDetailScreen.show(
        context,
        youtubeVideo: youtubeVideo,
        heroTag: heroTag,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height,
              width: width ?? (size.width - 32),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(vertical: 8),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Hero(
                      tag: heroTag,
                      child: CachedNetworkImage(
                        imageUrl: youtubeVideo.thumnail,
                        height: height,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0, -0.50),
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.75),
                          ],
                        ),
                      ),
                      width: double.infinity,
                      height: height,
                    ),
                    Positioned(
                      bottom: 16,
                      child: SizedBox(
                        width: (width ?? (size.width - 32)) - 32,
                        child: Text(
                          youtubeVideo.title,
                          style: TextStyles.body1,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/logos/yt_icon_rgb.png',
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  Formatter.getJoinedMainMuscleGroups(
                    null,
                    youtubeVideo.mainMuscleGroups,
                  ),
                  style: TextStyles.body2Grey,
                ),
                const Text('   •   ', style: TextStyles.body2Grey),
                Text(
                  '${youtubeVideo.duration.inMinutes} minutes',
                  style: TextStyles.body2Grey,
                ),
                const Text('   •   ', style: TextStyles.body2Grey),
                Text(
                  EnumToString.convertToString(
                    youtubeVideo.location,
                    camelCase: true,
                  ),
                  style: TextStyles.body2Grey,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: CachedNetworkImageProvider(
                      youtubeVideo.authorProfilePicture,
                    ),
                  ),
                ),
                Text(youtubeVideo.authorName, style: TextStyles.body2),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
