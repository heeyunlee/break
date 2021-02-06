import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import 'daily_summary_row_widget.dart';

class DailySummaryCard extends StatefulWidget {
  final Timestamp date;
  final String workoutTitle;
  final int weightsLifted;
  final double caloriesBurnt;
  final int totalDuration;
  final bool earnedBadges;
  final onTap;

  DailySummaryCard({
    @required this.date,
    @required this.workoutTitle,
    @required this.weightsLifted,
    @required this.caloriesBurnt,
    @required this.totalDuration,
    this.earnedBadges,
    this.onTap,
  });

  @override
  _DailySummaryCardState createState() => _DailySummaryCardState();
}

class _DailySummaryCardState extends State<DailySummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: CardColor,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final date = widget.date.toDate();
    final formattedDate = DateFormat.MMMMEEEEd().format(date);

    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 56,
              width: 56,
              color: Grey700,
              child: Center(
                child: Image.network(
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
            '${widget.workoutTitle}',
            style: Subtitle1.copyWith(fontWeight: FontWeight.w900),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(height: 8),
        Divider(indent: 8, endIndent: 8, color: Grey800),
        SizedBox(height: 16),
        DailySummaryRowWidget(
          weightsLifted: widget.weightsLifted,
          caloriesBurnt: widget.caloriesBurnt,
          totalDuration: widget.totalDuration,
        ),
        SizedBox(height: 16),
        if (widget.earnedBadges == true)
          Divider(indent: 8, endIndent: 8, color: Grey800),
        if (widget.earnedBadges == true)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
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
