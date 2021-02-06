import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'workout_set/add_workout_set_screen.dart';
import 'workout_set/workout_set_widget.dart';

class WorkoutMediumCard extends StatefulWidget {
  WorkoutMediumCard({
    this.database,
    this.routine,
    this.routineWorkout,
  });

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;

  @override
  _WorkoutMediumCardState createState() => _WorkoutMediumCardState();
}

class _WorkoutMediumCardState extends State<WorkoutMediumCard> {
  // Delete Routine Workout Method
  Future<void> _deleteRoutineWorkout(
    BuildContext context,
    Routine routine,
    RoutineWorkout routineWorkout,
  ) async {
    try {
      await widget.database.deleteRoutineWorkout(routine, routineWorkout);
    } on FirebaseException catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat(',###,###');
    final routineWorkout = widget.routineWorkout;

    final numberOfSets = '${f.format(routineWorkout?.numberOfSets) ?? 0} set';
    final totalWeights = f.format(routineWorkout.totalWeights);
    final formattedTotalWeights =
        (routineWorkout.isBodyWeightWorkout && routineWorkout.totalWeights == 0)
            ? 'Bodyweight'
            : (routineWorkout.isBodyWeightWorkout)
                ? 'Bodyweight + $totalWeights kg'
                : '$totalWeights kg';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: CardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.white,
          unselectedWidgetColor: Colors.white,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(routineWorkout.workoutTitle, style: Headline6),
          subtitle: Row(
            children: <Widget>[
              Text(numberOfSets, style: Subtitle2),
              Text('  •  ', style: Subtitle2),
              Text(formattedTotalWeights, style: Subtitle2),
            ],
          ),
          childrenPadding: EdgeInsets.all(0),
          maintainState: true,
          children: [
            if (routineWorkout.sets == null || routineWorkout.sets.isEmpty)
              Divider(endIndent: 8, indent: 8, color: Grey700),
            if (routineWorkout.sets == null || routineWorkout.sets.isEmpty)
              Container(
                height: 80,
                child: Center(
                  child: Text('Add a set', style: BodyText2),
                ),
              ),
            Divider(endIndent: 8, indent: 8, color: Grey700),
            if (routineWorkout.sets != null)
              ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: routineWorkout.sets.length,
                itemBuilder: (context, index) {
                  return WorkoutSetWidget(
                    database: widget.database,
                    routine: widget.routine,
                    routineWorkout: routineWorkout,
                    set: routineWorkout.sets[index],
                  );
                },
              ),
            if (routineWorkout.sets.isNotEmpty == true)
              Divider(endIndent: 8, indent: 8, color: Grey700),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  child: FlatButton(
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      AddWorkoutSetScreen.show(
                        context,
                        routine: widget.routine,
                        routineWorkout: routineWorkout,
                      );
                    },
                  ),
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: Grey800,
                ),
                _buildDeleteButton(),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: 150,
      child: FlatButton(
        child: Icon(
          Icons.delete_rounded,
          color: Colors.grey,
        ),
        onPressed: () async {
          await _showModalBottomSheet();
        },
      ),
    );
  }

  Future<bool> _showModalBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          'Delete the workout? You cannot undo this process',
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text('Delete workout'),
            onPressed: () {
              _deleteRoutineWorkout(
                context,
                widget.routine,
                widget.routineWorkout,
              );
              Navigator.of(context).pop();
              showFlushBar(
                context: context,
                message: 'Deleted the workout!',
              );
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
