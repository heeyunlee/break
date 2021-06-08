import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/edit_routine/edit_routine_location_screen.dart';
import 'package:workout_player/screens/tab_item.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';

import '../../../../widgets/appbar_blur_bg.dart';
import '../../../../widgets/max_width_raised_button.dart';
import '../../../../widgets/show_adaptive_modal_bottom_sheet.dart';
import '../../../../widgets/show_exception_alert_dialog.dart';
import '../../../../constants.dart';
import '../../../../models/routine.dart';
import '../../../../services/database.dart';
import '../../../home_screen_provider.dart';
import 'edit_routine_equipment_required_screen.dart';
import 'edit_routine_main_muscle_group_screen.dart';
import 'edit_unit_of_mass_screen.dart';

class EditRoutineScreen extends StatefulWidget {
  const EditRoutineScreen({
    Key? key,
    required this.database,
    required this.routine,
    required this.user,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final User user;

  static Future<void> show(
    BuildContext context, {
    required Routine routine,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.getUserDocument(auth.currentUser!.uid);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditRoutineScreen(
          database: database,
          routine: routine,
          user: user!,
        ),
      ),
    );
  }

  @override
  _EditRoutineScreenState createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNode1;
  late FocusNode focusNode2;

  late TextEditingController _textController1;
  late TextEditingController _textController2;

  late bool _isPublic;
  late String _routineTitle;
  late String? _description;
  late num _totalWeights;
  late int _averageTotalCalories;
  late int _duration;

  late double _difficultySlider;
  late String _difficultySliderLabel;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();

    _isPublic = widget.routine.isPublic;

    _routineTitle = widget.routine.routineTitle;
    _textController1 = TextEditingController(text: _routineTitle);

    _description = widget.routine.description;
    _textController2 = TextEditingController(text: _description);

    _totalWeights = widget.routine.totalWeights;
    _averageTotalCalories = widget.routine.averageTotalCalories!;
    _duration = widget.routine.duration;

    _difficultySlider = widget.routine.trainingLevel.toDouble();
    _difficultySliderLabel =
        Difficulty.values[_difficultySlider.toInt()].translation!;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode1.dispose();
    _textController1.dispose();

    focusNode2.dispose();
    _textController2.dispose();

    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Delete Routine Method
  Future<void> _delete(BuildContext context, Routine routine) async {
    try {
      await widget.database.deleteRoutine(routine);

      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      tabNavigatorKeys[CustomTabItem.library]!.currentState!.pop();

      getSnackbarWidget(
        S.current.deleteRoutineSnackbarTitle,
        S.current.deleteRoutineSnackbar,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final lastEditedDate = Timestamp.now();
        final routine = {
          'routineTitle': _routineTitle,
          'lastEditedDate': lastEditedDate,
          'routineCreatedDate': widget.routine.routineCreatedDate,
          'description': _description,
          'totalWeights': _totalWeights,
          'averageTotalCalories': _averageTotalCalories,
          'duration': _duration,
          'trainingLevel': _difficultySlider.toInt(),
          'isPublic': _isPublic,
        };
        await widget.database.updateRoutine(widget.routine, routine);

        await HapticFeedback.mediumImpact();
        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.editRoutineTitle,
          S.current.editRoutineSnackbar,
        );
      } on FirebaseException catch (e) {
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('edit routine scaffold building...');

    return StreamBuilder<Routine?>(
        initialData: widget.routine,
        stream: widget.database.routineStream(widget.routine.routineId),
        builder: (context, snapshot) {
          final routine = snapshot.data;

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              centerTitle: true,
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop();
                },
              ),
              title: Text(S.current.editRoutineTitle, style: kSubtitle1),
              actions: <Widget>[
                TextButton(
                  onPressed: _submit,
                  child: Text(S.current.save, style: kButtonText),
                ),
              ],
              flexibleSpace: AppbarBlurBG(),
            ),

            /// Using Builder() to build Body so that _buildContents can
            /// refer to Scaffold using Scaffold.of()
            body: Builder(
              builder: (BuildContext context) {
                return _buildContents(routine!, context);
              },
            ),
          );
        });
  }

  Widget _buildContents(Routine routine, BuildContext context) {
    final size = Scaffold.of(context).appBarMaxHeight;

    return Theme(
      data: ThemeData(
        primaryColor: kPrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size),
              _buildForm(routine),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaxWidthRaisedButton(
                  width: double.infinity,
                  color: Colors.red,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  buttonText: S.current.delete,
                  onPressed: () async {
                    await _showModalBottomSheet(context);
                  },
                ),
              ),
              const SizedBox(height: 38),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Routine routine) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSwitch(),
          _buildTitleForm(),
          _buildDescriptionForm(),
          _buildTrainingLevel(),
          _buildMainMuscleGroupForm(routine),
          _buildEquipmentRequiredForm(routine),
          _buildUnitOfMassForm(routine),
          _buildLocationForm(routine),
        ],
      ),
    );
  }

  Widget _buildSwitch() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: kCardColor,
            title: Text(S.current.publicRoutine, style: kButtonText),
            trailing: Switch(
              value: _isPublic,
              activeColor: kPrimaryColor,
              onChanged: (bool value) {
                HapticFeedback.mediumImpact();
                setState(() {
                  _isPublic = value;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            S.current.publicRoutineDescription,
            style: kCaption1Grey,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTitleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(S.current.routineTitleTitle, style: kBodyText1w800),
        ),

        /// Routine Title
        Card(
          color: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController1,
              style: kBodyText2,
              focusNode: focusNode1,
              maxLength: 45,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              validator: (value) => value!.isNotEmpty
                  ? null
                  : S.current.routineTitleValidatorText,
              onFieldSubmitted: (value) => _routineTitle = value,
              onChanged: (value) => _routineTitle = value,
              onSaved: (value) => _routineTitle = value!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(S.current.description, style: kBodyText1w800),
        ),

        /// Description
        Card(
          color: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController2,
              style: kBodyText2,
              focusNode: focusNode2,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: S.current.descriptionHintText,
                hintStyle: kBodyText2LightGrey,
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) => _description = value,
              onChanged: (value) => _description = value,
              onSaved: (value) => _description = value!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(S.current.trainingLevel, style: kBodyText1w800),
        ),

        /// Training Level
        Card(
          color: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(_difficultySliderLabel, style: kBodyText1),
              const SizedBox(height: 8),
              Slider(
                activeColor: kPrimaryColor,
                inactiveColor: kPrimaryColor.withOpacity(0.2),
                value: _difficultySlider,
                onChanged: (newRating) {
                  setState(() {
                    _difficultySlider = newRating;
                    _difficultySliderLabel = Difficulty
                        .values[_difficultySlider.toInt()].translation!;
                  });
                },
                min: 0,
                max: 2,
                divisions: 2,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainMuscleGroupForm(Routine routine) {
    final mainMuscleGroup = MainMuscleGroup.values
        .firstWhere((e) => e.toString() == routine.mainMuscleGroup[0])
        .translation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(S.current.moreSettings, style: kBodyText1w800),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(S.current.mainMuscleGroup, style: kButtonText),
            subtitle: Text(mainMuscleGroup!, style: kBodyText2Grey),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: kPrimaryGrey,
            ),
            tileColor: kCardColor,
            onTap: () => EditRoutineMainMuscleGroupScreen.show(
              context,
              routine: routine,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentRequiredForm(Routine routine) {
    final equipmentRequired = EquipmentRequired.values
        .firstWhere((e) => e.toString() == routine.equipmentRequired[0])
        .translation;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(S.current.equipmentRequired, style: kButtonText),
        subtitle: Text(
          equipmentRequired!,
          style: kBodyText2Grey,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: kPrimaryGrey,
        ),
        tileColor: kCardColor,
        onTap: () => EditRoutineEquipmentRequiredScreen.show(
          context,
          routine: routine,
        ),
      ),
    );
  }

  Widget _buildUnitOfMassForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(S.current.unitOfMass, style: kButtonText),
        subtitle: Text(
          UnitOfMass.values[routine.initialUnitOfMass].label!,
          style: kBodyText2Grey,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: kPrimaryGrey,
        ),
        tileColor: kCardColor,
        onTap: () => EditUnitOfMassScreen.show(
          context,
          routine: routine,
          user: widget.user,
        ),
      ),
    );
  }

  Widget _buildLocationForm(Routine routine) {
    final locationIte = Location.values.where(
      (e) => e.toString() == routine.location,
    );
    final location =
        (locationIte.isEmpty) ? 'Not set yet' : locationIte.first.translation;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(S.current.location, style: kButtonText),
        subtitle: Text(location!, style: kBodyText2Grey),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: kPrimaryGrey,
        ),
        tileColor: kCardColor,
        onTap: () => EditRoutineLocationScreen.show(
          context,
          routine: routine,
          user: widget.user,
        ),
      ),
    );
  }

  Future<bool?> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      title: Text('Delete Routine'),
      message: Text(
        S.current.deleteRoutineWarningMessage,
        textAlign: TextAlign.center,
      ),
      firstActionText: S.current.deleteRoutinekButtonText,
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.routine),
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode1,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: kButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: focusNode2,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: kButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
