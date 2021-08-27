import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../view_models/workout_set_widget_model.dart';

class WorkoutSetWidget extends StatefulWidget {
  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet workoutSet;
  final int index;
  final AuthBase auth;
  final WorkoutSetWidgetModel model;

  const WorkoutSetWidget({
    Key? key,
    required this.database,
    required this.routine,
    required this.routineWorkout,
    required this.workoutSet,
    required this.index,
    required this.auth,
    required this.model,
  }) : super(key: key);

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

  bool _weightsTabbed = false;
  bool _repsTabbed = false;
  bool _restTimeTabbed = false;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();

    final weights = Formatter.numWithOrWithoutDecimal(
      widget.workoutSet.weights,
    );
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

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: S.current.delete,
            backgroundColor: Colors.red,
            icon: Icons.delete_rounded,
            onPressed: (context) => widget.model.deleteSet(
              context,
              routine: widget.routine,
              routineWorkout: widget.routineWorkout,
              workoutSet: widget.workoutSet,
            ),
          ),
        ],
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        bottomAvoiderScrollPhysics: const NeverScrollableScrollPhysics(),
        disableScroll: true,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTitleWidget(),
                const Spacer(),
                if (!widget.workoutSet.isRest) _buildWeightWidget(),
                const SizedBox(width: 16),
                _buildActionsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    final title = '${S.current.set} ${widget.workoutSet.setIndex}';

    if (widget.workoutSet.isRest) {
      return const Icon(Icons.timer_rounded, color: Colors.grey, size: 20);
    } else {
      return Text(title, style: TextStyles.body1Bold);
    }
  }

  Widget _buildWeightWidget() {
    final unit = Formatter.unitOfMass(
      widget.routine.initialUnitOfMass,
      widget.routine.unitOfMassEnum,
    );

    return GestureDetector(
      onTap: () {
        if (widget.auth.currentUser!.uid == widget.routine.routineOwnerId &&
            !widget.routineWorkout.isBodyWeightWorkout) {
          setState(() {
            _weightsTabbed = true;
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
          child: (!_weightsTabbed)
              ? Center(
                  child: Text(
                    Formatter.workoutSetWeights(
                      widget.routine,
                      widget.routineWorkout,
                      widget.workoutSet,
                    ),
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
                  onSubmitted: (_) {
                    widget.model.updateWeight(
                      context,
                      textEditingController: _textController1,
                      focusNode: _focusNode1,
                      routine: widget.routine,
                      routineWorkout: widget.routineWorkout,
                      workoutSet: widget.workoutSet,
                      index: widget.index,
                    );

                    setState(() {
                      _weightsTabbed = false;
                    });
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildActionsWidget() {
    if (widget.workoutSet.isRest) {
      final restTime = '${widget.workoutSet.restTime} ${S.current.seconds}';

      return GestureDetector(
        onTap: () {
          if (widget.auth.currentUser!.uid == widget.routine.routineOwnerId) {
            setState(() {
              _restTimeTabbed = true;
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
            child: (!_restTimeTabbed)
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
                    onSubmitted: (_) {
                      widget.model.updateRestTime(
                        context,
                        textEditingController: _textController3,
                        focusNode: _focusNode3,
                        routine: widget.routine,
                        routineWorkout: widget.routineWorkout,
                        workoutSet: widget.workoutSet,
                        index: widget.index,
                      );

                      setState(() {
                        _restTimeTabbed = false;
                      });
                    },
                  ),
          ),
        ),
      );
    } else {
      final reps = '${widget.workoutSet.reps} ${S.current.x}';

      return GestureDetector(
        onTap: () {
          if (widget.auth.currentUser!.uid == widget.routine.routineOwnerId) {
            setState(() {
              _repsTabbed = true;
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
            child: (!_repsTabbed)
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
                    onSubmitted: (_) {
                      widget.model.updateReps(
                        context,
                        textEditingController: _textController2,
                        focusNode: _focusNode2,
                        routine: widget.routine,
                        routineWorkout: widget.routineWorkout,
                        workoutSet: widget.workoutSet,
                        index: widget.index,
                      );

                      setState(() {
                        _repsTabbed = false;
                      });
                    },
                  ),
          ),
        ),
      );
    }
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      // keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return InkWell(
                onTap: () {
                  widget.model.updateWeight(
                    context,
                    textEditingController: _textController1,
                    focusNode: _focusNode1,
                    routine: widget.routine,
                    routineWorkout: widget.routineWorkout,
                    workoutSet: widget.workoutSet,
                    index: widget.index,
                  );

                  setState(() {
                    _weightsTabbed = false;
                  });
                },
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
                onTap: () {
                  widget.model.updateReps(
                    context,
                    textEditingController: _textController2,
                    focusNode: _focusNode2,
                    routine: widget.routine,
                    routineWorkout: widget.routineWorkout,
                    workoutSet: widget.workoutSet,
                    index: widget.index,
                  );

                  setState(() {
                    _repsTabbed = false;
                  });
                },
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
                onTap: () {
                  widget.model.updateRestTime(
                    context,
                    textEditingController: _textController3,
                    focusNode: _focusNode3,
                    routine: widget.routine,
                    routineWorkout: widget.routineWorkout,
                    workoutSet: widget.workoutSet,
                    index: widget.index,
                  );

                  setState(() {
                    _restTimeTabbed = false;
                  });
                },
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
