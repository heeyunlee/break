import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/models/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view/widgets/keyboard_actions_done_button.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view/widgets/appbar_close_button.dart';
import 'package:workout_player/view/widgets/select_dates_widget.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/view/widgets/text_field/outlined_number_text_field_widget.dart';
import 'package:workout_player/view/widgets/text_field/outlined_text_text_field_widget.dart';

import '../../view_models/add_measurements_model.dart';

class AddMeasurementsScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AddMeasurementsModel model;

  const AddMeasurementsScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.model,
  }) : super(key: key);

  @override
  _AddMeasurementsScreenState createState() => _AddMeasurementsScreenState();
}

class _AddMeasurementsScreenState extends State<AddMeasurementsScreen> {
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
    logger.d('AddMeasurementsScreen building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarCloseButton(),
        title: Text(S.current.addMeasurement, style: TextStyles.subtitle2),
      ),
      body: Theme(
        data: ThemeData(
          primaryColor: kPrimaryColor,
          disabledColor: Colors.grey,
          iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
        ),
        child: Builder(builder: (context) => _buildBody(context)),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final unit = Formatter.unitOfMass(
      widget.user.unitOfMass,
      widget.user.unitOfMassEnum,
    );

    return KeyboardActions(
      config: _buildConfig(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: AddMeasurementsModel.formKey,
            child: Column(
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight),
                SelectDatesWidget(
                  borderColor: widget.model.borderColor,
                  onVisibilityChanged: widget.model.onVisibilityChanged,
                  initialDateTime: widget.model.loggedTime.toDate(),
                  onDateTimeChanged: widget.model.onDateTimeChanged,
                ),
                kCustomDivider,
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsModel.formKey,
                  focusNode: widget.model.focusNode1,
                  controller: widget.model.bodyweightController,
                  suffixText: unit,
                  labelText: S.current.bodyweightMeasurement,
                  customValidator: widget.model.weightInputValidator,
                ),
                const SizedBox(height: 16),
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsModel.formKey,
                  focusNode: widget.model.focusNode2,
                  controller: widget.model.bodyFatController,
                  suffixText: '%',
                  labelText: S.current.bodyFat,
                ),
                const SizedBox(height: 16),
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsModel.formKey,
                  focusNode: widget.model.focusNode3,
                  controller: widget.model.bmiController,
                  suffixText: 'kg/m²',
                  labelText: 'BMI',
                ),
                const SizedBox(height: 16),
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsModel.formKey,
                  focusNode: widget.model.focusNode4,
                  controller: widget.model.smmController,
                  suffixText: unit,
                  labelText: S.current.skeletalMuscleMass,
                ),
                kCustomDivider,
                OutlinedTextTextFieldWidget(
                  maxLines: 5,
                  formKey: AddMeasurementsModel.formKey,
                  focusNode: widget.model.focusNode5,
                  controller: widget.model.notesController,
                  labelText: S.current.notes,
                ),
                const SizedBox(height: 96),
              ],
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
                (focusNode) => KeyboardActionsDoneButton(
                      onTap: focusNode.unfocus,
                    ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width - 32,
      padding: EdgeInsets.only(
        bottom: widget.model.hasFocus() ? 48 : 0,
      ),
      child: FloatingActionButton.extended(
        onPressed: () => widget.model.submit(
          context,
          widget.database,
          widget.user,
        ),
        backgroundColor: widget.model.validate() ? kPrimaryColor : Colors.grey,
        heroTag: 'addProteinButton',
        label: Text(S.current.submit),
      ),
    );
  }
}
