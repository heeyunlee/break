import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/format.dart';

import '../../../../constants.dart';
import 'daily_summary_row_widget.dart';

class DailySummaryCard extends StatefulWidget {
  DailySummaryCard({
    @required this.date,
    @required this.workoutTitle,
    @required this.totalWeights,
    @required this.caloriesBurnt,
    @required this.totalDuration,
    this.earnedBadges,
    this.onTap,
    this.unitOfMass,
  });

  final Timestamp date;
  final String workoutTitle;
  final double totalWeights;
  final double caloriesBurnt;
  final int totalDuration;
  final bool earnedBadges;
  final onTap;
  final int unitOfMass;

  @override
  _DailySummaryCardState createState() => _DailySummaryCardState();
}

class _DailySummaryCardState extends State<DailySummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: CardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget _buildChild() {
    final date = Format.date(widget.date);
    final weights = Format.weights(widget.totalWeights);
    final unit = Format.unitOfMass(widget.unitOfMass);
    final durationInMinutes = Format.durationInMin(widget.totalDuration);

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
            '${widget.workoutTitle}',
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
          caloriesBurnt: widget.caloriesBurnt,
          totalDuration: durationInMinutes,
        ),
        const SizedBox(height: 16),
        if (widget.earnedBadges == true)
          const Divider(indent: 8, endIndent: 8, color: Grey800),
        if (widget.earnedBadges == true)
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
