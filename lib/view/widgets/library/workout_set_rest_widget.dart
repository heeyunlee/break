import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view_models/routine_workout_card_model.dart';
import 'package:workout_player/view_models/workout_set_rest_widget_model.dart';

import '../buttons.dart';

class WorkoutSetRestWidget extends ConsumerStatefulWidget {
  const WorkoutSetRestWidget({
    Key? key,
    required this.routine,
    required this.routineWorkout,
    required this.workoutSet,
    required this.model,
    required this.index,
    required this.setRestWidgetModel,
  }) : super(key: key);

  final Routine routine;
  final RoutineWorkout routineWorkout;
  final WorkoutSet workoutSet;
  final RoutineWorkoutCardModel model;
  final int index;
  final WorkoutSetRestWidgetModel setRestWidgetModel;

  @override
  _WorkoutSetRestWidgetState createState() => _WorkoutSetRestWidgetState();
}

class _WorkoutSetRestWidgetState extends ConsumerState<WorkoutSetRestWidget> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(
      text: widget.workoutSet.restTime.toString(),
    );

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(routineWorkoutCardModelProvider);

    return KeyboardActions(
      config: _buildConfig(_focusNode),
      autoScroll: false,
      disableScroll: true,
      bottomAvoiderScrollPhysics: const NeverScrollableScrollPhysics(),
      child: Slidable(
        enabled: model.isOwner(widget.routine),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: S.current.delete,
              backgroundColor: Colors.red,
              icon: Icons.delete_rounded,
              onPressed: (context) => widget.model.deleteRestingWorkoutSet(
                context,
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
                const Icon(Icons.timer_rounded, color: Colors.grey, size: 20),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 36,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.16),
                    child: TextField(
                      enabled: model.isOwner(widget.routine),
                      autofocus: false,
                      textAlign: TextAlign.center,
                      controller: _textEditingController,
                      style: TextStyles.body1,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixText: S.current.seconds,
                        suffixStyle: TextStyles.body1,
                        counterText: '',
                      ),
                      onEditingComplete: () =>
                          widget.setRestWidgetModel.updateRestTime(
                        context,
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        routine: widget.routine,
                        routineWorkout: widget.routineWorkout,
                        workoutSet: widget.workoutSet,
                        index: widget.index,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(FocusNode focusNode) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return KeyboardActionsConfig(
      keyboardSeparatorColor: Colors.grey[700]!,
      keyboardBarColor: isIOS ? ThemeColors.keyboard : theme.backgroundColor,
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode,
          displayDoneButton: false,
          displayArrows: false,
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(
                  onTap: () {
                    node.unfocus;
                    widget.setRestWidgetModel.updateRestTime(
                      context,
                      textEditingController: _textEditingController,
                      focusNode: _focusNode,
                      routine: widget.routine,
                      routineWorkout: widget.routineWorkout,
                      workoutSet: widget.workoutSet,
                      index: widget.index,
                    );
                  },
                ),
          ],
        ),
      ],
    );
  }
}
