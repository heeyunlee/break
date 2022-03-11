import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'workout_detail_screen.dart';
import 'new_workout_difficulty_and_more_screen.dart';
import 'new_workout_equipment_required_screen.dart';
import 'new_workout_main_muscle_group_screen.dart';
import 'new_workout_title_screen.dart';

class CreateNewWorkoutScreen extends ConsumerStatefulWidget {
  const CreateNewWorkoutScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) {
        return const CreateNewWorkoutScreen();
      },
    );
  }

  @override
  _CreateNewWorkoutScreenState createState() => _CreateNewWorkoutScreenState();
}

class _CreateNewWorkoutScreenState
    extends ConsumerState<CreateNewWorkoutScreen> {
  late String _workoutTitle;
  String _description = '';
  List _selectedMainMuscleGroup = [];
  List _selectedEquipmentRequired = [];
  double _difficultySlider = 0;
  double _secondsPerRepSlider = 3;
  String _location = 'Location.gym';

  int _pageIndex = 0;

  // Submit data to Firestore
  Future<void> _submit(Database database) async {
    try {
      final uid = database.uid!;
      final user = await database.getUserDocument(uid);
      final id = 'WK${const Uuid().v1()}';
      final userId = user!.userId;
      final userName = user.displayName;
      final lastEditedDate = Timestamp.now();
      final workoutCreatedDate = Timestamp.now();
      final bool isBodyWeightWorkout;
      if (_selectedEquipmentRequired
          .contains(EquipmentRequired.bodyweight.toString())) {
        isBodyWeightWorkout = true;
      } else {
        isBodyWeightWorkout = false;
      }

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
          'fr': 'Nom de lentraînement',
          'ko': '운동 이름'
        },
        tags: [],
      );
      await database.setWorkout(workout);

      WorkoutDetailScreen.show(
        context,
        workout: workout,
        workoutId: workout.workoutId,
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
      appBar: AppBar(
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
        elevation: 0,
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
    final database = ref.watch(databaseProvider);

    if (_pageIndex == 3) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.done, color: Colors.white),
        label: Text(S.current.finish, style: TextStyles.button1),
        onPressed: () => _submit(database),
      );
    } else {
      return FloatingActionButton(
        onPressed: (_pageIndex == 0)
            ? saveTitle
            : (_pageIndex == 1)
                ? saveMainMuscleGroup
                : (_pageIndex == 2)
                    ? saveEquipmentRequired
                    : () => _submit(database),
        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
      );
    }
  }
}
