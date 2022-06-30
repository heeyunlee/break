import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/add_nutrition_screen_model.dart';

class AddNutritionScreen extends StatefulWidget {
  const AddNutritionScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final AddNutritionScreenModel model;

  // NAVIGATION
  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) => AddNutritionScreen(
          model: ref.watch(addNutritionScreenModelProvider),
        ),
      ),
    );
  }

  @override
  State<AddNutritionScreen> createState() => _AddNutritionScreenState();
}

class _AddNutritionScreenState extends State<AddNutritionScreen> {
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
    return CustomScaffold(
      appBarLeading: const AppBarCloseButton(),
      appBarTitle: S.current.addNutritions,
      buildBody: _buildBody,
      fabWidget: _buildFAB(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // final unit = Formatter.unitOfMassGram(
    //   widget.user.unitOfMass,
    //   widget.user.unitOfMassEnum,
    // );
    // TODO: add unit here
    const unit = 'Kg';
    final formKey = AddNutritionScreenModel.formKey;

    return KeyboardActions(
      config: _buildConfig(context),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight),
                ChooseMealTypeWidget(model: widget.model),
                SelectDatesWidget(
                  initialDateTime: widget.model.loggedTime.toDate(),
                  onDateTimeChanged: widget.model.onDateTimeChanged,
                ),
                kCustomDivider,
                OutlinedTextTextFieldWidget(
                  maxLines: 1,
                  formKey: formKey,
                  labelText: S.current.description,
                  focusNode: widget.model.descriptionFocusNode,
                  controller: widget.model.descriptionController,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                ),
                const SizedBox(height: 16),
                SetProteinAmountWidget(model: widget.model, unit: unit),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      child: OutlinedNumberTextFieldWidget(
                        formKey: formKey,
                        focusNode: widget.model.caloriesFocusNode,
                        controller: widget.model.caloriesController,
                        suffixText: 'kcal',
                        labelText: S.current.calories,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: OutlinedNumberTextFieldWidget(
                        formKey: formKey,
                        focusNode: widget.model.carbsFocusNode,
                        controller: widget.model.carbsController,
                        suffixText: unit,
                        labelText: S.current.carbs,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: OutlinedNumberTextFieldWidget(
                    formKey: formKey,
                    focusNode: widget.model.fatFocusNode,
                    controller: widget.model.fatController,
                    suffixText: unit,
                    labelText: S.current.fat,
                  ),
                ),
                kCustomDivider,
                OutlinedTextTextFieldWidget(
                  maxLines: 5,
                  formKey: formKey,
                  labelText: S.current.notes,
                  focusNode: widget.model.notesFocusNode,
                  controller: widget.model.notesController,
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return KeyboardActionsConfig(
      keyboardSeparatorColor: ThemeColors.grey700,
      keyboardBarColor: isIOS ? ThemeColors.keyboard : theme.backgroundColor,
      actions: widget.model.focusNodes
          .map(
            (focusNode) => KeyboardActionsItem(
              focusNode: focusNode,
              displayDoneButton: false,
              toolbarButtons: [
                (node) => KeyboardActionsDoneButton(onTap: node.unfocus),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      width: size.width - 32,
      padding: EdgeInsets.only(
        bottom: widget.model.hasFocus() ? 48 : 0,
      ),
      child: FloatingActionButton.extended(
        onPressed: () => widget.model.submit(context),
        backgroundColor:
            widget.model.validate() ? theme.colorScheme.primary : Colors.grey,
        heroTag: 'addProteinButton',
        label: Text(S.current.submit),
      ),
    );
  }
}
