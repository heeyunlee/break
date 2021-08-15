import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/library/set_efforts_widget.dart';
import 'package:workout_player/view/widgets/library/toggle_is_public_widget.dart';
import 'package:workout_player/view/widgets/appbar_close_button.dart';
import 'package:workout_player/view/widgets/custom_scaffold.dart';
import 'package:workout_player/view/widgets/keyboard_actions_done_button.dart';
import 'package:workout_player/view/widgets/select_dates_widget.dart';
import 'package:workout_player/view/widgets/text_field/outlined_number_text_field_widget.dart';
import 'package:workout_player/view/widgets/text_field/outlined_text_text_field_widget.dart';

import '../../view_models/log_routine_screen_model.dart';

class LogRoutineScreen extends StatefulWidget {
  const LogRoutineScreen({
    Key? key,
    required this.database,
    required this.model,
    required this.data,
  }) : super(key: key);

  final Database database;
  final LogRoutineModel model;
  final RoutineDetailScreenClass data;

  @override
  _LogRoutineScreenState createState() => _LogRoutineScreenState();
}

class _LogRoutineScreenState extends State<LogRoutineScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init(widget.data.routine!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: S.current.addWorkoutLog,
      appBarLeading: AppBarCloseButton(),
      bodyWidget: _buildBody,
      fabWidget: _buildFAB(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final formKey = LogRoutineModel.formKey;

    return Theme(
      data: ThemeData(
        primaryColor: kPrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Scaffold.of(context).appBarMaxHeight!),
                  SelectDatesWidget(
                    labelText: S.current.startTime,
                    borderColor: widget.model.borderColor,
                    onVisibilityChanged: widget.model.onVisibilityChanged,
                    initialDateTime: widget.model.loggedTime.toDate(),
                    onDateTimeChanged: widget.model.onDateTimeChanged,
                  ),
                  const SizedBox(height: 16),
                  kCustomDividerIndent8,
                  const SizedBox(height: 16),
                  OutlinedTextTextFieldWidget(
                    maxLines: 1,
                    maxLength: 34,
                    formKey: formKey,
                    focusNode: widget.model.focusNode1,
                    controller: widget.model.titleEditingController,
                    labelText: S.current.routineTitleTitle,
                    hintText: S.current.routineTitleHintText,
                  ),
                  const SizedBox(height: 16),
                  OutlinedNumberTextFieldWidget(
                    formKey: formKey,
                    focusNode: widget.model.focusNode2,
                    controller: widget.model.durationEditingController,
                    labelText: 'Duration',
                    suffixText: S.current.minutes,
                  ),
                  const SizedBox(height: 16),
                  OutlinedNumberTextFieldWidget(
                    formKey: formKey,
                    focusNode: widget.model.focusNode3,
                    controller: widget.model.totalVolumeEditingController,
                    labelText: S.current.liftedWeights,
                    suffixText: Formatter.unitOfMass(
                      widget.data.routine!.initialUnitOfMass,
                      widget.data.routine!.unitOfMassEnum,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedTextTextFieldWidget(
                    maxLines: 5,
                    formKey: formKey,
                    focusNode: widget.model.focusNode4,
                    controller: widget.model.notesEditingController,
                    labelText: S.current.notes,
                    hintText: S.current.addNotes,
                  ),
                  const SizedBox(height: 16),
                  const SetEffortsWidget(),
                  const SizedBox(height: 16),
                  const ToggleIsPublicWidget(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      nextFocus: true,
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: List.generate(
        widget.model.focusNodes.length,
        (index) => KeyboardActionsItem(
          displayDoneButton: false,
          focusNode: widget.model.focusNodes[index],
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(onTap: node.unfocus),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width - 32,
      padding: EdgeInsets.only(
        bottom: (widget.model.hasFocus()) ? 48 : 0,
      ),
      child: FloatingActionButton.extended(
        onPressed: widget.model.isButtonPressed
            ? null
            : () => widget.model.submit(
                  context,
                  widget.database,
                  user: widget.data.user!,
                  routine: widget.data.routine!,
                  routineWorkouts: widget.data.routineWorkouts!,
                ),
        backgroundColor: widget.model.isButtonPressed
            ? kPrimaryColor.withOpacity(0.8)
            : kPrimaryColor,
        heroTag: 'logRoutineSubmitButton',
        label: Text(S.current.submit),
      ),
    );
  }
}
