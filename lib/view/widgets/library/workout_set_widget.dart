import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/routine_workout_card_model.dart';

import '../../../view_models/workout_set_widget_model.dart';

class WorkoutSetWidget extends StatefulWidget {
  const WorkoutSetWidget({
    Key? key,
    this.authAndDatabase,
    required this.routine,
    required this.routineWorkout,
    required this.workoutSet,
    required this.index,
    required this.model,
  }) : super(key: key);

  final AuthAndDatabase? authAndDatabase;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet workoutSet;
  final int index;
  final WorkoutSetWidgetModel model;

  @override
  _WorkoutSetWidgetState createState() => _WorkoutSetWidgetState();
}

class _WorkoutSetWidgetState extends State<WorkoutSetWidget> {
  late TextEditingController _textController1;
  late TextEditingController _textController2;

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;

  @override
  void initState() {
    super.initState();

    final weights = Formatter.numWithOrWithoutDecimal(
      widget.workoutSet.weights,
    );
    _textController1 = TextEditingController(text: weights);

    final reps = widget.workoutSet.reps.toString();
    _textController2 = TextEditingController(text: reps);

    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KeyboardActions(
      config: _buildConfig(context),
      bottomAvoiderScrollPhysics: const NeverScrollableScrollPhysics(),
      disableScroll: true,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: S.current.delete,
              backgroundColor: Colors.red,
              icon: Icons.delete_rounded,
              onPressed: (context) => widget.model.deleteSet(
                context,
                widget.authAndDatabase?.database,
                routine: widget.routine,
                routineWorkout: widget.routineWorkout,
                workoutSet: widget.workoutSet,
              ),
            ),
          ],
        ),
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  WorkoutSetWidgetModel.title(widget.workoutSet),
                  style: TextStyles.body1Bold,
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 36,
                    width: 128,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: theme.primaryColor.withOpacity(0.12),
                    child: Center(child: _buildWeightWidget()),
                  ),
                ),
                const SizedBox(width: 16),
                _buildActionsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightWidget() {
    if (widget.routineWorkout.isBodyWeightWorkout) {
      return Text(
        S.current.bodyweight,
        style: TextStyles.body1,
      );
    } else {
      return TextFormField(
        enabled: RoutineWorkoutCardModel.isOwner(
          widget.authAndDatabase?.auth,
          widget.routine,
        ),
        autofocus: false,
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
          suffixText: WorkoutSetWidgetModel.unit(widget.routine),
          suffixStyle: TextStyles.body1,
        ),
        onFieldSubmitted: (_) => widget.model.updateWeight(
          context,
          widget.authAndDatabase?.database,
          textEditingController: _textController1,
          focusNode: _focusNode1,
          routine: widget.routine,
          routineWorkout: widget.routineWorkout,
          workoutSet: widget.workoutSet,
          index: widget.index,
        ),
      );
    }
  }

  Widget _buildActionsWidget() {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 36,
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        color: theme.primaryColor.withOpacity(0.16),
        child: TextField(
          enabled: RoutineWorkoutCardModel.isOwner(
            widget.authAndDatabase?.auth,
            widget.routine,
          ),
          autofocus: false,
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
          onSubmitted: (_) => widget.model.updateReps(
            context,
            widget.authAndDatabase?.database,
            textEditingController: _textController2,
            focusNode: _focusNode2,
            routine: widget.routine,
            routineWorkout: widget.routineWorkout,
            workoutSet: widget.workoutSet,
            index: widget.index,
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return KeyboardActionsConfig(
      keyboardSeparatorColor: Colors.grey[700]!,
      keyboardBarColor: isIOS ? ThemeColors.keyboard : theme.backgroundColor,
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          displayArrows: true,
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(
                  onTap: () => widget.model.updateWeight(
                    context,
                    widget.authAndDatabase?.database,
                    textEditingController: _textController1,
                    focusNode: node,
                    routine: widget.routine,
                    routineWorkout: widget.routineWorkout,
                    workoutSet: widget.workoutSet,
                    index: widget.index,
                  ),
                ),
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode2,
          displayDoneButton: false,
          displayArrows: true,
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(
                  onTap: () => widget.model.updateReps(
                    context,
                    widget.authAndDatabase?.database,
                    textEditingController: _textController2,
                    focusNode: node,
                    routine: widget.routine,
                    routineWorkout: widget.routineWorkout,
                    workoutSet: widget.workoutSet,
                    index: widget.index,
                  ),
                ),
          ],
        ),
      ],
      // actions: List.generate(
      //   2,
      //   (index) {
      //     return KeyboardActionsItem(
      //       focusNode: _focusNodes[index],
      //       displayDoneButton: false,
      //       displayArrows: true,
      //       toolbarButtons: [
      //         (node) => KeyboardActionsDoneButton(
      //               onTap: () => widget.model.updateWeight(
      //                 context,
      //                 widget.authAndDatabase?.database,
      //                 textEditingController: _textControllers[index],
      //                 focusNode: node,
      //                 routine: widget.routine,
      //                 routineWorkout: widget.routineWorkout,
      //                 workoutSet: widget.workoutSet,
      //                 index: widget.index,
      //               ),
      //             ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
