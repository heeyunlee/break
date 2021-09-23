import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/dialogs.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/scaffolds/appbar_blur_bg.dart';
import 'package:workout_player/view/widgets/modal_sheets/show_adaptive_modal_bottom_sheet.dart';

import 'edit_workout_equipment_required_screen.dart';
import 'edit_workout_location_screen.dart';
import 'edit_workout_main_muscle_group_screen.dart';

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({
    Key? key,
    required this.database,
    required this.workout,
    required this.user,
  }) : super(key: key);

  final Database database;
  final Workout workout;
  final User user;

  static Future<void> show(
    BuildContext context, {
    required Workout workout,
    required Database database,
    required AuthBase auth,
  }) async {
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditWorkoutScreen(
          database: database,
          workout: workout,
          user: user,
        ),
      ),
    );
  }

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNode1;
  late FocusNode focusNode2;

  late TextEditingController _textController1;
  late TextEditingController _textController2;

  late bool _isPublic;
  late String _workoutTitle;
  late String _description;

  late double _difficultySlider;
  late String _difficultySliderLabel;

  late double _secondsPerRepSlider;
  late String _secondsPerRepSliderLabel;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();

    _isPublic = widget.workout.isPublic;

    _workoutTitle = widget.workout.workoutTitle;
    _textController1 = TextEditingController(text: _workoutTitle);

    _description = widget.workout.description;
    _textController2 = TextEditingController(text: _description);

    _difficultySlider = widget.workout.difficulty.toDouble();
    _difficultySliderLabel =
        Difficulty.values[_difficultySlider.toInt()].translation!;

    _secondsPerRepSlider = widget.workout.secondsPerRep.toDouble();
    _secondsPerRepSliderLabel = '$_secondsPerRepSlider ${S.current.seconds}';
  }

  @override
  void dispose() {
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
  Future<void> _delete(BuildContext context, Workout workout) async {
    try {
      await widget.database.deleteWorkout(workout);

      final homeScreenModel = context.read(homeScreenModelProvider);

      homeScreenModel.popUntilRoot(context);

      getSnackbarWidget(
        S.current.deleteWorkoutkButtonText,
        S.current.deleteWorkoutSnackbar,
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
        final workout = {
          'workoutTitle': _workoutTitle,
          'lastEditedDate': lastEditedDate,
          'description': _description,
          'difficulty': _difficultySlider.toInt(),
          'isPublic': _isPublic,
          'secondsPerRep': _secondsPerRepSlider.toInt(),
        };
        await widget.database.updateWorkout(widget.workout, workout);
        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateWorkoutSnackbarTitle,
          S.current.updateWorkoutSnackbar,
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Workout?>(
      initialData: widget.workout,
      stream: widget.database.workoutStream(widget.workout.workoutId),
      builder: (context, snapshot) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: const AppBarCloseButton(),
            title: Text(
              S.current.editWorkoutTitle,
              style: TextStyles.subtitle1,
            ),
            flexibleSpace: const AppbarBlurBG(blurSigma: 10),
            actions: <Widget>[
              TextButton(
                onPressed: _submit,
                child: Text(S.current.save, style: TextStyles.button1),
              ),
            ],
          ),
          body: Builder(
            builder: (BuildContext context) =>
                _buildContents(snapshot.data!, context),
          ),
        );
      },
    );
  }

  Widget _buildContents(Workout workout, BuildContext context) {
    final appBarHeight = Scaffold.of(context).appBarMaxHeight;

    return Theme(
      data: ThemeData(
        primaryColor: ThemeColors.primary500,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: appBarHeight),
                _buildForm(workout),
                const SizedBox(height: 32),
                MaxWidthRaisedButton(
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
                const SizedBox(height: 38),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Workout workout) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSwitch(),
          _buildTitleForm(),
          _buildDescriptionForm(),
          _buildDifficulty(),
          _buildSecondsPerRep(),
          _buildMainMuscleGroupForm(workout),
          _buildEquipmentRequiredForm(workout),
          _buildLocationForm(workout),
        ],
      ),
    );
  }

  Widget _buildSwitch() {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: ThemeColors.card,
          title: Text(S.current.publicWorkout, style: TextStyles.button1),
          trailing: Switch(
            value: _isPublic,
            activeColor: ThemeColors.primary500,
            onChanged: (bool value) {
              setState(() {
                _isPublic = value;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            S.current.publicWorkoutDescription,
            style: TextStyles.caption1Grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(S.current.workoutName, style: TextStyles.body1W800),
        ),

        /// Workout Title
        Card(
          color: ThemeColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              maxLength: 35,
              // maxLines: 1,
              textInputAction: TextInputAction.done,
              controller: _textController1,
              style: TextStyles.body2,
              focusNode: focusNode1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              validator: (value) =>
                  value!.isNotEmpty ? null : S.current.workoutTitleAlertContent,
              onFieldSubmitted: (value) => _workoutTitle = value,
              onChanged: (value) => _workoutTitle = value,
              onSaved: (value) => _workoutTitle = value!,
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(S.current.description, style: TextStyles.body1W800),
        ),

        /// Description
        Card(
          color: ThemeColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              controller: _textController2,
              style: TextStyles.body2,
              focusNode: focusNode2,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: S.current.descriptionHintText,
                hintStyle: TextStyles.body2LightGrey,
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

  Widget _buildDifficulty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${S.current.difficulty}: $_difficultySliderLabel',
            style: TextStyles.body1W800,
          ),
        ),

        /// Difficulty
        Card(
          color: ThemeColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Slider(
            activeColor: ThemeColors.primary500,
            inactiveColor: ThemeColors.primary500.withOpacity(0.2),
            value: _difficultySlider,
            onChanged: (newRating) {
              setState(() {
                _difficultySlider = newRating;
                _difficultySliderLabel =
                    Difficulty.values[_difficultySlider.toInt()].translation!;
              });
            },
            // label: '$_ratingLabel',
            // min: 0,
            max: 2,
            divisions: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondsPerRep() {
    final f = NumberFormat('#,###');
    final formattedSecondsPerRep = f.format(_secondsPerRepSlider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${S.current.secondsPerRep}: $formattedSecondsPerRep ${S.current.seconds}',
            style: TextStyles.body1W800,
          ),
        ),
        Card(
          color: ThemeColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Slider(
            activeColor: ThemeColors.primary500,
            inactiveColor: ThemeColors.primary500.withOpacity(0.2),
            value: _secondsPerRepSlider,
            onChanged: (newRating) {
              setState(() {
                _secondsPerRepSlider = newRating;
                _secondsPerRepSliderLabel =
                    '$formattedSecondsPerRep ${S.current.seconds}';
              });
            },
            label: _secondsPerRepSliderLabel,
            min: 1,
            max: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            S.current.secondsPerRepHelperText,
            style: TextStyles.caption1,
          ),
        ),
      ],
    );
  }

  Widget _buildMainMuscleGroupForm(Workout workout) {
    final mainMuscleGroup = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
            .translation ??
        'Null';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(S.current.moreSettings, style: TextStyles.body1W800),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(S.current.mainMuscleGroup, style: TextStyles.button1),
            subtitle: Text(mainMuscleGroup, style: TextStyles.body2Grey),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: ThemeColors.grey500,
            ),
            tileColor: ThemeColors.card,
            onTap: () => EditWorkoutMainMuscleGroupScreen.show(
              context,
              workout: workout,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentRequiredForm(Workout workout) {
    final equipmentRequired = EquipmentRequired.values
            .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
            .translation ??
        'Null';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(S.current.equipmentRequired, style: TextStyles.button1),
        subtitle: Text(equipmentRequired, style: TextStyles.body2Grey),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: ThemeColors.grey500,
        ),
        tileColor: ThemeColors.card,
        onTap: () => EditWorkoutEquipmentRequiredScreen.show(
          context,
          workout: workout,
        ),
      ),
    );
  }

  Widget _buildLocationForm(Workout workout) {
    final locationIte = Location.values.where(
      (e) => e.toString() == workout.location,
    );
    final location =
        (locationIte.isEmpty) ? 'Not set yet' : locationIte.first.translation;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(S.current.location, style: TextStyles.button1),
        subtitle: Text(location!, style: TextStyles.body2Grey),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: ThemeColors.grey500,
        ),
        tileColor: ThemeColors.card,
        onTap: () => EditWorkoutLocationScreen.show(
          context,
          user: widget.user,
          workout: workout,
        ),
      ),
    );
  }

  Future<bool?> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      title: S.current.deleteWorkoutkButtonText,
      message: S.current.deleteWorkoutWarningMessage,
      firstActionText: S.current.deleteWorkoutkButtonText,
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.workout),
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: ThemeColors.grey700,
      keyboardBarColor: ThemeColors.keyboard,
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
                  child: Text(S.current.done, style: TextStyles.button1),
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
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
