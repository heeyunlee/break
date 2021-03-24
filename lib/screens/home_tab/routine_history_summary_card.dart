import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/progress_tab/weights_lifted/routine_history/daily_summary_card.dart';
import 'package:workout_player/screens/progress_tab/weights_lifted/routine_history/daily_summary_detail_screen.dart';

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
          _CustomListTile4(
            title: Text(routineHistory.username, style: Subtitle1Bold),
            subtitle: difference,
          ),
          _buildNotes(notes),
          DailySummaryCard(
            cardColor: CardColorLight,
            date: routineHistory.workoutEndTime,
            workoutTitle: routineHistory.routineTitle,
            totalWeights: routineHistory.totalWeights,
            caloriesBurnt: routineHistory.totalCalories,
            totalDuration: routineHistory.totalDuration,
            onTap: () => DailySummaryDetailScreen.show(
              context,
              routineHistory: routineHistory,
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
}

class _CustomListTile4 extends StatelessWidget {
  const _CustomListTile4({
    Key key,
    this.tag,
    this.imageUrl,
    this.title,
    this.leadingText,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.isLeadingDuration,
  }) : super(key: key);

  final Object tag;
  final String imageUrl;
  final Widget title;
  final String leadingText;
  final String subtitle;
  final void Function() onTap;
  final void Function() onLongTap;
  final Widget trailingIconButton;
  final bool isLeadingDuration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 36,
              width: 36,
              child: const Center(
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4),
                    title,
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Caption1Grey,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
