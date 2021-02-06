import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/screens/library_tab/routine/edit_routine/edit_second_muscle_group_screen.dart';
import 'package:workout_player/services/auth.dart';

import '../../../../common_widgets/appbar_blur_bg.dart';
import '../../../../common_widgets/max_width_raised_button.dart';
import '../../../../common_widgets/show_alert_dialog.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../constants.dart';
import '../../../../models/routine.dart';
import '../../../../services/database.dart';
import 'edit_equipment_required_screen.dart';
import 'edit_main_muscle_group_screen.dart';

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
    await Navigator.of(context, rootNavigator: false).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditRoutineScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
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
  FocusNode focusNode3;

  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();
  var _textController3 = TextEditingController();

  String _routineTitle;
  String _description;
  String _imageUrl;
  int _totalWeights;
  int _averageTotalCalories;
  int _duration;

  // For SliverApp to Work
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    if (widget.routine != null) {
      _routineTitle = widget.routine.routineTitle;
      _textController1 = TextEditingController(text: _routineTitle);

      _description = widget.routine.description;
      _textController2 = TextEditingController(text: _description);

      _imageUrl = widget.routine.imageUrl;
      _textController3 = TextEditingController(text: _imageUrl);

      _totalWeights = widget.routine.totalWeights;
      _averageTotalCalories = widget.routine.averageTotalCalories;
      _duration = widget.routine.duration;
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();

    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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
      await widget.database.deleteRoutine(routine);
      Navigator.of(context).popUntil((route) => route.isFirst);
      showFlushBar(
        context: context,
        message: 'Routine Deleted',
      );
    } on FirebaseException catch (e) {
      logger.d(e);
      ShowExceptionAlertDialog(
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
        final routines = await widget.database.routinesStream().first;
        final allNames =
            routines.map((routine) => routine.routineTitle).toList();
        if (widget.routine != null) {
          allNames.remove(widget.routine.routineTitle);
        }
        if (allNames.contains(_routineTitle)) {
          showAlertDialog(
            context,
            title: 'Routine Name Duplicate',
            content: 'Please choose a different workout name',
            defaultActionText: 'OK',
          );
        } else {
          final routineId =
              widget.routine?.routineId ?? documentIdFromCurrentDate();
          final userId = widget.user.uid;
          final userName = widget.user.displayName;
          final lastEditedDate = Timestamp.now();
          final routine = {
            'routineId': routineId,
            'routineOwnerId': userId,
            'routineOwnerUserName': userName,
            'routineTitle': _routineTitle,
            'lastEditedDate': lastEditedDate,
            'routineCreatedDate': widget.routine.routineCreatedDate,
            'description': _description,
            'imageUrl': _imageUrl,
            'totalWeights': _totalWeights,
            'averageTotalCalories': _averageTotalCalories,
            'duration': _duration,
          };
          await widget.database.updateRoutine(widget.routine, routine);
          Navigator.of(context).pop();
          showFlushBar(context: context, message: 'Routine changes saved!');
        }
      } on FirebaseException catch (e) {
        ShowExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Edit Routine', style: Subtitle1),
              actions: <Widget>[
                FlatButton(
                  child: Text('SAVE', style: ButtonText),
                  onPressed: _submit,
                ),
              ],
              flexibleSpace: AppbarBlurBG(),
            ),
            body: _buildContents(routine),
          );
        });
  }

  Widget _buildContents(Routine routine) {
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
              SizedBox(height: 88),
              _buildForm(routine),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaxWidthRaisedButton(
                  color: Colors.red,
                  icon: Icon(
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
          _buildTitleForm(),
          _buildDescriptionForm(),
          _buildMainMuscleGroupForm(routine),
          _buildSecondMuscleGroupForm(routine),
          _buildEquipmentRequiredForm(routine),
        ],
      ),
    );
  }

  Widget _buildTitleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Routine Title',
            style: BodyText1.copyWith(color: PrimaryGrey),
          ),
        ),

        /// Routine Title
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController1,
              style: BodyText2,
              focusNode: focusNode1,
              decoration: InputDecoration(
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
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Description',
            style: BodyText1.copyWith(color: PrimaryGrey),
          ),
        ),

        /// Description
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController2,
              style: BodyText2,
              focusNode: focusNode2,
              maxLines: 3,
              decoration: InputDecoration(
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

  Widget _buildMainMuscleGroupForm(Routine routine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'More Settings',
            style: BodyText1.copyWith(color: PrimaryGrey),
          ),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              title: Text('Main Muscle Group', style: ButtonText),
              subtitle: Text(
                (routine.mainMuscleGroup.length == 1)
                    ? '${routine.mainMuscleGroup[0]}'
                    : (routine.mainMuscleGroup.length == 2)
                        ? '${routine.mainMuscleGroup[0]}, ${routine.mainMuscleGroup[1]}'
                        : '${routine.mainMuscleGroup[0]}, ${routine.mainMuscleGroup[1]}, etc.',
                style: BodyText2.copyWith(color: Colors.grey),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, color: PrimaryGrey),
              tileColor: CardColor,
              onTap: () => EditMainMuscleGroupScreen.show(
                context,
                routine: routine,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondMuscleGroupForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: Text('Second Muscle Group', style: ButtonText),
          subtitle: Text(
            (routine.secondMuscleGroup.length == 1)
                ? '${routine.secondMuscleGroup[0]}'
                : (routine.secondMuscleGroup.length == 2)
                    ? '${routine.secondMuscleGroup[0]}, ${routine.secondMuscleGroup[1]}'
                    : '${routine.secondMuscleGroup[0]}, ${routine.secondMuscleGroup[1]}, etc.',
            style: BodyText2.copyWith(color: Colors.grey),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: PrimaryGrey),
          tileColor: CardColor,
          onTap: () => EditSecondMuscleGroupScreen.show(
            context,
            routine: routine,
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentRequiredForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: Text('Second Muscle Group', style: ButtonText),
          subtitle: Text(
            (routine.equipmentRequired.length == 1)
                ? '${routine.equipmentRequired[0]}'
                : (routine.equipmentRequired.length == 2)
                    ? '${routine.equipmentRequired[0]}, ${routine.equipmentRequired[1]}'
                    : '${routine.equipmentRequired[0]}, ${routine.equipmentRequired[1]}, etc.',
            style: BodyText2.copyWith(color: Colors.grey),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: PrimaryGrey),
          tileColor: CardColor,
          onTap: () => EditEquipmentRequiredScreen.show(
            context,
            routine: routine,
          ),
        ),
      ),
    );
  }

  Future<bool> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context: context,
      message: Text(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
