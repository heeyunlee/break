import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home_tab/routine_history/workout_set_for_history.dart';

import '../../../constants.dart';
import '../../../format.dart';

class RoutineWorkoutCard extends StatelessWidget {
  final RoutineWorkout routineWorkout;
  final RoutineHistory routineHistory;

  const RoutineWorkoutCard({
    Key key,
    this.routineWorkout,
    this.routineHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FORMATTING
    final numberOfSets = routineWorkout?.numberOfSets ?? 0;
    final formattedNumberOfSets = (numberOfSets > 1)
        ? '$numberOfSets ${S.current.sets}'
        : '$numberOfSets ${S.current.set}';

    final weights = Format.weights(routineWorkout.totalWeights);
    final unit = Format.unitOfMass(routineHistory.unitOfMass);

    final formattedTotalWeights =
        (routineWorkout.isBodyWeightWorkout && routineWorkout.totalWeights == 0)
            ? S.current.bodyweight
            : (routineWorkout.isBodyWeightWorkout)
                ? '${S.current.bodyweight} + $weights $unit'
                : '$weights $unit';

    final locale = Intl.getCurrentLocale();
    final translation = routineWorkout.translated;
    final title = (translation == null || translation.isEmpty)
        ? routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? routineWorkout.translated[locale]
            : routineWorkout.workoutTitle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: CardColor,
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
                routineWorkout.index.toString(),
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
                  child: Text(title, style: Headline6),
                )
              : Text(
                  title,
                  style: Headline6,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
          subtitle: Row(
            children: <Widget>[
              Text(formattedNumberOfSets, style: Subtitle2),
              const Text('   |   ', style: Subtitle2),
              Text(formattedTotalWeights, style: Subtitle2),
            ],
          ),
          childrenPadding: const EdgeInsets.all(0),
          maintainState: true,
          children: [
            if (routineWorkout.sets == null || routineWorkout.sets.isEmpty)
              const Divider(endIndent: 8, indent: 8, color: Grey700),
            if (routineWorkout.sets == null || routineWorkout.sets.isEmpty)
              Container(
                height: 80,
                child: Center(
                  child: Text(S.current.addASet, style: BodyText2),
                ),
              ),
            const Divider(endIndent: 8, indent: 8, color: Grey700),
            if (routineWorkout.sets != null)
              ListView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: routineWorkout.sets.length,
                itemBuilder: (context, index) {
                  return WorkoutSetForHistory(
                    routineHistory: routineHistory,
                    index: index,
                    routineWorkout: routineWorkout,
                    set: routineWorkout.sets[index],
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
