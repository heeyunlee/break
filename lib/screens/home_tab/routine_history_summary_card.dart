import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/library_tab/activity/routine_history/daily_summary_row_widget.dart';

class RoutineHistorySummaryFeedCard extends StatelessWidget {
  RoutineHistorySummaryFeedCard({
    @required this.routineHistory,
    this.onTap,
  });

  final RoutineHistory routineHistory;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final workedOutTime = routineHistory.workoutEndTime.toDate();
    final difference = Format.timeDifference(workedOutTime);

    final notes = routineHistory.notes;

    return Container(
      color: CardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 36,
            ),
            title: RichText(
              text: TextSpan(
                text: routineHistory.username,
                style: Subtitle1w900,
                children: <TextSpan>[
                  TextSpan(
                    text: ' worked out',
                    style: Subtitle1Light,
                  ),
                ],
              ),
            ),
            subtitle: Text(
              difference,
              style: Caption1Grey,
            ),
            // trailing: IconButton(
            //   icon: Icon(Icons.more_vert, color: Colors.white),
            //   onPressed: () {},
            // ),
          ),
          _buildNotes(notes),
          Card(
            color: CardColorLight,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: _buildChild(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(String notes) {
    if (notes != null) {
      if (notes.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            notes,
            style: BodyText1,
          ),
        );
      }
      return Container();
    }
    return Container();
  }

  Widget _buildChild() {
    final date = Format.date(routineHistory.workoutEndTime);
    final weights = Format.weights(routineHistory.totalWeights);
    final unit = Format.unitOfMass(routineHistory.unitOfMass);
    final durationInMinutes =
        Format.durationInMin(routineHistory.totalDuration);

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
          title: Text(date, style: Subtitle2),
          subtitle: Text(
            '${routineHistory.routineTitle}',
            style: Subtitle1w900,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(indent: 8, endIndent: 8, color: Grey800),
        const SizedBox(height: 16),
        DailySummaryRowWidget(
          formattedWeights: '$weights $unit',
          caloriesBurnt: routineHistory.totalCalories,
          totalDuration: durationInMinutes,
        ),
        const SizedBox(height: 16),
        if (routineHistory.earnedBadges == true)
          const Divider(indent: 8, endIndent: 8, color: Grey800),
        if (routineHistory.earnedBadges == true)
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
