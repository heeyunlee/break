import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';

class RoutineHistorySummaryCard extends StatelessWidget {
  const RoutineHistorySummaryCard({
    required this.onTap,
    required this.routineHistory,
  });

  final void Function() onTap;
  final RoutineHistory routineHistory;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 56,
              width: 56,
              color: kGrey700,
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
          title: Text(
            Formatter.date(routineHistory.workoutStartTime),
            style: TextStyles.subtitle2,
          ),
          subtitle: Text(
            routineHistory.routineTitle,
            style: TextStyles.subtitle1_w900,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(indent: 8, endIndent: 8, color: kGrey800),
        const SizedBox(height: 16),
        _DailySummaryRowWidget(
          formattedWeights: Formatter.routineHistoryWeights(routineHistory),
          caloriesBurnt: routineHistory.totalCalories,
          totalDuration: Formatter.durationInMin(routineHistory.totalDuration),
        ),
        const SizedBox(height: 16),
        if (routineHistory.earnedBadges == true)
          const Divider(indent: 8, endIndent: 8, color: kGrey800),
        if (routineHistory.earnedBadges == true)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Placeholder(fallbackHeight: 40, fallbackWidth: 40),
                SizedBox(width: 24),
                Placeholder(fallbackHeight: 40, fallbackWidth: 40),
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
  final String totalDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRowChildren(
          emojiUrl:
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
          title: formattedWeights,
          subtitle: S.current.lifted,
        ),

        // _buildRowChildren(
        //   emojiUrl:
        //       'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/fire_1f525.png',
        //   title: '$caloriesBurnt Kcal',
        //   subtitle: 'Burnt',
        // ),

        _buildRowChildren(
          emojiUrl:
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
          title: totalDuration,
          subtitle: S.current.spent,
        ),
      ],
    );
  }

  Widget _buildRowChildren({
    required String emojiUrl,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: emojiUrl,
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 16),
        Text(title, style: TextStyles.subtitle1_w900),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyles.body2_light),
      ],
    );
  }
}
