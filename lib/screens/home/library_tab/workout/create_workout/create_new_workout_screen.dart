import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/classes/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../workout_detail_screen.dart';
import 'new_workout_difficulty_and_more_screen.dart';
import 'new_workout_equipment_required_screen.dart';
import 'new_workout_main_muscle_group_screen.dart';
import 'new_workout_title_screen.dart';

class CreateNewWorkoutScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final User user;

  const CreateNewWorkoutScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateNewWorkoutScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _CreateNewWorkoutScreenState createState() => _CreateNewWorkoutScreenState();
}

class _CreateNewWorkoutScreenState extends State<CreateNewWorkoutScreen> {
  late String _workoutTitle;
  String _description = '';
  List _selectedMainMuscleGroup = [];
  List _selectedEquipmentRequired = [];
  double _difficultySlider = 0;
  double _secondsPerRepSlider = 3;
  String _location = 'Location.gym';

  int _pageIndex = 0;

  // Submit data to Firestore
  Future<void> _submit() async {
    try {
      final id = 'WK${Uuid().v1()}';
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
        workoutId: id,
        workoutOwnerId: userId,
        workoutOwnerUserName: userName,
        workoutTitle: _workoutTitle,
        mainMuscleGroup: _selectedMainMuscleGroup,
        secondaryMuscleGroup: [],
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
        translated: {
          'de': 'Name des Trainings',
          'en': 'Workout Title',
          'es': 'Nombre del entrenamiento',
          'fr': 'Nom de l\'entraînement',
          'ko': '운동 이름'
        },
        tags: [],
      );
      await widget.database.setWorkout(workout);

      await WorkoutDetailScreen.show(
        context,
        workout: workout,
        tag: 'newWorkout-${workout.workoutId}',
        isRoot: true,
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

  void saveTitle() {
    if (_workoutTitle.isNotEmpty) {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        leading: const AppBarCloseButton(),
        title: Text(
          (_pageIndex == 0)
              ? S.current.workoutName
              : (_pageIndex == 1)
                  ? S.current.mainMuscleGroup
                  : (_pageIndex == 2)
                      ? S.current.equipmentRequired
                      : S.current.moreAboutThisWorkout,
          style: TextStyles.subtitle2,
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
              return Container();
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
        backgroundColor: kPrimaryColor,
        label: Text(S.current.finish, style: TextStyles.button1),
        onPressed: _submit,
      );
    } else {
      return FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: (_pageIndex == 0)
            ? saveTitle
            : (_pageIndex == 1)
                ? saveMainMuscleGroup
                : (_pageIndex == 2)
                    ? saveEquipmentRequired
                    : _submit,
        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
      );
    }
  }
}
