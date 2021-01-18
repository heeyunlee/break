import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'edit_workout_set_screen.dart';
import 'workout_set_widget.dart';

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
  int index;

  // Delete Routine Workout Method
  Future<void> _deleteRoutineWorkout(
    BuildContext context,
    Routine routine,
    RoutineWorkout routineWorkout,
  ) async {
    try {
      showFlushBar(
        context: context,
        message: '운동을 삭제했습니다!',
      );
      await widget.database.deleteRoutineWorkout(routine, routineWorkout);
    } on FirebaseException catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

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
      // TODO: _showModalBottomSheetForDelete not disappearing... need to fix it
      // Navigator.of(context).pop();
      showFlushBar(
        context: context,
        message: (set.isRest) ? '휴식이 삭제됐습니다' : '세트가 삭제됐습니다.',
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
          title: Text(widget.routineWorkout.workoutTitle, style: Headline6),
          subtitle: Row(
            children: <Widget>[
              Text('${widget.routineWorkout.numberOfSets} 세트',
                  style: Subtitle2),
              Text('  •  ', style: Subtitle2),
              Text('${widget.routineWorkout.numberOfSets} Kgs',
                  style: Subtitle2),
            ],
          ),
          childrenPadding: EdgeInsets.all(0),
          maintainState: true,
          children: [
            if (widget.routineWorkout.sets == null ||
                widget.routineWorkout.sets.isEmpty)
              Divider(endIndent: 8, indent: 8, color: Grey700),
            if (widget.routineWorkout.sets == null ||
                widget.routineWorkout.sets.isEmpty)
              Container(
                height: 80,
                child: Center(
                  child: Text('세트를 추가하세요', style: BodyText2),
                ),
              ),
            Divider(endIndent: 8, indent: 8, color: Grey700),
            if (widget.routineWorkout.sets != null)
              ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.routineWorkout.sets.length,
                itemBuilder: (context, index) {
                  return WorkoutSetWidget(
                    set: widget.routineWorkout.sets[index],
                    onPressed: () => _showModalBottomSheetForDeleteWorkoutSet(
                      context,
                      () {
                        _deleteSet(context, widget.routineWorkout.sets[index]);
                      },
                    ),
                  );
                },
              ),
            if (widget.routineWorkout.sets.isNotEmpty == true)
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
                    // child: Text(
                    //   '세트 추가하기',
                    //   style: ButtonText,
                    // ),
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      EditWorkoutSetScreen.show(
                        context,
                        routine: widget.routine,
                        routineWorkout: widget.routineWorkout,
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
        // child: Text(
        //   '운동 삭제하기',
        //   style: ButtonText,
        // ),
        onPressed: () async {
          await _showMBSDeleteRoutineWorkout();
        },
      ),
    );
  }

  Future<bool> _showModalBottomSheetForDeleteWorkoutSet(
      BuildContext context, Function firstActionOnPressed) {
    return showAdaptiveModalBottomSheet(
      context: context,
      message: Text(
        '정말로 세트를 삭제하시겠습니까?',
        textAlign: TextAlign.center,
      ),
      firstActionText: '세트 삭제',
      isFirstActionDefault: false,
      firstActionOnPressed: firstActionOnPressed,
      cancelText: '취소',
      isCancelDefault: true,
    );
  }

  Future<bool> _showMBSDeleteRoutineWorkout() {
    return showAdaptiveModalBottomSheet(
      context: context,
      message: Text(
        '정말로 루틴을 삭제하시겠습니까?',
        textAlign: TextAlign.center,
      ),
      firstActionText: '루틴 삭제',
      isFirstActionDefault: false,
      firstActionOnPressed: () {
        _deleteRoutineWorkout(
          context,
          widget.routine,
          widget.routineWorkout,
        );
      },
      cancelText: '취소',
      isCancelDefault: true,
    );
  }
}
