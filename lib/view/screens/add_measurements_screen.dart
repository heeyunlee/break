import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/models/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/add_measurements_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/formatter.dart';

/// Screen where users can input their [Measurement] data.
class AddMeasurementsScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AddMeasurementsScreenModel model;

  const AddMeasurementsScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.model,
  }) : super(key: key);

  /// FOR Navigation
  static Future<void> show(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    customPush(
      context,
      rootNavigator: true,
      builder: (context, auth, database) => Consumer(
        builder: (context, watch, child) => AddMeasurementsScreen(
          user: user,
          database: database,
          model: watch(addMeasurementsScreenModelProvider),
        ),
      ),
    );
  }

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

    return CustomScaffold(
      appBarLeading: const AppBarCloseButton(),
      appBarTitle: S.current.addMeasurement,
      buildBody: _buildBody,
      fabWidget: _buildFAB(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final unit = Formatter.unitOfMass(
      widget.user.unitOfMass,
      widget.user.unitOfMassEnum,
    );

    return KeyboardActions(
      config: _buildConfig(context),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: AddMeasurementsScreenModel.formKey,
            child: Column(
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight),
                SelectDatesWidget(
                  initialDateTime: widget.model.loggedTime.toDate(),
                  onDateTimeChanged: widget.model.onDateTimeChanged,
                ),
                kCustomDivider,
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsScreenModel.formKey,
                  focusNode: widget.model.focusNode1,
                  controller: widget.model.bodyweightController,
                  suffixText: unit,
                  labelText: S.current.bodyweightMeasurement,
                  customValidator: widget.model.weightInputValidator,
                ),
                const SizedBox(height: 16),
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsScreenModel.formKey,
                  focusNode: widget.model.focusNode2,
                  controller: widget.model.bodyFatController,
                  suffixText: '%',
                  labelText: S.current.bodyFat,
                ),
                const SizedBox(height: 16),
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsScreenModel.formKey,
                  focusNode: widget.model.focusNode3,
                  controller: widget.model.bmiController,
                  suffixText: 'kg/m²',
                  labelText: 'BMI',
                ),
                const SizedBox(height: 16),
                OutlinedNumberTextFieldWidget(
                  formKey: AddMeasurementsScreenModel.formKey,
                  focusNode: widget.model.focusNode4,
                  controller: widget.model.smmController,
                  suffixText: unit,
                  labelText: S.current.skeletalMuscleMass,
                ),
                kCustomDivider,
                OutlinedTextTextFieldWidget(
                  maxLines: 5,
                  formKey: AddMeasurementsScreenModel.formKey,
                  focusNode: widget.model.focusNode5,
                  controller: widget.model.notesController,
                  labelText: S.current.notes,
                ),
                const SizedBox(height: kBottomNavigationBarHeight + 64),
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
        onPressed: () => widget.model.submit(
          context,
          widget.database,
          widget.user,
        ),
        backgroundColor:
            widget.model.validate() ? theme.colorScheme.secondary : Colors.grey,
        heroTag: 'addProteinButton',
        label: Text(S.current.submit),
      ),
    );
  }
}
