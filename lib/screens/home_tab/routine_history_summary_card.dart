import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine_history.dart';

import 'routine_history/daily_summary_card.dart';
import 'routine_history/routine_history_detail_screen.dart';

class RoutineHistorySummaryFeedCard extends StatelessWidget {
  RoutineHistorySummaryFeedCard({
    @required this.routineHistory,
    this.onTap,
  });

  final RoutineHistory routineHistory;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final workedOutTime = routineHistory.workoutEndTime.toDate();
    final timeAgo = timeago.format(
      workedOutTime,
      locale: Intl.getCurrentLocale(),
    );

    final notes = routineHistory.notes;

    final mainMuscleGroup = MainMuscleGroup.values
        .firstWhere((e) => e.toString() == routineHistory.mainMuscleGroup[0])
        .broadGroup;

    return Container(
      color: CardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomListTile4(
            username: routineHistory.username,
            muscleGroup: S.current.workedOutMainMuscleGroup(mainMuscleGroup),
            subtitle: timeAgo,
          ),
          _buildNotes(notes),
          DailySummaryCard(
            cardColor: CardColorLight,
            date: routineHistory.workoutEndTime,
            workoutTitle: routineHistory.routineTitle,
            totalWeights: routineHistory.totalWeights,
            caloriesBurnt: routineHistory.totalCalories,
            totalDuration: routineHistory.totalDuration,
            onTap: () => RoutineHistoryDetailScreen.show(
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
    this.username,
    this.muscleGroup,
    this.leadingText,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.isLeadingDuration,
  }) : super(key: key);

  final Object tag;
  final String imageUrl;
  final String username;
  final String muscleGroup;
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
                    RichText(
                      text: TextSpan(
                        text: username,
                        style: Subtitle1Bold,
                        children: <TextSpan>[
                          TextSpan(text: muscleGroup, style: BodyText2Light)
                        ],
                      ),
                    ),
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
