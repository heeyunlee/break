import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/edit_routine_main_muscle_group_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';

class EditRoutineMainMuscleGroupScreen extends ConsumerStatefulWidget {
  const EditRoutineMainMuscleGroupScreen({
    Key? key,
    required this.routine,
    required this.user,
    required this.model,
  }) : super(key: key);

  final Routine routine;
  final User user;
  final EditRoutineMainMuscleGroupModel model;

  static void show(
    BuildContext context, {
    required Routine routine,
    required User user,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => Consumer(
        builder: (context, ref, child) => EditRoutineMainMuscleGroupScreen(
          routine: routine,
          user: user,
          model: ref.watch(editRoutineMainMuscleGroupModel),
        ),
      ),
    );
  }

  @override
  ConsumerState<EditRoutineMainMuscleGroupScreen> createState() =>
      _EditRoutineMainMuscleGroupScreenState();
}

class _EditRoutineMainMuscleGroupScreenState
    extends ConsumerState<EditRoutineMainMuscleGroupScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init(widget.routine);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: AppBarBackButton(
          onPressed: () async {
            final status = await widget.model.submitAndPop(widget.routine);

            if (mounted) return;

            if (status.statusCode == 200) {
              Navigator.of(context).pop();
            } else if (status.statusCode == 404) {
              await showExceptionAlertDialog(
                context,
                title: S.current.operationFailed,
                exception: status.exception.toString(),
              );
            } else {
              await showAlertDialog(
                context,
                title: S.current.equipmentRequiredAlertTitle,
                content: S.current.equipmentRequiredAlertContent,
                defaultActionText: S.current.ok,
              );
            }
          },
          // onPressed: () => widget.model.submitAndPop(
          //   context,
          //   routine: widget.routine,
          // ),
        ),
        title: Text(S.current.mainMuscleGroup, style: TextStyles.subtitle1),
      ),
      body: Builder(
        builder: (context) => ListView.builder(
          padding: EdgeInsets.only(
            top: Scaffold.of(context).appBarMaxHeight! + 16,
            bottom: 8,
          ),
          itemCount: MainMuscleGroup.values.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final muscle = MainMuscleGroup.values[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: widget.model.selected(muscle)
                      ? theme.primaryColor
                      : theme.primaryColor.withOpacity(0.12),
                  child: CheckboxListTile(
                    activeColor: theme.primaryColorDark,
                    title: Text(muscle.translation!, style: TextStyles.button1),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: widget.model.selected(muscle),
                    selected: widget.model.selected(muscle),
                    onChanged: (bool? checked) =>
                        widget.model.addOrRemove(checked, muscle),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
