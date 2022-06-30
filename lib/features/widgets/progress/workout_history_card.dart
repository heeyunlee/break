import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'workout_set_widget_for_history.dart';

class WorkoutHistoryCard extends StatelessWidget {
  final RoutineHistory routineHistory;
  final WorkoutHistory workoutHistory;

  const WorkoutHistoryCard({
    Key? key,
    required this.routineHistory,
    required this.workoutHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FORMATTING
    final numberOfSets = workoutHistory.numberOfSets;
    final formattedNumberOfSets = (numberOfSets > 1)
        ? '$numberOfSets ${S.current.sets}'
        : '$numberOfSets ${S.current.set}';

    final locale = Intl.getCurrentLocale();
    final translation = workoutHistory.translated;
    final title = (translation.isEmpty)
        ? workoutHistory.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? workoutHistory.translated[locale].toString()
            : workoutHistory.workoutTitle;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        childrenPadding: EdgeInsets.zero,
        maintainState: true,
        leading: SizedBox(
          height: 48,
          width: 24,
          child: Center(
            child: Text(
              workoutHistory.index.toString(),
              style: GoogleFonts.blackHanSans(
                color: Colors.white,
                fontSize: 24,
              ),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        title: (title.length > 24)
            ? FittedBox(
                fit: BoxFit.cover,
                child: Text(title, style: TextStyles.headline6),
              )
            : Text(
                title,
                style: TextStyles.headline6,
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
        subtitle: Row(
          children: <Widget>[
            Text(formattedNumberOfSets, style: TextStyles.subtitle2),
            const Text('   |   ', style: TextStyles.subtitle2),
            Text(
              Formatter.workoutHistoryTotalWeights(
                routineHistory,
                workoutHistory,
              ),
              style: TextStyles.subtitle2,
            ),
          ],
        ),
        children: [
          if (workoutHistory.sets == null || workoutHistory.sets!.isEmpty)
            kCustomDividerIndent8,
          if (workoutHistory.sets == null || workoutHistory.sets!.isEmpty)
            SizedBox(
              height: 80,
              child: Center(
                child: Text(S.current.addASet, style: TextStyles.body2),
              ),
            ),
          kCustomDividerIndent8,
          if (workoutHistory.sets != null)
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: workoutHistory.sets!.length,
              itemBuilder: (context, index) {
                return WorkoutSetWidgetForHistory(
                  routineHistory: routineHistory,
                  workoutHistory: workoutHistory,
                  workoutSet: workoutHistory.sets![index],
                  index: index,
                );
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
