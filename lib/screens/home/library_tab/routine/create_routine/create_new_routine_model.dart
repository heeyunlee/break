import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/classes/enum/unit_of_mass.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/classes/enum/difficulty.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/screens/home/home_screen_model.dart';
import 'package:workout_player/screens/home/library_tab/routine/create_routine/choose_equipment_required_screen.dart';
import 'package:workout_player/screens/home/library_tab/routine/create_routine/choose_main_muscle_group_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import '../routine_detail_screen_model.dart';
import 'choose_more_settings_screen.dart';

final createNewROutineModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CreateNewRoutineModel(),
);

class CreateNewRoutineModel with ChangeNotifier {
  late AuthBase? auth;
  late Database? database;

  CreateNewRoutineModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  late TextEditingController _textEditingController;
  bool _isButtonPressed = false;
  String _location = 'Location.gym';
  double _routineDifficulty = 0;
  String _routineDifficultyLabel = Difficulty.values[0].translation!;
  final Map<String, bool> _mainMuscleGroupMap = MainMuscleGroup.values[0].map;
  final Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;

  final List<MainMuscleGroup> _selectedMainMuscleGroupEnum = [];
  final List<EquipmentRequired> _selectedEquipmentRequiredEnum = [];

  TextEditingController get textEditingController => _textEditingController;
  bool get isButtonPressed => _isButtonPressed;
  String get location => _location;
  double get routineDifficulty => _routineDifficulty;
  String get routineDifficultyLabel => _routineDifficultyLabel;
  Map<String, bool> get mainMuscleGroupMap => _mainMuscleGroupMap;
  Map<String, bool> get equipmentRequired => _equipmentRequired;

  List<MainMuscleGroup> get selectedMainMuscleGroupEnum =>
      _selectedMainMuscleGroupEnum;
  List<EquipmentRequired> get selectedEquipmentRequiredEnum =>
      _selectedEquipmentRequiredEnum;

  void init() {
    _textEditingController = TextEditingController();
  }

  /// Submit data to Firestore
  bool _validateAndSaveForm() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? validator(String? value) {
    if (value == null) {
      return S.current.emptyRoutineTitleWarningMessage;
    } else if (value.isEmpty) {
      return S.current.emptyRoutineTitleWarningMessage;
    }
    return null;
  }

  void onChangedMuscleGroup(bool? value, MainMuscleGroup muscle) {
    if (value!) {
      _selectedMainMuscleGroupEnum.add(muscle);
    } else {
      _selectedMainMuscleGroupEnum.remove(muscle);
    }
    notifyListeners();
  }

  void onChangedEquipment(bool? value, EquipmentRequired muscle) {
    if (value!) {
      _selectedEquipmentRequiredEnum.add(muscle);
    } else {
      _selectedEquipmentRequiredEnum.remove(muscle);
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

  void saveTitle(BuildContext context, CreateNewRoutineModel model) {
    if (_validateAndSaveForm()) {
      ChooseMainMuscleGroupScreen.showMainMuscleGroup(context, model: model);
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

  void saveMainMuscleGroup(BuildContext context, CreateNewRoutineModel model) {
    if (_selectedMainMuscleGroupEnum.isNotEmpty) {
      ChooseEquipmentRequiredScreen.showEquipmentRequired(context,
          model: model);
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

  void saveEquipmentRequired(
      BuildContext context, CreateNewRoutineModel model) {
    if (_selectedEquipmentRequiredEnum.isNotEmpty) {
      ChooseMoreSettingsScreen.showMoreSettings(context, model: model);
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

  Future<void> submitToFirestore(BuildContext context) async {
    _isButtonPressed = true;

    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;

    try {
      final id = Uuid().v1();
      final userId = user.userId;
      final displayName = user.displayName;
      final initialUnitOfMass = user.unitOfMass;
      final unitOfMassEnum =
          user.unitOfMassEnum ?? UnitOfMass.values[user.unitOfMass ?? 0];
      final lastEditedDate = Timestamp.now();
      final routineCreatedDate = Timestamp.now();

      // Get Image Url
      final bucket = FirebaseStorage.instance.ref().child(
            'workout-pictures/800by800',
          );
      final imageIndex = Random().nextInt(2);
      final enumToString = EnumToString.convertToString(
        _selectedMainMuscleGroupEnum[0],
      );
      final ref = bucket.child('$enumToString$imageIndex.jpeg');
      final imageUrl = await ref.getDownloadURL();

      // Create New Routine
      final routine = Routine(
        routineId: 'RT$id',
        routineOwnerId: userId,
        routineOwnerUserName: displayName,
        routineTitle: _textEditingController.text,
        lastEditedDate: lastEditedDate,
        routineCreatedDate: routineCreatedDate,
        mainMuscleGroup: null,
        secondMuscleGroup: null,
        equipmentRequired: null,
        imageUrl: imageUrl,
        trainingLevel: _routineDifficulty.toInt(),
        duration: 0,
        totalWeights: 0,
        averageTotalCalories: 0,
        isPublic: true,
        initialUnitOfMass: initialUnitOfMass,
        location: _location,
        mainMuscleGroupEnum: _selectedMainMuscleGroupEnum,
        equipmentRequiredEnum: _selectedEquipmentRequiredEnum,
        unitOfMassEnum: unitOfMassEnum,
      );

      await database!.setRoutine(routine);

      final model = context.read(homeScreenModelProvider);
      final currentContext =
          model.tabNavigatorKeys[model.currentTab]!.currentContext!;

      Navigator.of(context).popUntil((route) => route.isFirst);

      await RoutineDetailScreenModel.show(
        currentContext,
        routine: routine,
        tag: 'createRoutine${routine.routineId}',
        isPushReplacement: false,
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

  // FORM KEY
  static final formKey = GlobalKey<FormState>();
}
