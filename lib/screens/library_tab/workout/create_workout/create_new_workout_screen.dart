import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/create_workout/new_workout_difficulty_and_more_screen.dart';
import 'package:workout_player/screens/library_tab/workout/create_workout/new_workout_equipment_required_screen.dart';
import 'package:workout_player/screens/library_tab/workout/create_workout/new_workout_main_muscle_group_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import 'new_workout_title_screen.dart';

Logger logger = Logger();

class CreateNewWorkoutScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final User user;

  const CreateNewWorkoutScreen({
    Key key,
    @required this.database,
    this.auth,
    this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userDocument(auth.currentUser.uid);

    await HapticFeedback.mediumImpact();
    await pushNewScreen(
      context,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
      withNavBar: false,
      screen: CreateNewWorkoutScreen(
        database: database,
        auth: auth,
        user: user,
      ),
    );
  }

  @override
  _CreateNewWorkoutScreenState createState() => _CreateNewWorkoutScreenState();
}

class _CreateNewWorkoutScreenState extends State<CreateNewWorkoutScreen> {
  String _workoutTitle;
  String _description = '';
  List _selectedMainMuscleGroup = [];
  List _selectedEquipmentRequired = [];
  double _difficultySlider = 0;
  double _secondsPerRepSlider = 2;
  String _location = 'Location.gym';

  int _pageIndex = 0;

  // Submit data to Firestore
  Future<void> _submit() async {
    debugPrint('_submit button pressed!');
    try {
      final workoutId = documentIdFromCurrentDate();
      final userId = widget.user.userId;
      final userName = widget.user.userName;
      final lastEditedDate = Timestamp.now();
      final workoutCreatedDate = Timestamp.now();
      final isBodyWeightWorkout = (_selectedEquipmentRequired
              .contains(EquipmentRequired.bodyweight.toString()))
          ? true
          : false;

      // Get Image Url
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final imageIndex = Random().nextInt(2);
      final imageUrl = await ref
          .child('${_selectedMainMuscleGroup[0]}$imageIndex.jpeg')
          .getDownloadURL();

      final workout = Workout(
        workoutId: workoutId,
        workoutOwnerId: userId,
        workoutOwnerUserName: userName,
        workoutTitle: _workoutTitle,
        mainMuscleGroup: _selectedMainMuscleGroup,
        secondaryMuscleGroup: null,
        description: _description,
        equipmentRequired: _selectedEquipmentRequired,
        imageUrl: imageUrl,
        isBodyWeightWorkout: isBodyWeightWorkout,
        lastEditedDate: lastEditedDate,
        workoutCreatedDate: workoutCreatedDate,
        difficulty: _difficultySlider.toInt(),
        secondsPerRep: _secondsPerRepSlider.toInt(),
        isPublic: true,
        location: _location,
      );
      await widget.database.setWorkout(workout);
      await Navigator.of(context, rootNavigator: false).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            database: widget.database,
            tag: 'newWorkout-${workout.workoutId}',
            user: widget.user,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  void saveTitle() {
    debugPrint('saveTitle Pressed');
    if (_workoutTitle != null && _workoutTitle != '') {
      setState(() {
        _pageIndex = 1;
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.workoutTitleAlertTitle,
        content: S.current.workoutTitleAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  void saveMainMuscleGroup() {
    debugPrint('saveMainMuscleGroup Pressed');
    if (_selectedMainMuscleGroup.isNotEmpty) {
      setState(() {
        _pageIndex = 2;
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.mainMuscleGroupAlertTitle,
        content: S.current.mainMuscleGroupAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  void saveEquipmentRequired() {
    debugPrint('saveEquipmentRequired Pressed');
    if (_selectedEquipmentRequired.isNotEmpty) {
      setState(() {
        _pageIndex = 3;
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.equipmentRequiredAlertTitle,
        content: S.current.equipmentRequiredAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  void saveDifficulty() {
    debugPrint('saveDifficulty Pressed');
    _submit();
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Create New Workout Screen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          (_pageIndex == 0)
              ? S.current.workoutName
              : (_pageIndex == 1)
                  ? S.current.mainMuscleGroup
                  : (_pageIndex == 2)
                      ? S.current.equipmentRequired
                      : S.current.moreAboutThisWorkout,
          style: Subtitle2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: AppbarBlurBG(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          switch (_pageIndex) {
            case 0:
              return NewWorkoutTitleScreen(
                indexCallback: (value) => setState(() {
                  _pageIndex = value;
                }),
                titleCallback: (value) => setState(() {
                  _workoutTitle = value;
                }),
              );
            case 1:
              return NewWorkoutMainMuscleGroupScreen(
                mainMuscleGroupCallback: (value) => setState(() {
                  _selectedMainMuscleGroup = value;
                }),
              );
            case 2:
              return NewWorkoutEquipmentRequiredScreen(
                equipmentRequiredCallback: (value) => setState(() {
                  _selectedEquipmentRequired = value;
                }),
              );
            case 3:
              return NewWorkoutDifficultyAndMoreScreen(
                discriptionCallback: (value) => setState(() {
                  _description = value;
                }),
                difficultyCallback: (value) => setState(() {
                  _difficultySlider = value;
                }),
                secondsPerRepCallback: (value) => setState(() {
                  _secondsPerRepSlider = value;
                }),
                locationCallback: (value) => setState(() {
                  _location = value;
                }),
              );
            default:
              return null;
          }
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    if (_pageIndex == 3) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.done, color: Colors.white),
        backgroundColor: PrimaryColor,
        label: Text(S.current.finish, style: ButtonText),
        onPressed: saveDifficulty,
      );
    } else {
      return FloatingActionButton(
        backgroundColor: PrimaryColor,
        onPressed: (_pageIndex == 0)
            ? saveTitle
            : (_pageIndex == 1)
                ? saveMainMuscleGroup
                : (_pageIndex == 2)
                    ? saveEquipmentRequired
                    : saveDifficulty,
        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
      );
    }
  }
}
