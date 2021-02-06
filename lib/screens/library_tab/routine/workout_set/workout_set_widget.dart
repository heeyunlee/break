import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

class WorkoutSetWidget extends StatefulWidget {
  const WorkoutSetWidget({
    Key key,
    this.database,
    this.routine,
    this.routineWorkout,
    this.set,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet set;

  @override
  _WorkoutSetWidgetState createState() => _WorkoutSetWidgetState();
}

class _WorkoutSetWidgetState extends State<WorkoutSetWidget> {
  //
  final SlidableController slidableController = SlidableController();

  // Delete Workout Set Method
  Future<void> _deleteSet(BuildContext context, WorkoutSet set) async {
    try {
      final numberOfSets = (set.isRest)
          ? widget.routineWorkout.numberOfSets
          : widget.routineWorkout.numberOfSets - 1;

      final numberOfReps = (set.isRest)
          ? widget.routineWorkout.numberOfReps
          : widget.routineWorkout.numberOfReps - set.reps;

      final totalWeights = (set.isRest)
          ? widget.routineWorkout.totalWeights
          : (set.weights == 0)
              ? widget.routineWorkout.totalWeights
              : widget.routineWorkout.totalWeights - (set.weights * set.reps);

      final routineWorkout = {
        'index': widget.routineWorkout.index,
        'workoutId': widget.routineWorkout.workoutId,
        'workoutTitle': widget.routineWorkout.workoutTitle,
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'sets': FieldValue.arrayRemove([set.toMap()]),
      };
      showFlushBar(
        context: context,
        message: (set.isRest) ? 'Deleted a rest' : 'Deleted a set',
      );
      await widget.database.setWorkoutSet(
        widget.routine,
        widget.routineWorkout,
        routineWorkout,
      );
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
    final title = widget.set?.setTitle ?? 'Set Name';
    final weights = (!widget.routineWorkout.isBodyWeightWorkout)
        ? '${widget.set.weights} kg'
        : (widget.set.weights == 0)
            ? 'Bodyweight'
            : 'BW + ${widget.set.weights} kg';
    final reps = '${widget.set?.reps ?? 0} x';
    final restTime = '${widget.set?.restTime ?? 0} sec';

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_rounded,
          onTap: () => _deleteSet(context, widget.set),
        ),
      ],
      child: Row(
        children: [
          SizedBox(width: 16, height: 56),
          if (!widget.set.isRest)
            Text(
              title,
              style: BodyText1.copyWith(fontWeight: FontWeight.bold),
            ),
          if (widget.set.isRest)
            Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
          Spacer(),
          if (!widget.set.isRest)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 32,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                color: Color(0xff3C3C3C),
                child: Text(weights, style: BodyText1),
              ),
            ),
          SizedBox(width: 16),
          if (!widget.set.isRest)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 32,
                width: 80,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                color: PrimaryColor,
                child: Text(reps, style: BodyText1),
              ),
            ),
          if (widget.set.isRest)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 32,
                width: 80,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                color: PrimaryColor,
                child: Text(restTime, style: BodyText1),
              ),
            ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
