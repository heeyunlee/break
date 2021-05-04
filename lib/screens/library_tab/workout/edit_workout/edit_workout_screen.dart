import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/edit_workout/edit_workout_location_screen.dart';
import 'package:workout_player/services/auth.dart';

import '../../../../widgets/appbar_blur_bg.dart';
import '../../../../widgets/max_width_raised_button.dart';
import '../../../../widgets/show_adaptive_modal_bottom_sheet.dart';
import '../../../../widgets/show_exception_alert_dialog.dart';
import '../../../../constants.dart';
import '../../../../services/database.dart';
import 'edit_workout_equipment_required_screen.dart';
import 'edit_workout_main_muscle_group_screen.dart';

Logger logger = Logger();

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({
    Key key,
    @required this.database,
    this.workout,
    this.user,
  }) : super(key: key);

  final Database database;
  final Workout workout;
  final User user;

  static Future<void> show(BuildContext context, {Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userDocument(auth.currentUser.uid);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: false).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditWorkoutScreen(
          database: database,
          workout: workout,
          user: user,
        ),
      ),
    );
    // await pushNewScreen(
    //   context,
    //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
    //   withNavBar: true,
    //   screen: EditWorkoutScreen(
    //     database: database,
    //     workout: workout,
    //     user: user,
    //   ),
    // );
  }

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode1;
  FocusNode focusNode2;

  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();

  bool _isPublic;
  String _workoutTitle;
  String _description;

  double _difficultySlider;
  String _difficultySliderLabel;

  double _secondsPerRepSlider;
  String _secondsPerRepSliderLabel;

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
        Difficulty.values[_difficultySlider.toInt()].translation;

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
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Delete Routine Method
  Future<void> _delete(BuildContext context, Workout workout) async {
    try {
      await widget.database.deleteWorkout(workout);

      didChangeDependencies();

      // Navigation
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.current.deleteWorkoutSnackbar),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    } on FirebaseException catch (e) {
      logger.d(e);
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.updateWorkoutSnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.d(e);
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
    return StreamBuilder<Workout>(
        initialData: widget.workout,
        stream: widget.database.workoutStream(
          workoutId: widget.workout.workoutId,
        ),
        builder: (context, snapshot) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: BackgroundColor,
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
              title: Text(S.current.editWorkoutTitle, style: Subtitle1),
              flexibleSpace: AppbarBlurBG(),
              actions: <Widget>[
                TextButton(
                  onPressed: _submit,
                  child: Text(S.current.save, style: ButtonText),
                ),
              ],
            ),
            body: Builder(
              builder: (BuildContext context) =>
                  _buildContents(snapshot.data, context),
            ),
            // body: CustomStreamBuilderWidget(
            //   initialData: workoutDummyData,
            //   stream: widget.database.workoutStream(
            //     workoutId: widget.workout.workoutId,
            //   ),
            //   errorWidget: EmptyContent(
            //     message: S.current.somethingWentWrong,
            //   ),
            //   hasDataWidget: (context, snapshot) {
            //     return Builder(
            //       builder: (BuildContext context) =>
            //           _buildContents(snapshot.data, context),
            //     );
            //   },
            // ),
          );
        });
  }

  Widget _buildContents(Workout workout, BuildContext context) {
    final size = Scaffold.of(context).appBarMaxHeight;

    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
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
                SizedBox(height: size),
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
                SizedBox(height: 38),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            tileColor: CardColor,
            title: Text(S.current.publicWorkout, style: ButtonText),
            trailing: Switch(
              value: _isPublic,
              activeColor: PrimaryColor,
              onChanged: (bool value) {
                setState(() {
                  _isPublic = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(S.current.publicWorkoutDescription, style: Caption1Grey),
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
          child: Text(S.current.workoutName, style: BodyText1w800),
        ),

        /// Workout Title
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              maxLength: 35,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              controller: _textController1,
              style: BodyText2,
              focusNode: focusNode1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              validator: (value) =>
                  value.isNotEmpty ? null : S.current.workoutTitleAlertContent,
              onFieldSubmitted: (value) => _workoutTitle = value,
              onChanged: (value) => _workoutTitle = value,
              onSaved: (value) => _workoutTitle = value,
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
          child: Text(S.current.description, style: BodyText1w800),
        ),

        /// Description
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController2,
              style: BodyText2,
              focusNode: focusNode2,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: S.current.descriptionHintText,
                hintStyle: BodyText2LightGrey,
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) => _description = value,
              onChanged: (value) => _description = value,
              onSaved: (value) => _description = value,
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
            style: BodyText1.copyWith(fontWeight: FontWeight.w800),
          ),
        ),

        /// Difficulty
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Slider(
            activeColor: PrimaryColor,
            inactiveColor: PrimaryColor.withOpacity(0.2),
            value: _difficultySlider,
            onChanged: (newRating) {
              setState(() {
                _difficultySlider = newRating;
                _difficultySliderLabel =
                    Difficulty.values[_difficultySlider.toInt()].translation;
              });
            },
            // label: '$_ratingLabel',
            min: 0,
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
            style: BodyText1.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Slider(
            activeColor: PrimaryColor,
            inactiveColor: PrimaryColor.withOpacity(0.2),
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
            style: Caption1Grey,
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
          child: Text(S.current.moreSettings, style: BodyText1w800),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              title: Text(S.current.mainMuscleGroup, style: ButtonText),
              subtitle: Text(mainMuscleGroup, style: BodyText2Grey),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: PrimaryGrey,
              ),
              tileColor: CardColor,
              onTap: () => EditWorkoutMainMuscleGroupScreen.show(
                context,
                workout: workout,
              ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: Text(S.current.equipmentRequired, style: ButtonText),
          subtitle: Text(equipmentRequired, style: BodyText2Grey),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: PrimaryGrey,
          ),
          tileColor: CardColor,
          onTap: () => EditWorkoutEquipmentRequiredScreen.show(
            context,
            workout: workout,
          ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: Text(S.current.location, style: ButtonText),
          subtitle: Text(location, style: BodyText2Grey),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: PrimaryGrey,
          ),
          tileColor: CardColor,
          onTap: () => EditWorkoutLocationScreen.show(
            context,
            user: widget.user,
            workout: workout,
          ),
        ),
      ),
    );
  }

  Future<bool> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context: context,
      message: Text(
        S.current.deleteWorkoutWarningMessage,
        textAlign: TextAlign.center,
      ),
      firstActionText: S.current.deleteWorkoutButtonText,
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.workout),
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
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
                  child: Text(S.current.done, style: ButtonText),
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
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
