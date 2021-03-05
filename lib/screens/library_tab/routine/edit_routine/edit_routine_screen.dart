import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';

import '../../../../common_widgets/appbar_blur_bg.dart';
import '../../../../common_widgets/max_width_raised_button.dart';
import '../../../../common_widgets/show_adaptive_modal_bottom_sheet.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../constants.dart';
import '../../../../models/routine.dart';
import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import 'edit_routine_equipment_required_screen.dart';
import 'edit_routine_main_muscle_group_screen.dart';
import 'edit_unit_of_mass_screen.dart';

Logger logger = Logger();

class EditRoutineScreen extends StatefulWidget {
  const EditRoutineScreen({
    Key key,
    @required this.database,
    this.routine,
    this.user,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final User user;

  static Future<void> show({BuildContext context, Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userStream(userId: auth.currentUser.uid).first;

    HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditRoutineScreen(
          database: database,
          routine: routine,
          user: user,
        ),
      ),
    );
    // await pushNewScreen(
    //   context,
    //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
    //   withNavBar: false,
    //   screen: EditRoutineScreen(
    //     database: database,
    //     routine: routine,
    //     user: auth.currentUser,
    //   ),
    // );
  }

  @override
  _EditRoutineScreenState createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode1;
  FocusNode focusNode2;

  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();

  bool _isPublic;
  String _routineTitle;
  String _description;
  double _totalWeights;
  int _averageTotalCalories;
  int _duration;

  double _difficultySlider;
  String _difficultySliderLabel;

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
    _averageTotalCalories = widget.routine.averageTotalCalories;
    _duration = widget.routine.duration;

    _difficultySlider = widget.routine.trainingLevel.toDouble();
    _difficultySliderLabel = Difficulty.values[_difficultySlider.toInt()].label;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode1.dispose();
    focusNode2.dispose();
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
  Future<void> _delete(BuildContext context, Routine routine) async {
    try {
      await widget.database.deleteRoutine(routine).then(
            (value) => Navigator.of(context).popUntil((route) => route.isFirst),
          );
      // TODO: ADD SNACKBAR

    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
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

        HapticFeedback.mediumImpact();
        Navigator.of(context).pop();
        // TODO: ADD SNACKBAR

      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    return StreamBuilder<Routine>(
        initialData: widget.routine,
        stream: widget.database.routineStream(
          routineId: widget.routine.routineId,
        ),
        builder: (context, snapshot) {
          final routine = snapshot.data;

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: BackgroundColor,
            appBar: AppBar(
              centerTitle: true,
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
              title: const Text('Edit Routine', style: Subtitle1),
              actions: <Widget>[
                FlatButton(
                  child: const Text('SAVE', style: ButtonText),
                  onPressed: _submit,
                ),
              ],
              flexibleSpace: AppbarBlurBG(),
            ),

            /// Using Builder() to build Body so that _buildContents can
            /// refer to Scaffold using Scaffold.of()
            body: Builder(
              builder: (BuildContext context) {
                return _buildContents(routine, context);
              },
            ),
          );
        });
  }

  Widget _buildContents(Routine routine, context) {
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
          child: Column(
            children: [
              SizedBox(height: size),
              _buildForm(routine),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaxWidthRaisedButton(
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
              ),
              SizedBox(height: 38),
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
          // _buildSecondMuscleGroupForm(routine),
          _buildEquipmentRequiredForm(routine),
          _buildUnitOfMassForm(routine),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              tileColor: CardColor,
              title: const Text('Public Routine', style: ButtonText),
              trailing: Switch(
                value: _isPublic,
                activeColor: PrimaryColor,
                onChanged: (bool value) {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _isPublic = value;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Make your routine either just for yourself or sharable with other users',
            style: Caption1Grey,
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
          child: const Text('Routine Title', style: BodyText1w800),
        ),

        /// Routine Title
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController1,
              style: BodyText2,
              focusNode: focusNode1,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              validator: (value) =>
                  value.isNotEmpty ? null : 'Give your routine a name!',
              onFieldSubmitted: (value) => _routineTitle = value,
              onChanged: (value) => _routineTitle = value,
              onSaved: (value) => _routineTitle = value,
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
          child: const Text('Description', style: BodyText1w800),
        ),

        /// Description
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildTrainingLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Text('Training Level', style: BodyText1w800),
        ),

        /// Training Level
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(_difficultySliderLabel, style: BodyText1),
              const SizedBox(height: 8),
              Slider(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Text('More Settings', style: BodyText1w800),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              title: const Text('Main Muscle Group', style: ButtonText),
              subtitle: Text(
                (routine.mainMuscleGroup.length == 1)
                    ? '${routine.mainMuscleGroup[0]}'
                    : (routine.mainMuscleGroup.length == 2)
                        ? '${routine.mainMuscleGroup[0]}, ${routine.mainMuscleGroup[1]}'
                        : '${routine.mainMuscleGroup[0]}, ${routine.mainMuscleGroup[1]}, etc.',
                style: BodyText2Grey,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: PrimaryGrey,
              ),
              tileColor: CardColor,
              onTap: () => EditRoutineMainMuscleGroupScreen.show(
                context,
                routine: routine,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentRequiredForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: const Text('Equipment Required', style: ButtonText),
          subtitle: Text(
            (routine.equipmentRequired.length == 1)
                ? '${routine.equipmentRequired[0]}'
                : (routine.equipmentRequired.length == 2)
                    ? '${routine.equipmentRequired[0]}, ${routine.equipmentRequired[1]}'
                    : '${routine.equipmentRequired[0]}, ${routine.equipmentRequired[1]}, etc.',
            style: BodyText2Grey,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: PrimaryGrey,
          ),
          tileColor: CardColor,
          onTap: () => EditRoutineEquipmentRequiredScreen.show(
            context,
            routine: routine,
          ),
        ),
      ),
    );
  }

  Widget _buildUnitOfMassForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: const Text('Unit of Mass', style: ButtonText),
          subtitle: Text(
            UnitOfMass.values[routine.initialUnitOfMass].label,
            style: BodyText2Grey,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: PrimaryGrey,
          ),
          tileColor: CardColor,
          onTap: () => EditUnitOfMassScreen.show(
            context: context,
            routine: routine,
            user: widget.user,
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
      firstActionText: 'Delete Routine',
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.routine),
      cancelText: 'Cancel',
      isCancelDefault: true,
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
      keyboardBarColor: Color(0xff303030),
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
                  child: const Text('DONE', style: ButtonText),
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
                  child: const Text('DONE', style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
