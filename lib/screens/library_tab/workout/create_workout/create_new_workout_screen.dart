import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
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
    final user = await database.userStream(userId: auth.currentUser.uid).first;

    HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateNewWorkoutScreen(
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );
  }

  @override
  _CreateNewWorkoutScreenState createState() => _CreateNewWorkoutScreenState();
}

class _CreateNewWorkoutScreenState extends State<CreateNewWorkoutScreen> {
  String _workoutTitle;
  String _description = '';
  List _selectedMainMuscleGroup = List();
  List _selectedEquipmentRequired = List();
  double _difficultySlider = 2;
  double _secondsPerRepSlider = 2;

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
      final isBodyWeightWorkout =
          (_selectedEquipmentRequired.contains('Bodyweight')) ? true : false;

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
      );
      await widget.database.setWorkout(workout);
      await Navigator.of(context, rootNavigator: false).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            database: widget.database,
            user: widget.auth.currentUser,
            tag: 'newWorkout-${workout.workoutId}',
          ),
        ),
      );
      // WorkoutDetailScreen.show(
      //   context,
      //   isRootNavigation: true,
      //   workout: workout,
      //   tag: 'newWorkout-${workout.workoutId}',
      // );
    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
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
        title: 'No routine title',
        content: 'Give routine a name!',
        defaultActionText: 'OK',
      );
    }
  }

  void saveMainMuscleGroup() {
    debugPrint('saveMainMuscleGroup Pressed');
    setState(() {
      _pageIndex = 2;
    });
  }

  // void saveSecondMuscleGroup() {
  //   debugPrint('saveMainMuscleGroup Pressed');
  //   if (_selectedSecondMuscleGroup.length > 0) {
  //     setState(() {
  //       _pageIndex = 3;
  //     });
  //   } else {
  //     showAlertDialog(
  //       context,
  //       title: 'Secondary Muscle Group',
  //       content: 'Select at least 1 secondary muscle group',
  //       defaultActionText: 'OK',
  //     );
  //   }
  // }

  void saveEquipmentRequired() {
    debugPrint('saveEquipmentRequired Pressed');
    if (_selectedEquipmentRequired.length > 0) {
      setState(() {
        _pageIndex = 3;
      });
    } else {
      showAlertDialog(
        context,
        title: 'Select Equipment Required',
        content: 'Select at least 1 Equipment for the routine',
        defaultActionText: 'OK',
      );
    }
  }

  void saveDifficulty() {
    debugPrint('saveDifficulty Pressed');
    if (_difficultySlider != null) {
      _submit();
    } else {
      showAlertDialog(
        context,
        title: 'No Difficulty',
        content: 'Select routine\'s difficulty!',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Create New Workout Screen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          (_pageIndex == 0)
              ? 'Workout Name'
              : (_pageIndex == 1)
                  ? 'Main Muscle Group'
                  : (_pageIndex == 2)
                      ? 'Equipment Required'
                      : 'More About This Workout',
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
                discriptionCallBack: (value) => setState(() {
                  _description = value;
                }),
                difficultyCallback: (value) => setState(() {
                  _difficultySlider = value;
                }),
                secondsPerRepCallback: (value) => setState(() {
                  _secondsPerRepSlider = value;
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
        label: const Text('Finish!', style: ButtonText),
        onPressed: saveDifficulty,
      );
    } else {
      return FloatingActionButton(
        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        backgroundColor: PrimaryColor,
        onPressed: (_pageIndex == 0)
            ? saveTitle
            : (_pageIndex == 1)
                ? saveMainMuscleGroup
                : (_pageIndex == 2)
                    ? saveEquipmentRequired
                    : saveDifficulty,
      );
    }
  }
}
