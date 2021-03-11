import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';

import '../../../../common_widgets/appbar_blur_bg.dart';
import '../../../../common_widgets/max_width_raised_button.dart';
import '../../../../common_widgets/show_adaptive_modal_bottom_sheet.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../constants.dart';
import '../../../../services/auth.dart';
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

  static Future<void> show({BuildContext context, Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userStream(userId: auth.currentUser.uid).first;

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
    _difficultySliderLabel = Difficulty.values[_difficultySlider.toInt()].label;

    _secondsPerRepSlider = widget.workout.secondsPerRep.toDouble();
    _secondsPerRepSliderLabel = '$_secondsPerRepSlider seconds';
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
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Succfessfully Deleted a Workout!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
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
          content: Text('Updated a Workout Info!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.d(e);
        await showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
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
          final workout = snapshot.data;

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: BackgroundColor,
            appBar: AppBar(
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
              title: const Text('Edit Workout', style: Subtitle1),
              actions: <Widget>[
                TextButton(
                  onPressed: _submit,
                  child: const Text('SAVE', style: ButtonText),
                ),
              ],
              flexibleSpace: AppbarBlurBG(),
            ),

            /// Using Builder() to build Body so that _buildContents can
            /// refer to Scaffold using Scaffold.of()
            body: Builder(
              builder: (BuildContext context) {
                return _buildContents(workout, context);
              },
            ),
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
                  color: Colors.red,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  buttonText: 'Delete',
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
            title: const Text('Public Workout', style: ButtonText),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Make your routine either just for yourself or sharable with other users',
            style: Caption1Grey,
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Workout Title', style: BodyText1w800),
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
                  value.isNotEmpty ? null : 'Give your workout a name!',
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
          child: const Text('Description', style: BodyText1w800),
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
              decoration: const InputDecoration(
                hintText: 'Add description here!',
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
            'Difficulty: $_difficultySliderLabel',
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
                    Difficulty.values[_difficultySlider.toInt()].label;
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
            'Seconds per Rep: $formattedSecondsPerRep seconds',
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
                _secondsPerRepSliderLabel = '$formattedSecondsPerRep seconds';
              });
            },
            label: _secondsPerRepSliderLabel,
            min: 1,
            max: 10,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'This will help us calculate duration for a routine',
            style: Caption1Grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMainMuscleGroupForm(Workout workout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('More Settings', style: BodyText1w800),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              title: const Text('Main Muscle Group', style: ButtonText),
              subtitle: Text(
                (workout.mainMuscleGroup.length == 1)
                    ? '${workout.mainMuscleGroup[0]}'
                    : (workout.mainMuscleGroup.length == 2)
                        ? '${workout.mainMuscleGroup[0]}, ${workout.mainMuscleGroup[1]}'
                        : '${workout.mainMuscleGroup[0]}, ${workout.mainMuscleGroup[1]}, etc.',
                style: BodyText2Grey,
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: const Text('Equipment Required', style: ButtonText),
          subtitle: Text(
            (workout.equipmentRequired.length == 1)
                ? '${workout.equipmentRequired[0]}'
                : (workout.equipmentRequired.length == 2)
                    ? '${workout.equipmentRequired[0]}, ${workout.equipmentRequired[1]}'
                    : '${workout.equipmentRequired[0]}, ${workout.equipmentRequired[1]}, etc.',
            style: BodyText2Grey,
          ),
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

  Future<bool> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context: context,
      message: const Text(
        'Are you sure? You can\'t undo this process',
        textAlign: TextAlign.center,
      ),
      firstActionText: 'Delete Workout',
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.workout),
      cancelText: 'Cancel',
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DONE', style: ButtonText),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DONE', style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
