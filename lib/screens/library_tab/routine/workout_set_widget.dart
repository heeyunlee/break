import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

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
      final routineWorkout = {
        'index': widget.routineWorkout.index,
        'workoutId': widget.routineWorkout.workoutId,
        'workoutTitle': widget.routineWorkout.workoutTitle,
        'numberOfSets': widget.routineWorkout.numberOfSets,
        'numberOfReps': widget.routineWorkout.numberOfReps,
        'sets': FieldValue.arrayRemove([set.toMap()]),
      };
      showFlushBar(
        context: context,
        message: (set.isRest) ? '휴식이 삭제됐습니다' : '세트가 삭제됐습니다.',
      );
      // TODO: _showModalBottomSheetForDelete not disappearing... need to fix it
      // Navigator.of(context).pop();
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
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      controller: slidableController,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_rounded,
          // onTap: () => _showModalBottomSheetForDeleteWorkoutSet(context),
          onTap: () => _deleteSet(context, widget.set),
        ),
      ],
      child: Row(
        children: [
          SizedBox(width: 16, height: 56),
          if (!widget.set.isRest)
            Text(
              widget.set.setTitle,
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
                // width: 112,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                color: Color(0xff3C3C3C),
                child: Text(
                  (!widget.routineWorkout.isBodyWeightWorkout)
                      ? '${widget.set.weights} kg'
                      : (widget.set.weights == 0)
                          ? '맨몸'
                          : '맨몸 + ${widget.set.weights} kg',
                  style: BodyText1,
                ),
              ),
            ),
          SizedBox(width: 16),
          if (!widget.set.isRest)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 32,
                width: 72,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                // color: Color(0xff3C3C3C),
                color: PrimaryColor,
                child: Text('${widget.set.reps} x', style: BodyText1),
              ),
            ),
          if (widget.set.isRest)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 32,
                width: 72,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                // color: Color(0xff3C3C3C),
                color: PrimaryColor,
                child: Text('${widget.set.restTime} 초', style: BodyText1),
              ),
            ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Future<bool> _showModalBottomSheetForDeleteWorkoutSet(BuildContext context) {
    // return Get.bottomSheet(
    //   Container(
    //     child: Wrap(
    //       children: <Widget>[
    //         SizedBox(height: 16),
    //         ListTile(
    //           title: Text('정말로 삭제하시겠습니까?'),
    //           subtitle: Text('You can\'t undo this'),
    //         ),
    //         Divider(indent: 4, endIndent: 4),
    //         ListTile(
    //           leading: Icon(Icons.delete_rounded),
    //           title: Text(
    //             'Delete',
    //             style: TextStyle(
    //               color: Colors.red,
    //             ),
    //           ),
    //           onTap: () => _deleteSet(context, widget.set),
    //         ),
    //         ListTile(
    //           title: Text(
    //             '취소',
    //             style: TextStyle(
    //               color: Colors.black,
    //             ),
    //           ),
    //           onTap: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return showAdaptiveModalBottomSheet(
      context: context,
      message: Text(
        '정말로 세트를 삭제하시겠습니까?',
        textAlign: TextAlign.center,
      ),
      firstActionText: '세트 삭제',
      isFirstActionDefault: false,
      firstActionOnPressed: () => _deleteSet(context, widget.set),
      cancelText: '취소',
      isCancelDefault: true,
    );
  }
}
