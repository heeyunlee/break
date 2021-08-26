import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

class WatchTab extends StatelessWidget {
  const WatchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[WatchTab] building...');

    final database = Provider.of<Database>(context, listen: false);

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
      body: CustomStreamBuilder<List<YoutubeVideo>>(
        stream: database.youtubeVideosStream(),
        builder: (context, videos) {
          return CustomListViewBuilder<YoutubeVideo>(
            items: videos,
            itemBuilder: (context, video, index) => YoutubeVideoCard(
              heroTag: video.youtubeVideoId,
              youtubeVideo: video,
            ),
          );
        },
      ),
    );
  }
}
