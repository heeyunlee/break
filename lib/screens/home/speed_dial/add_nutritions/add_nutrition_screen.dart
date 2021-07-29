import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/classes/enum/unit_of_mass.dart';
import 'package:workout_player/screens/home/speed_dial/widgets/notes_text_field_widget.dart';
import 'package:workout_player/screens/home/speed_dial/widgets/select_dates_widget.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'add_nutrition_screen_model.dart';
import 'widgets/choose_meal_type_widget.dart';
import 'widgets/nutritions_text_field_widget.dart';
import 'widgets/set_protein_amount_widget.dart';

class AddNutritionScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AuthBase auth;
  final AddNutritionScreenModel model;

  const AddNutritionScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.auth,
    required this.model,
  }) : super(key: key);

  @override
  _AddNutritionScreenState createState() => _AddNutritionScreenState();
}

class _AddNutritionScreenState extends State<AddNutritionScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  void dispose() {
    widget.model.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        leading: const AppBarCloseButton(),
        flexibleSpace: const AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        title: Text(S.current.addNutritions, style: TextStyles.subtitle2),
      ),
      body: Builder(builder: (context) => _buildBody(context)),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final String unit = widget.user.unitOfMassEnum?.gram ??
        Formatter.unitOfMassGram(widget.user.unitOfMass);

    return Theme(
      data: ThemeData(
        disabledColor: kGrey700,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: AddNutritionScreenModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Scaffold.of(context).appBarMaxHeight),
                  ChooseMealTypeWidget(model: widget.model),
                  SelectDatesWidget(
                    borderColor: widget.model.borderColor,
                    onVisibilityChanged: widget.model.onVisibilityChanged,
                    timeInString: widget.model.loggedTimeInString,
                    initialDateTime: widget.model.loggedTime.toDate(),
                    onDateTimeChanged: widget.model.onDateTimeChanged,
                  ),
                  SetProteinAmountWidget(model: widget.model, unit: unit),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Flexible(
                          child: NutritionTextFieldWidget(
                            model: widget.model,
                            focusNode: widget.model.caloriesFocusNode,
                            controller: widget.model.caloriesController,
                            suffixText: 'Cal',
                            labelText: S.current.calories,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: NutritionTextFieldWidget(
                            model: widget.model,
                            focusNode: widget.model.carbsFocusNode,
                            controller: widget.model.carbsController,
                            suffixText: unit,
                            labelText: S.current.carbs,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: NutritionTextFieldWidget(
                        model: widget.model,
                        focusNode: widget.model.fatFocusNode,
                        controller: widget.model.fatController,
                        suffixText: unit,
                        labelText: S.current.fat,
                      ),
                    ),
                  ),
                  kCustomDivider,
                  NotesTextFieldWidget(
                    focusNode: widget.model.notesFocusNode,
                    controller: widget.model.notesController,
                  ),
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
            (focusNode) => KeyboardActionsItem(
              focusNode: focusNode,
              displayDoneButton: false,
              toolbarButtons: [
                (node) => InkWell(
                      onTap: node.unfocus,
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
