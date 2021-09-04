import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class RoutineHistorySummaryCard extends StatelessWidget {
  const RoutineHistorySummaryCard({
    Key? key,
    required this.onTap,
    required this.routineHistory,
  }) : super(key: key);

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
          leading: _buildLeadingWidget(),
          title: Text(
            Formatter.date(routineHistory.workoutStartTime),
            style: TextStyles.subtitle2,
          ),
          subtitle: Text(
            routineHistory.routineTitle,
            style: TextStyles.subtitle1W900,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(indent: 8, endIndent: 8, color: kGrey800),
        const SizedBox(height: 16),
        _DailySummaryRowWidget(
          routineHistory: routineHistory,
          // formattedWeights: Formatter.routineHistoryWeights(routineHistory),
          // caloriesBurnt: routineHistory.totalCalories,
          // totalDuration: Formatter.durationInMin(routineHistory.totalDuration),
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

  Widget _buildLeadingWidget() {
    if (routineHistory.youtubeWorkouts != null) {
      return SizedBox(
        height: 48,
        width: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            routineHistory.imageUrl,
            width: 72,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return ClipRRect(
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
      );
    }
  }
}

class _DailySummaryRowWidget extends StatelessWidget {
  const _DailySummaryRowWidget({
    Key? key,
    // required this.formattedWeights,
    // required this.caloriesBurnt,
    // required this.totalDuration,
    required this.routineHistory,
  }) : super(key: key);

  // final String formattedWeights;
  // final num? caloriesBurnt;
  // final String totalDuration;
  final RoutineHistory routineHistory;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (routineHistory.routineHistoryType == null ||
            routineHistory.routineHistoryType == 'routine')
          _buildRowChildren(
            emojiUrl:
                'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
            // title: formattedWeights,
            title: Formatter.routineHistoryWeights(routineHistory),
            subtitle: S.current.lifted,
          ),
        if (routineHistory.routineHistoryType == 'youtube')
          _buildRowChildren(
            emojiUrl:
                'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/fire_1f525.png',
            title: Formatter.formattedKcal(routineHistory.totalCalories),
            subtitle: S.current.burnt,
          ),
        _buildRowChildren(
          emojiUrl:
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
          // title: totalDuration,
          title: Formatter.durationInMin(routineHistory.totalDuration),
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
        Text(title, style: TextStyles.subtitle1W900),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyles.body2Light),
      ],
    );
  }
}
