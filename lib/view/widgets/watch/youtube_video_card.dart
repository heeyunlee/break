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
  }) : super(key: key);

  final YoutubeVideo youtubeVideo;
  final String heroTag;

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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 8),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment(0, 0),
                children: [
                  Hero(
                    tag: heroTag,
                    child: Image.asset(
                      youtubeVideo.thumnail,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, -0.50),
                        end: Alignment(0, 1.00),
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: 220,
                  ),
                  Positioned(
                    bottom: 16,
                    child: SizedBox(
                      width: size.width - 64,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            youtubeVideo.title,
                            style: TextStyles.body1,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                Formatter.getJoinedMainMuscleGroups(
                                  null,
                                  youtubeVideo.mainMuscleGroups,
                                ),
                                style: TextStyles.body2_grey,
                              ),
                              Text('   •   ', style: TextStyles.body2_grey),
                              Text(
                                '${youtubeVideo.duration.inMinutes} minutes',
                                style: TextStyles.body2_grey,
                              ),
                              Text('   •   ', style: TextStyles.body2_grey),
                              Text(
                                EnumToString.convertToString(
                                  youtubeVideo.location,
                                  camelCase: true,
                                ),
                                style: TextStyles.body2_grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/test/yt_icon_rgb.png',
                    height: 32,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage(
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
