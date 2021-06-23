import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/styles/constants.dart';
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

    final weights = Formatter.weights(workoutHistory.totalWeights);
    final unit = Formatter.unitOfMass(routineHistory.unitOfMass);

    final formattedTotalWeights =
        (workoutHistory.isBodyWeightWorkout && workoutHistory.totalWeights == 0)
            ? S.current.bodyweight
            : (workoutHistory.isBodyWeightWorkout)
                ? '${S.current.bodyweight} + $weights $unit'
                : '$weights $unit';

    final locale = Intl.getCurrentLocale();
    final translation = workoutHistory.translated;
    final title = (translation.isEmpty)
        ? workoutHistory.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? workoutHistory.translated[locale]
            : workoutHistory.workoutTitle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.white,
          unselectedWidgetColor: Colors.white,
        ),
        child: ExpansionTile(
          leading: Container(
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
          initiallyExpanded: false,
          title: (title.length > 24)
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: Text(title, style: kHeadline6),
                )
              : Text(
                  title,
                  style: kHeadline6,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
          subtitle: Row(
            children: <Widget>[
              Text(formattedNumberOfSets, style: kSubtitle2),
              const Text('   |   ', style: kSubtitle2),
              Text(formattedTotalWeights, style: kSubtitle2),
            ],
          ),
          childrenPadding: const EdgeInsets.all(0),
          maintainState: true,
          children: [
            if (workoutHistory.sets == null || workoutHistory.sets!.isEmpty)
              const Divider(endIndent: 8, indent: 8, color: kGrey700),
            if (workoutHistory.sets == null || workoutHistory.sets!.isEmpty)
              Container(
                height: 80,
                child: Center(
                  child: Text(S.current.addASet, style: kBodyText2),
                ),
              ),
            const Divider(endIndent: 8, indent: 8, color: kGrey700),
            if (workoutHistory.sets != null)
              ListView.builder(
                padding: const EdgeInsets.all(0),
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
      ),
    );
  }
}
