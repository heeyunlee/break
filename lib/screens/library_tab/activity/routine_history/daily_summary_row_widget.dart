import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class DailySummaryRowWidget extends StatelessWidget {
  const DailySummaryRowWidget({
    Key key,
    @required this.formattedWeights,
    @required this.caloriesBurnt,
    @required this.totalDuration,
  }) : super(key: key);

  final String formattedWeights;
  final double caloriesBurnt;
  final int totalDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // weights lifted
        _buildRowChildren(
          emojiUrl:
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
          title: '$formattedWeights',
          subtitle: 'Lifted',
        ),

        // // calories burned
        // _buildRowChildren(
        //   emojiUrl:
        //       'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/fire_1f525.png',
        //   title: '$caloriesBurnt Kcal',
        //   subtitle: 'Burnt',
        // ),

        // minutes worked out
        _buildRowChildren(
          emojiUrl:
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
          title: '$totalDuration minutes',
          subtitle: 'Spent',
        ),
      ],
    );
  }

  Widget _buildRowChildren({String emojiUrl, String title, subtitle}) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: emojiUrl,
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 16),
        Text(title, style: Subtitle1BoldGrey),
        const SizedBox(height: 4),
        Text(subtitle, style: BodyText2Light),
      ],
    );
  }
}
