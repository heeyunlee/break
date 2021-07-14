import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/models/auth_and_database.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/home/home_screen_provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import '../routine_detail_screen.dart';

final createNewROutineModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CreateNewROutineModel(),
);

class CreateNewROutineModel with ChangeNotifier {
  late AuthBase? auth;
  late Database? database;

  CreateNewROutineModel({
    this.auth,
    this.database,
  });

  int _pageIndex = 0;
  String _routineTitle = '';
  late TextEditingController _textEditingController;
  final List<String> _selectedMainMuscleGroup = [];
  final List<String> _selectedEquipmentRequired = [];
  bool _isButtonPressed = false;
  String _location = 'Location.gym';
  double _routineDifficulty = 0;
  String _routineDifficultyLabel = Difficulty.values[0].translation!;
  final Map<String, bool> _mainMuscleGroupMap = MainMuscleGroup.values[0].map;
  final Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;

  int get pageIndex => _pageIndex;
  String? get routineTitle => _routineTitle;
  TextEditingController get textEditingController => _textEditingController;
  List<String> get selectedMainMuscleGroup => _selectedMainMuscleGroup;
  List<String> get selectedEquipmentRequired => _selectedEquipmentRequired;
  bool get isButtonPressed => _isButtonPressed;
  String get location => _location;
  double get routineDifficulty => _routineDifficulty;
  String get routineDifficultyLabel => _routineDifficultyLabel;
  Map<String, bool> get mainMuscleGroupMap => _mainMuscleGroupMap;
  Map<String, bool> get equipmentRequired => _equipmentRequired;

  void init(AuthAndDatabase authAndDatabase) {
    _textEditingController = TextEditingController();
    auth = authAndDatabase.auth;
    database = authAndDatabase.database;
  }

  void onChanged(String value) {
    _routineTitle = _textEditingController.text;
  }

  void onSaved(String? value) {
    _routineTitle = _textEditingController.text;
  }

  void onFieldSubmitted(String value) {
    _routineTitle = _textEditingController.text;

    _pageIndex = 1;

    notifyListeners();
  }

  void onChangedMainMuscle(bool? value, String key) {
    _mainMuscleGroupMap[key] = value!;

    if (_mainMuscleGroupMap[key]!) {
      _selectedMainMuscleGroup.add(key);
    } else {
      _selectedMainMuscleGroup.remove(key);
    }
    notifyListeners();
  }

  void onChangedEquipmentRequired(bool? value, String key) {
    _equipmentRequired[key] = value!;

    if (_equipmentRequired[key]!) {
      _selectedEquipmentRequired.add(key);
    } else {
      _selectedEquipmentRequired.remove(key);
    }
    notifyListeners();
  }

  void onChangedLocation(String? value) {
    _location = value.toString();

    notifyListeners();
  }

  void onChangedDifficulty(double value) {
    _routineDifficulty = value;
    _routineDifficultyLabel =
        Difficulty.values[_routineDifficulty.toInt()].translation!;

    notifyListeners();
  }

  // Submit data to Firestore
  Future<void> submit(BuildContext context) async {
    switch (_pageIndex) {
      case 0:
        return _saveTitle(context);
      case 1:
        return _saveMainMuscleGroup(context);
      case 2:
        return _saveEquipmentRequired(context);
      case 3:
        return _submitToFirestore(context);
    }
  }

  void _saveTitle(BuildContext context) {
    if (_routineTitle.isNotEmpty) {
      _pageIndex = 1;
    } else {
      showAlertDialog(
        context,
        title: S.current.noRoutineAlertTitle,
        content: S.current.routineTitleValidatorText,
        defaultActionText: S.current.ok,
      );
    }
    notifyListeners();
  }

  void _saveMainMuscleGroup(BuildContext context) {
    if (_selectedMainMuscleGroup.isNotEmpty) {
      _pageIndex = 2;
    } else {
      showAlertDialog(
        context,
        title: S.current.mainMuscleGroup,
        content: S.current.mainMuscleGroupAlertContent,
        defaultActionText: S.current.ok,
      );
    }
    notifyListeners();
  }

  void _saveEquipmentRequired(BuildContext context) {
    if (_selectedEquipmentRequired.isNotEmpty) {
      _pageIndex = 3;
    } else {
      showAlertDialog(
        context,
        title: S.current.equipmentRequired,
        content: S.current.equipmentRequiredAlertContent,
        defaultActionText: S.current.ok,
      );
    }
    notifyListeners();
  }

  Future<void> _submitToFirestore(BuildContext context) async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;

    final id = Uuid().v1();
    final userId = user.userId;
    final displayName = user.displayName;
    final initialUnitOfMass = user.unitOfMass;
    final lastEditedDate = Timestamp.now();
    final routineCreatedDate = Timestamp.now();

    _isButtonPressed = true;

    try {
      // Get Image Url
      final ref = FirebaseStorage.instance.ref().child(
            'workout-pictures/800by800',
          );
      final imageIndex = Random().nextInt(2);
      final imageUrl = await ref
          .child('${_selectedMainMuscleGroup[0]}${imageIndex}_800x800.jpeg')
          .getDownloadURL();

      // Create New Routine
      final routine = Routine(
        routineId: 'RT$id',
        routineOwnerId: userId,
        routineOwnerUserName: displayName,
        routineTitle: _routineTitle,
        lastEditedDate: lastEditedDate,
        routineCreatedDate: routineCreatedDate,
        mainMuscleGroup: _selectedMainMuscleGroup,
        secondMuscleGroup: null,
        equipmentRequired: _selectedEquipmentRequired,
        imageUrl: imageUrl,
        trainingLevel: _routineDifficulty.toInt(),
        duration: 0,
        totalWeights: 0,
        averageTotalCalories: 0,
        isPublic: true,
        initialUnitOfMass: initialUnitOfMass,
        location: _location,
      );

      await database!.setRoutine(routine);

      Navigator.of(context).pop();

      await RoutineDetailScreen.show(
        tabNavigatorKeys[currentTab]!.currentContext!,
        routine: routine,
        tag: 'createRoutine${routine.routineId}',
      );

      // TODO: add SnackBar

      // getSnackbarWidget(
      //   S.current.createNewRoutineSnackbarTitle,
      //   S.current.createNewRoutineSnackbar,
      // );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
    _isButtonPressed = false;
  }
}
