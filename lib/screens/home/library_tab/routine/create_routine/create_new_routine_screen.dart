import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/screens/home/home_screen_provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../routine_detail_screen.dart';
import 'create_new_routine_provider.dart';
import 'new_routine_difficulty_and_mre_screen.dart';
import 'new_routine_equipment_required_screen.dart';
import 'new_routine_main_muscle_group.dart';
import 'new_routine_title_screen.dart';

class CreateNewRoutineScreen extends StatefulWidget {
  const CreateNewRoutineScreen({
    Key? key,
    required this.database,
    required this.user,
    required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateNewRoutineScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _CreateNewRoutineScreenState createState() => _CreateNewRoutineScreenState();
}

class _CreateNewRoutineScreenState extends State<CreateNewRoutineScreen> {
  late String _routineTitle;
  List _selectedMainMuscleGroup = [];
  List _selectedEquipmentRequired = [];
  double _rating = 0;
  String _location = 'Location.gym';

  int _pageIndex = 0;

  // Submit data to Firestore
  Future<void> _submit(IsCreateRoutineButtonPressedNotifier isPressed) async {
    switch (_pageIndex) {
      case 0:
        return saveTitle();
      case 1:
        return saveMainMuscleGroup();
      case 2:
        return saveEquipmentRequired();
      case 3:
        return submitToFirestore(isPressed);
    }
  }

  void saveTitle() {
    logger.d('saveTitle Pressed');
    if (_routineTitle != '') {
      setState(() {
        _pageIndex = 1;
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.noRoutineAlertTitle,
        content: S.current.routineTitleValidatorText,
        defaultActionText: S.current.ok,
      );
    }
  }

  void saveMainMuscleGroup() {
    logger.d('saveMainMuscleGroup Pressed');
    if (_selectedMainMuscleGroup.isNotEmpty) {
      setState(() {
        _pageIndex = 2;
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.mainMuscleGroup,
        content: S.current.mainMuscleGroupAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  void saveEquipmentRequired() {
    logger.d('saveEquipmentRequired Pressed');
    if (_selectedEquipmentRequired.isNotEmpty) {
      setState(() {
        _pageIndex = 3;
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.equipmentRequired,
        content: S.current.equipmentRequiredAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  Future<void> submitToFirestore(
      IsCreateRoutineButtonPressedNotifier isPressed) async {
    logger.d('saveDifficultyAndMore Pressed');
    logger.d('_submit button pressed!');

    final routineId = documentIdFromCurrentDate();
    final userId = widget.user.userId;
    final userName = widget.user.displayName;
    final initialUnitOfMass = widget.user.unitOfMass;
    final lastEditedDate = Timestamp.now();
    final routineCreatedDate = Timestamp.now();

    try {
      isPressed.toggleBoolValue();

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
        routineId: 'RT$routineId',
        routineOwnerId: userId,
        routineOwnerUserName: userName,
        routineTitle: _routineTitle,
        lastEditedDate: lastEditedDate,
        routineCreatedDate: routineCreatedDate,
        mainMuscleGroup: _selectedMainMuscleGroup,
        secondMuscleGroup: null,
        equipmentRequired: _selectedEquipmentRequired,
        imageUrl: imageUrl,
        trainingLevel: _rating.toInt(),
        duration: 0,
        totalWeights: 0,
        averageTotalCalories: 0,
        isPublic: true,
        initialUnitOfMass: initialUnitOfMass,
        location: _location,
      );

      await widget.database.setRoutine(routine);

      Navigator.of(context).pop();
      await tabNavigatorKeys[currentTab]!.currentState!.push(
            CupertinoPageRoute(
              fullscreenDialog: false,
              builder: (context) => RoutineDetailScreen(
                routine: routine,
                auth: widget.auth,
                database: widget.database,
                user: widget.user,
                tag: 'newRoutine-${routine.routineId}',
              ),
            ),
          );
      isPressed.toggleBoolValue();

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
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('building create new routine scaffold...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
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
              ? S.current.routineTitleTitle
              : (_pageIndex == 1)
                  ? S.current.mainMuscleGroup
                  : (_pageIndex == 2)
                      ? S.current.equipmentRequired
                      : S.current.others,
          style: TextStyles.subtitle2,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          switch (_pageIndex) {
            case 0:
              return NewRoutineTitleScreen(
                titleCallback: (value) => setState(() {
                  _routineTitle = value;
                }),
                indexCallback: (value) => setState(() {
                  _pageIndex = value;
                }),
              );
            case 1:
              return NewRoutineMainMuscleGroupScreen(
                mainMuscleGroupCallback: (value) => setState(() {
                  _selectedMainMuscleGroup = value;
                }),
              );
            case 2:
              return NewRoutineEquipmentRequiredScreen(
                selectedEquipmentRequired: (value) => setState(() {
                  _selectedEquipmentRequired = value;
                }),
              );
            case 3:
              return NewRoutineDifficultyAndMoreScreen(
                ratingCallback: (value) => setState(() {
                  _rating = value;
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
    return Consumer(
      builder: (context, ref, child) {
        final isPressed = ref.watch(isCreateRoutineButtonPressedProvider);

        if (_pageIndex == 3) {
          return FloatingActionButton.extended(
            icon: const Icon(Icons.done, color: Colors.white),
            backgroundColor: kPrimaryColor,
            label: Text(S.current.finish, style: TextStyles.button1),
            onPressed:
                (isPressed.isButtonPressed) ? null : () => _submit(isPressed),
          );
        } else {
          return FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: () => _submit(isPressed),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
