import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import '../../../../format.dart';

Logger logger = Logger();

class WorkoutSetWidget extends StatefulWidget {
  const WorkoutSetWidget({
    Key key,
    this.database,
    this.routine,
    this.routineWorkout,
    this.set,
    this.index,
    this.user,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet set;
  final int index;
  final User user;

  @override
  _WorkoutSetWidgetState createState() => _WorkoutSetWidgetState();
}

class _WorkoutSetWidgetState extends State<WorkoutSetWidget> {
  final SlidableController _slidableController = SlidableController();

  final _formKey = GlobalKey<FormState>();

  final f = NumberFormat('#,###');

  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();
  var _textController3 = TextEditingController();

  FocusNode focusNode1;
  FocusNode focusNode2;
  FocusNode focusNode3;

  String _weights;
  String _reps;
  String _restTime;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    _weights = Format.weights(widget.set.weights);
    _textController1 = TextEditingController(text: _weights);

    _reps = widget.set.reps.toString();
    _textController2 = TextEditingController(text: _reps);

    _restTime = widget.set.restTime.toString();
    _textController3 = TextEditingController(text: _restTime);
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();

    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();

    super.dispose();
  }

  /// DELETE WORKOUT SET
  Future<void> _deleteSet(BuildContext context) async {
    try {
      final set = widget.set;

      // Update Routine Workout Data
      final numberOfSets = (set.isRest)
          ? widget.routineWorkout.numberOfSets
          : widget.routineWorkout.numberOfSets - 1;

      final numberOfReps = (set.isRest)
          ? widget.routineWorkout.numberOfReps
          : widget.routineWorkout.numberOfReps - set.reps;

      final totalWeights =
          widget.routineWorkout.totalWeights - (set.weights * set.reps);

      final duration = widget.routineWorkout.duration -
          set.restTime -
          (set.reps * widget.routineWorkout.secondsPerRep);

      final routineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayRemove([set.toMap()]),
      };

      // Update Routine Data
      final routineTotalWeights = (set.isRest)
          ? widget.routine.totalWeights
          : (set.weights == 0)
              ? widget.routine.totalWeights
              : widget.routine.totalWeights - (set.weights * set.reps);
      final routineDuration = (set.isRest)
          ? widget.routine.duration - set.restTime
          : widget.routine.duration -
              (set.reps * widget.routineWorkout.secondsPerRep);
      final now = Timestamp.now();

      final routine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
        'lastEditedDate': now,
      };

      await widget.database
          .setWorkoutSet(
        widget.routine,
        widget.routineWorkout,
        routineWorkout,
      )
          .then(
        (value) async {
          await widget.database.updateRoutine(widget.routine, routine);
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text((set.isRest) ? 'Deleted a rest!' : 'Deleted a set!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  /// UPDATE WORKOUT SET
  Future<void> updateSet() async {
    if (_formKey.currentState.validate()) {
      try {
        final workoutSets = widget.routineWorkout.sets;
        print('workoutSets is ${workoutSets.runtimeType}');
        final set = widget.set;

        final workoutWeights = double.parse(_weights);
        print('workoutWeights is ${workoutWeights.runtimeType}');

        /// Update Workout Set
        final newSet = WorkoutSet(
          workoutSetId: set.workoutSetId,
          isRest: set.isRest,
          index: set.index,
          setTitle: set.setTitle,
          restTime: int.parse(_restTime),
          reps: int.parse(_reps),
          weights: double.parse(_weights),
        );

        workoutSets[widget.index] = newSet;

        /// Update Routine Workout
        // NumberOfReps
        var numberOfReps = 0;
        print('numberOfReps is ${numberOfReps.runtimeType}');

        var numberOfRepsCalculated = false;
        print(
            'numberOfRepsCalculated is ${numberOfRepsCalculated.runtimeType}');

        if (!numberOfRepsCalculated) {
          for (var i = 0; i < workoutSets.length; i++) {
            var reps = workoutSets[i].reps;
            numberOfReps = numberOfReps + reps;
          }
          numberOfRepsCalculated = true;
        }
        print('numberOfReps is ${numberOfReps.runtimeType}');

        // Total Weights
        // ignore: omit_local_variable_types
        double totalWeights = 0;
        print('totalWeights is ${totalWeights.runtimeType}');

        var totalWeightsCalculated = false;

        if (!totalWeightsCalculated) {
          for (var i = 0; i < workoutSets.length; i++) {
            // ignore: omit_local_variable_types
            double weights = workoutSets[i].weights * workoutSets[i].reps;
            totalWeights = totalWeights + weights;
          }
          totalWeightsCalculated = true;
        }
        print('totalWeights is ${totalWeights.runtimeType}');

        // Duration
        // ignore: omit_local_variable_types
        int duration = 0;
        var durationCalculated = false;

        if (!durationCalculated) {
          for (var i = 0; i < workoutSets.length; i++) {
            var t = workoutSets[i].restTime +
                (workoutSets[i].reps * widget.routineWorkout.secondsPerRep);
            duration = duration + t;
          }
          durationCalculated = true;
        }

        final routineWorkout = {
          'numberOfReps': numberOfReps,
          'totalWeights': totalWeights,
          'duration': duration,
          'sets': workoutSets.map((e) => e.toMap()).toList(),
        };

        /// Update Routine Data
        final routineTotalWeights = widget.routine.totalWeights -
            widget.routineWorkout.totalWeights +
            totalWeights;
        final routineDuration =
            widget.routine.duration - widget.routineWorkout.duration + duration;

        final routine = {
          'totalWeights': routineTotalWeights,
          'duration': routineDuration,
        };

        await widget.database
            .updateRoutineWorkout(
          widget.routine,
          widget.routineWorkout,
          routineWorkout,
        )
            .then(
          (value) async {
            await widget.database.updateRoutine(widget.routine, routine);
          },
        );
        print('routineWorkout Updated');
      } on FirebaseException catch (e) {
        logger.d(e);
        await showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final set = widget.set;

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      controller: _slidableController,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_rounded,
          onTap: () => _deleteSet(context),
        ),
      ],
      child: _buildRow(set),
    );
  }

  bool weightsTabbed = false;
  bool repsTabbed = false;
  bool restTimeTabbed = false;

  Widget _buildRow(WorkoutSet set) {
    final title = set?.setTitle ?? 'Set Name';
    final unit = Format.unitOfMass(widget.routine.initialUnitOfMass);
    // ignore: omit_local_variable_types
    final double weights = widget.set.weights;
    final formattedWeights = '${Format.weights(weights)} $unit';
    final reps = '${widget.set.reps} x';
    final restTime = '${widget.set.restTime} s';

    return Form(
      key: _formKey,
      child: KeyboardActions(
        config: _buildConfig(),
        bottomAvoiderScrollPhysics: const NeverScrollableScrollPhysics(),
        disableScroll: true,
        child: Row(
          children: [
            const SizedBox(width: 16, height: 56),
            if (!set.isRest) Text(title, style: BodyText1Bold),
            if (set.isRest)
              const Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
            const Spacer(),

            /// Weights
            if (!set.isRest)
              GestureDetector(
                onTap: () {
                  if (widget.user.userId == widget.routine.routineOwnerId &&
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
                    color: CardColorLight,
                    child: (!weightsTabbed)
                        ? Center(
                            child: Text(
                              (widget.routineWorkout.isBodyWeightWorkout)
                                  ? 'Bodyweight'
                                  : formattedWeights,
                              style: BodyText1,
                            ),
                          )
                        : TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _textController1,
                            style: BodyText1,
                            focusNode: focusNode1,
                            keyboardAppearance: Brightness.dark,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            maxLength: 5,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              suffixText: unit,
                              suffixStyle: BodyText1,
                            ),
                            onFieldSubmitted: (value) {
                              _weights = value;
                              updateSet();
                            },
                            onChanged: (value) => _weights = value,
                            onSaved: (value) => _weights = value,
                          ),
                  ),
                ),
              ),
            const SizedBox(width: 16),

            /// Reps
            if (!set.isRest)
              GestureDetector(
                onTap: () {
                  if (widget.user.userId == widget.routine.routineOwnerId) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    alignment: Alignment.center,
                    color: PrimaryColor,
                    child: (!repsTabbed)
                        ? Center(child: Text(reps, style: BodyText1))
                        : TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: _textController2,
                            style: BodyText1,
                            focusNode: focusNode2,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              suffixText: 'x',
                              suffixStyle: BodyText1,
                              counterText: '',
                            ),
                            onFieldSubmitted: (value) {
                              _reps = value;
                              updateSet();
                            },
                            onChanged: (value) => _reps = value,
                            onSaved: (value) => _reps = value,
                          ),
                  ),
                ),
              ),

            /// Rest Time
            if (set.isRest)
              GestureDetector(
                onTap: () {
                  if (widget.user.userId == widget.routine.routineOwnerId) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    color: PrimaryColor,
                    child: (!restTimeTabbed)
                        ? Center(child: Text(restTime, style: BodyText1))
                        : TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: _textController3,
                            style: BodyText1,
                            focusNode: focusNode3,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              suffixText: 's',
                              suffixStyle: BodyText1,
                              counterText: '',
                            ),
                            onFieldSubmitted: (value) {
                              _restTime = value;
                              updateSet();
                            },
                            onChanged: (value) => _restTime = value,
                            onSaved: (value) => _restTime = value,
                          ),
                  ),
                ),
              ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode1,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  updateSet();
                  setState(() {
                    weightsTabbed = false;
                  });
                  node.unfocus();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DONE', style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: focusNode2,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  updateSet();
                  setState(() {
                    repsTabbed = false;
                  });
                  node.unfocus();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DONE', style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: focusNode3,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  updateSet();
                  setState(() {
                    restTimeTabbed = false;
                  });
                  node.unfocus();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DONE', style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
