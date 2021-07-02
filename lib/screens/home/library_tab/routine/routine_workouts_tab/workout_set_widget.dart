import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
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
    required this.set,
    required this.index,
    required this.auth,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet set;
  final int index;
  final AuthBase auth;

  @override
  _WorkoutSetWidgetState createState() => _WorkoutSetWidgetState();
}

class _WorkoutSetWidgetState extends State<WorkoutSetWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _textController1;
  late TextEditingController _textController2;
  late TextEditingController _textController3;

  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;

  late String _weights;
  late String _reps;
  late String _restTime;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

    _weights = Formatter.weights(widget.set.weights!);
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
          : widget.routineWorkout.numberOfReps - set.reps!;

      final totalWeights =
          widget.routineWorkout.totalWeights - (set.weights! * set.reps!);

      final duration = widget.routineWorkout.duration -
          set.restTime! -
          (set.reps! * widget.routineWorkout.secondsPerRep);

      final routineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayRemove([set.toJson()]),
      };

      // Update Routine Data
      final routineTotalWeights = (set.isRest)
          ? widget.routine.totalWeights
          : (set.weights == 0)
              ? widget.routine.totalWeights
              : widget.routine.totalWeights - (set.weights! * set.reps!);
      final routineDuration = (set.isRest)
          ? widget.routine.duration - set.restTime!
          : widget.routine.duration -
              (set.reps! * widget.routineWorkout.secondsPerRep);
      final now = Timestamp.now();

      final routine = {
        'totalWeights': routineTotalWeights,
        'duration': routineDuration,
        'lastEditedDate': now,
      };

      await widget.database.setWorkoutSet(
        routine: widget.routine,
        routineWorkout: widget.routineWorkout,
        data: routineWorkout,
      );
      await widget.database.updateRoutine(widget.routine, routine);

      getSnackbarWidget(
        '',
        (set.isRest) ? S.current.deletedARestMessage : S.current.deletedASet,
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

  /// UPDATE WORKOUT SET
  Future<void> updateSet() async {
    if (_formKey.currentState!.validate()) {
      try {
        final workoutSets = widget.routineWorkout.sets;
        // print('workoutSets is ${workoutSets.runtimeType}');
        final set = widget.set;

        // final workoutWeights = num.parse(_weights);
        // print('workoutWeights is ${workoutWeights.runtimeType}');

        // /// Workout Set
        // final sets = widget.routineWorkout.sets
        //     .where((element) => element.isRest == false)
        //     .toList();
        // final setIndex = sets.length + 1;

        /// Update Workout Set
        final newSet = WorkoutSet(
          workoutSetId: set.workoutSetId,
          isRest: set.isRest,
          index: set.index,
          setTitle: set.setTitle,
          restTime: int.parse(_restTime),
          reps: int.parse(_reps),
          weights: num.parse(_weights),
          setIndex: set.setIndex,
        );

        workoutSets![widget.index] = newSet;

        /// Update Routine Workout
        // NumberOfReps
        var numberOfReps = 0;
        // print('numberOfReps is ${numberOfReps.runtimeType}');

        var numberOfRepsCalculated = false;
        // print(
        //     'numberOfRepsCalculated is ${numberOfRepsCalculated.runtimeType}');

        if (!numberOfRepsCalculated) {
          for (var i = 0; i < workoutSets.length; i++) {
            var reps = workoutSets[i].reps;
            numberOfReps = numberOfReps + reps!;
          }
          numberOfRepsCalculated = true;
        }
        // print('numberOfReps is ${numberOfReps.runtimeType}');

        // Total Weights
        // ignore: omit_local_variable_types
        num totalWeights = 0;
        // print('totalWeights is ${totalWeights.runtimeType}');

        var totalWeightsCalculated = false;

        if (!totalWeightsCalculated) {
          for (var i = 0; i < workoutSets.length; i++) {
            num weights = workoutSets[i].weights! * workoutSets[i].reps!;
            totalWeights = totalWeights + weights;
          }
          totalWeightsCalculated = true;
        }

        // Duration
        int duration = 0;
        var durationCalculated = false;

        if (!durationCalculated) {
          for (var i = 0; i < workoutSets.length; i++) {
            var t = workoutSets[i].restTime! +
                (workoutSets[i].reps! * widget.routineWorkout.secondsPerRep);
            duration = duration + t;
          }
          durationCalculated = true;
        }

        final routineWorkout = {
          'numberOfReps': numberOfReps,
          'totalWeights': totalWeights,
          'duration': duration,
          'sets': workoutSets.map((e) => e.toJson()).toList(),
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
          routine: widget.routine,
          routineWorkout: widget.routineWorkout,
          data: routineWorkout,
        )
            .then(
          (value) async {
            await widget.database.updateRoutine(widget.routine, routine);
          },
        );
        // print('routineWorkout Updated');
      } on FirebaseException catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final set = widget.set;

    return Slidable(
      // startActionPane: const SlidableDrawerActionPane(),
      // controller: _slidableController,
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
      child: _buildRow(set, auth),
    );
  }

  bool weightsTabbed = false;
  bool repsTabbed = false;
  bool restTimeTabbed = false;

  Widget _buildRow(WorkoutSet set, AuthBase auth) {
    final title = '${S.current.set} ${set.setIndex}';
    final unit = Formatter.unitOfMass(widget.routine.initialUnitOfMass);
    final weights = widget.set.weights;
    final formattedWeights = '${Formatter.weights(weights!)} $unit';
    final reps = '${widget.set.reps} ${S.current.x}';
    final restTime = '${widget.set.restTime} ${S.current.seconds}';

    return Form(
      key: _formKey,
      child: KeyboardActions(
        config: _buildConfig(),
        bottomAvoiderScrollPhysics: const NeverScrollableScrollPhysics(),
        disableScroll: true,
        child: Row(
          children: [
            const SizedBox(width: 16, height: 56),
            if (!set.isRest) Text(title, style: kBodyText1Bold),
            if (set.isRest)
              const Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
            const Spacer(),

            /// Weights
            if (!set.isRest)
              GestureDetector(
                onTap: () {
                  if (auth.currentUser!.uid == widget.routine.routineOwnerId &&
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
                              style: kBodyText1,
                            ),
                          )
                        : TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _textController1,
                            style: kBodyText1,
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
                              suffixStyle: kBodyText1,
                            ),
                            onFieldSubmitted: (value) {
                              _weights = value;
                              updateSet();
                              setState(() {
                                weightsTabbed = false;
                              });
                              focusNode1.unfocus();
                            },
                            onChanged: (value) => _weights = value,
                            onSaved: (value) => _weights = value!,
                          ),
                  ),
                ),
              ),
            const SizedBox(width: 16),

            /// Reps
            if (!set.isRest)
              GestureDetector(
                onTap: () {
                  if (auth.currentUser!.uid == widget.routine.routineOwnerId) {
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
                        ? Center(child: Text(reps, style: kBodyText1))
                        : TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: _textController2,
                            style: kBodyText1,
                            focusNode: focusNode2,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixText: S.current.x,
                              suffixStyle: kBodyText1,
                              counterText: '',
                            ),
                            onFieldSubmitted: (value) {
                              _reps = value;

                              updateSet();
                              setState(() {
                                repsTabbed = false;
                              });
                              focusNode2.unfocus();
                            },
                            onChanged: (value) => _reps = value,
                            onSaved: (value) => _reps = value!,
                          ),
                  ),
                ),
              ),

            /// Rest Time
            if (set.isRest)
              GestureDetector(
                onTap: () {
                  if (auth.currentUser!.uid == widget.routine.routineOwnerId) {
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
                        ? Center(child: Text(restTime, style: kBodyText1))
                        : TextFormField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            controller: _textController3,
                            style: kBodyText1,
                            focusNode: focusNode3,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixText: S.current.seconds,
                              suffixStyle: kBodyText1,
                              counterText: '',
                            ),
                            onFieldSubmitted: (value) {
                              _restTime = value;
                              updateSet();

                              setState(() {
                                restTimeTabbed = false;
                              });
                              focusNode3.unfocus();
                            },
                            onChanged: (value) => _restTime = value,
                            onSaved: (value) => _restTime = value!,
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
      keyboardSeparatorColor: kGrey700,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
