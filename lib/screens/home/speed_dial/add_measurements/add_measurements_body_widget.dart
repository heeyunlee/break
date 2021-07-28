import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/classes/user.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'add_measurements_model.dart';
import 'widgets/bmi_text_field_widget.dart';
import 'widgets/body_fat_text_field_widget.dart';
import 'widgets/body_weight_text_field_widget.dart';
import 'widgets/notes_text_field_widget.dart';
import 'widgets/select_dates_widget.dart';
import 'widgets/skeleton_muscle_mass_text_field_widget.dart';

class AddMeasurementsBodyWidget extends StatefulWidget {
  final AddMeasurementsModel model;
  final User user;

  const AddMeasurementsBodyWidget({
    Key? key,
    required this.model,
    required this.user,
  }) : super(key: key);

  static Widget create({required User user}) {
    return Consumer(
      builder: (context, watch, child) => AddMeasurementsBodyWidget(
        model: watch(addMeasurementsModelProvider),
        user: user,
      ),
    );
  }

  @override
  _AddMeasurementsBodyWidgetState createState() =>
      _AddMeasurementsBodyWidgetState();
}

class _AddMeasurementsBodyWidgetState extends State<AddMeasurementsBodyWidget> {
  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit = Formatter.unitOfMass(widget.user.unitOfMass);

    return Theme(
      data: ThemeData(
        primaryColor: kPrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        isDialog: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: AddMeasurementsModel.formKey,
              child: Column(
                children: [
                  SelectDatesWidget(model: widget.model),
                  BodyWeightTextFieldWidget(model: widget.model, unit: unit),
                  BodyFatTextFieldWidget(model: widget.model),
                  SkeletonMuscleMassTextFieldWidget(
                    model: widget.model,
                    unit: unit,
                  ),
                  BMITextFieldWidget(model: widget.model),
                  NotesTextFieldWidget(model: widget.model),
                  const SizedBox(height: 96),
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
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: kKeyboardDarkColor,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: widget.model.focusNodes
          .map(
            (node) => KeyboardActionsItem(
              focusNode: node,
              displayDoneButton: false,
              toolbarButtons: [
                (n) => InkWell(
                      onTap: n.unfocus,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(S.current.done, style: TextStyles.button1),
                      ),
                    ),
              ],
            ),
          )
          .toList(),
    );
  }
}
