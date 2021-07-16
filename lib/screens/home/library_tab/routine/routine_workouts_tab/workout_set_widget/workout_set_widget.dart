import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class WorkoutSetWidget extends StatefulWidget {
  const WorkoutSetWidget({
    Key? key,
    required this.database,
    required this.routine,
    required this.routineWorkout,
    required this.workoutSet,
    required this.index,
    required this.auth,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet workoutSet;
  final int index;
  final AuthBase auth;

  @override
  _WorkoutSetWidgetState createState() => _WorkoutSetWidgetState();
}

class _WorkoutSetWidgetState extends State<WorkoutSetWidget> {
  late TextEditingController _textController1;
  late TextEditingController _textController2;
  late TextEditingController _textController3;

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();

    final weights = Formatter.weights(widget.workoutSet.weights!);
    _textController1 = TextEditingController(text: weights);

    final reps = widget.workoutSet.reps.toString();
    _textController2 = TextEditingController(text: reps);

    final restTime = widget.workoutSet.restTime.toString();
    _textController3 = TextEditingController(text: restTime);
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();

    super.dispose();
  }

  /// DELETE WORKOUT SET
  Future<void> _deleteSet(BuildContext context) async {
    try {
      // Update Routine Workout Data
      final numberOfSets = (widget.workoutSet.isRest)
          ? widget.routineWorkout.numberOfSets
          : widget.routineWorkout.numberOfSets - 1;

      final numberOfReps = (widget.workoutSet.isRest)
          ? widget.routineWorkout.numberOfReps
          : widget.routineWorkout.numberOfReps - (widget.workoutSet.reps ?? 0);

      final totalWeights = widget.routineWorkout.totalWeights -
          (widget.workoutSet.weights ?? 0) * (widget.workoutSet.reps ?? 0);

      final duration = widget.routineWorkout.duration -
          (widget.workoutSet.restTime ?? 0) -
          (widget.workoutSet.reps ?? 0) * widget.routineWorkout.secondsPerRep;

      final routineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayRemove([widget.workoutSet.toJson()]),
      };

      // Update Routine Data
      final routineTotalWeights = (widget.workoutSet.isRest)
          ? widget.routine.totalWeights
          : (widget.workoutSet.weights == 0)
              ? widget.routine.totalWeights
              : widget.routine.totalWeights -
                  ((widget.workoutSet.weights ?? 0) *
                      (widget.workoutSet.reps ?? 0));
      final routineDuration = (widget.workoutSet.isRest)
          ? widget.routine.duration - (widget.workoutSet.restTime ?? 0)
          : widget.routine.duration -
              ((widget.workoutSet.reps ?? 0) *
                  widget.routineWorkout.secondsPerRep);

      final routine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
        'lastEditedDate': Timestamp.now(),
      };

      await widget.database.setWorkoutSet(
        routine: widget.routine,
        routineWorkout: widget.routineWorkout,
        data: routineWorkout,
      );
      await widget.database.updateRoutine(widget.routine, routine);

      getSnackbarWidget(
        S.current.deleteWorkoutSet,
        (widget.workoutSet.isRest)
            ? S.current.deletedARestMessage
            : S.current.deletedASet,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// UPDATE WEIGHT
  Future<void> updateWeight() async {
    try {
      /// Update Workout Set
      List<WorkoutSet> workoutSets = widget.routineWorkout.sets;

      final updatedWorkoutSet = widget.workoutSet.copyWith(
        weights: int.tryParse(_textController1.text),
      );

      workoutSets[widget.index] = updatedWorkoutSet;

      await _submit(workoutSets);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }

    setState(() {
      weightsTabbed = false;
    });
    _focusNode1.unfocus();
  }

  /// UPDATE WORKOUT SET
  Future<void> updateReps() async {
    try {
      List<WorkoutSet> workoutSets = widget.routineWorkout.sets;

      /// Update Workout Set
      final updatedWorkoutSet = widget.workoutSet.copyWith(
        reps: int.tryParse(_textController2.text),
      );

      workoutSets[widget.index] = updatedWorkoutSet;

      await _submit(workoutSets);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }

    setState(() {
      weightsTabbed = false;
    });
    _focusNode2.unfocus();
  }

  /// UPDATE WORKOUT SET
  Future<void> updateRestTime() async {
    try {
      List<WorkoutSet> workoutSets = widget.routineWorkout.sets;

      /// Update Workout Set
      final updatedWorkoutSet = widget.workoutSet.copyWith(
        restTime: int.tryParse(_textController3.text),
      );

      workoutSets[widget.index] = updatedWorkoutSet;

      await _submit(workoutSets);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }

    setState(() {
      weightsTabbed = false;
    });
    _focusNode3.unfocus();
  }

  Future<void> _submit(List<WorkoutSet> workoutSets) async {
    /// Update Routine Workout
    int numberOfReps = 0;
    workoutSets.forEach((workoutSet) {
      numberOfReps += workoutSet.reps ?? 0;
    });

    num totalWeights = 0;
    workoutSets.forEach((workoutSet) {
      totalWeights += (workoutSet.weights ?? 0) * (workoutSet.reps ?? 0);
    });

    int duration = 0;
    workoutSets.forEach((workoutSet) {
      final int rest = workoutSet.restTime ?? 0;
      final int reps = workoutSet.reps ?? 0;
      final int secondsPerRep = widget.routineWorkout.secondsPerRep;

      duration += rest + reps * secondsPerRep;
    });

    final routineWorkout = {
      'numberOfReps': numberOfReps,
      'totalWeights': totalWeights,
      'duration': duration,
      'sets': workoutSets.map((e) => e.toJson()).toList(),
    };

    await widget.database.updateRoutineWorkout(
      routine: widget.routine,
      routineWorkout: widget.routineWorkout,
      data: routineWorkout,
    );

    /// Update Routine
    final routineTotalWeights = widget.routine.totalWeights -
        widget.routineWorkout.totalWeights +
        totalWeights;
    final routineDuration =
        widget.routine.duration - widget.routineWorkout.duration + duration;

    final routine = {
      'totalWeights': routineTotalWeights,
      'duration': routineDuration,
      'lastEditedDate': Timestamp.now(),
    };

    await widget.database.updateRoutine(widget.routine, routine);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('workout set widget building...');

    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            label: S.current.delete,
            backgroundColor: Colors.red,
            icon: Icons.delete_rounded,
            onPressed: (context) => _deleteSet(context),
          ),
        ],
      ),
      child: _buildRow(),
    );
  }

  bool weightsTabbed = false;
  bool repsTabbed = false;
  bool restTimeTabbed = false;

  Widget _buildRow() {
    final title = '${S.current.set} ${widget.workoutSet.setIndex}';
    final unit = Formatter.unitOfMass(widget.routine.initialUnitOfMass);
    final weights = widget.workoutSet.weights;
    final formattedWeights = '${Formatter.weights(weights!)} $unit';
    final reps = '${widget.workoutSet.reps} ${S.current.x}';
    final restTime = '${widget.workoutSet.restTime} ${S.current.seconds}';

    return KeyboardActions(
      config: _buildConfig(),
      bottomAvoiderScrollPhysics: const NeverScrollableScrollPhysics(),
      disableScroll: true,
      child: Row(
        children: [
          const SizedBox(width: 16, height: 56),
          if (!widget.workoutSet.isRest) Text(title, style: kBodyText1Bold),
          if (widget.workoutSet.isRest)
            const Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
          const Spacer(),

          /// Weights
          if (!widget.workoutSet.isRest)
            GestureDetector(
              onTap: () {
                if (widget.auth.currentUser!.uid ==
                        widget.routine.routineOwnerId &&
                    !widget.routineWorkout.isBodyWeightWorkout) {
                  setState(() {
                    weightsTabbed = true;
                  });
                }
              },
              behavior: HitTestBehavior.opaque,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 36,
                  width: 128,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: kCardColorLight,
                  child: (!weightsTabbed)
                      ? Center(
                          child: Text(
                            (widget.routineWorkout.isBodyWeightWorkout)
                                ? S.current.bodyweight
                                : formattedWeights,
                            style: TextStyles.body1,
                          ),
                        )
                      : TextField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _textController1,
                          style: TextStyles.body1,
                          focusNode: _focusNode1,
                          keyboardAppearance: Brightness.dark,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          maxLength: 5,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            suffixText: unit,
                            suffixStyle: TextStyles.body1,
                          ),
                          onSubmitted: (_) => updateWeight(),
                        ),
                ),
              ),
            ),
          const SizedBox(width: 16),

          /// Reps
          if (!widget.workoutSet.isRest)
            GestureDetector(
              onTap: () {
                if (widget.auth.currentUser!.uid ==
                    widget.routine.routineOwnerId) {
                  setState(() {
                    repsTabbed = true;
                  });
                }
              },
              behavior: HitTestBehavior.opaque,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 36,
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  color: kPrimaryColor,
                  child: (!repsTabbed)
                      ? Center(child: Text(reps, style: TextStyles.body1))
                      : TextField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          controller: _textController2,
                          style: TextStyles.body1,
                          focusNode: _focusNode2,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixText: S.current.x,
                            suffixStyle: TextStyles.body1,
                            counterText: '',
                          ),
                          onSubmitted: (_) => updateWeight(),
                        ),
                ),
              ),
            ),

          /// Rest Time
          if (widget.workoutSet.isRest)
            GestureDetector(
              onTap: () {
                if (widget.auth.currentUser!.uid ==
                    widget.routine.routineOwnerId) {
                  setState(() {
                    restTimeTabbed = true;
                  });
                }
              },
              behavior: HitTestBehavior.opaque,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 36,
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  color: kPrimaryColor,
                  child: (!restTimeTabbed)
                      ? Center(child: Text(restTime, style: TextStyles.body1))
                      : TextField(
                          autofocus: true,
                          textAlign: TextAlign.center,
                          controller: _textController3,
                          style: TextStyles.body1,
                          focusNode: _focusNode3,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixText: S.current.seconds,
                            suffixStyle: TextStyles.body1,
                            counterText: '',
                          ),
                          onSubmitted: (_) => updateWeight(),
                        ),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return InkWell(
                onTap: updateWeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode2,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return InkWell(
                onTap: updateReps,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode3,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return InkWell(
                onTap: updateRestTime,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
