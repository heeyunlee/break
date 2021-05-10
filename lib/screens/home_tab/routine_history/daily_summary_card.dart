import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../constants.dart';

class DailySummaryCard extends StatelessWidget {
  DailySummaryCard({
    this.cardColor = CardColor,
    required this.date,
    required this.workoutTitle,
    required this.totalWeights,
    required this.caloriesBurnt,
    required this.totalDuration,
    this.earnedBadges,
    this.onTap,
    required this.unitOfMass,
  });

  final Color cardColor;
  final Timestamp date;
  final String workoutTitle;
  final num totalWeights;
  final num? caloriesBurnt;
  final int totalDuration;
  final bool? earnedBadges;
  final onTap;
  final int unitOfMass;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget _buildChild() {
    final formattedDate = Format.date(date);
    final weights = Format.weights(totalWeights);
    final unit = Format.unitOfMass(unitOfMass);
    final durationInMinutes = Format.durationInMin(totalDuration);

    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 56,
              width: 56,
              color: Grey700,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/flexed-biceps_1f4aa.png',
                  color: Colors.grey,
                  width: 36,
                  height: 36,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          title: Text(formattedDate, style: Subtitle2),
          subtitle: Text(
            '$workoutTitle',
            style: Subtitle1w900,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(indent: 8, endIndent: 8, color: Grey800),
        const SizedBox(height: 16),
        _DailySummaryRowWidget(
          formattedWeights: '$weights $unit',
          caloriesBurnt: caloriesBurnt,
          totalDuration: durationInMinutes,
        ),
        const SizedBox(height: 16),
        if (earnedBadges == true)
          const Divider(indent: 8, endIndent: 8, color: Grey800),
        if (earnedBadges == true)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Placeholder(fallbackHeight: 40, fallbackWidth: 40),
                const SizedBox(width: 24),
                const Placeholder(fallbackHeight: 40, fallbackWidth: 40),
              ],
            ),
          ),
      ],
    );
  }
}

class _DailySummaryRowWidget extends StatelessWidget {
  const _DailySummaryRowWidget({
    Key? key,
    required this.formattedWeights,
    required this.caloriesBurnt,
    required this.totalDuration,
  }) : super(key: key);

  final String formattedWeights;
  final num? caloriesBurnt;
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
          subtitle: S.current.lifted,
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
          title: '$totalDuration ${S.current.minutes}',
          subtitle: S.current.spent,
        ),
      ],
    );
  }

  Widget _buildRowChildren({
    required String emojiUrl,
    required String title,
    subtitle,
  }) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: emojiUrl,
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 16),
        Text(title, style: Subtitle1w900),
        const SizedBox(height: 4),
        Text(subtitle, style: BodyText2Light),
      ],
    );
  }
}
