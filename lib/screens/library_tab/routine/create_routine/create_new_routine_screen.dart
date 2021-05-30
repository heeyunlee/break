import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_difficulty_and_mre_screen.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_equipment_required_screen.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_main_muscle_group.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_title_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import '../../../home_screen_provider.dart';
import '../routine_detail_screen.dart';

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
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

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
  Future<void> _submit() async {
    debugPrint('_submit button pressed!');
    final routineId = documentIdFromCurrentDate();
    final userId = widget.user.userId;
    final userName = widget.user.displayName;
    final initialUnitOfMass = widget.user.unitOfMass;
    final lastEditedDate = Timestamp.now();
    final routineCreatedDate = Timestamp.now();

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
    debugPrint('saveTitle Pressed');
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
    debugPrint('saveMainMuscleGroup Pressed');
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
    debugPrint('saveEquipmentRequired Pressed');
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

  void saveDifficultyAndMore() {
    debugPrint('saveDifficultyAndMore Pressed');
    _submit();
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
    debugPrint('building scaffold...');

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
          style: kSubtitle2,
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
    if (_pageIndex == 3) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.done, color: Colors.white),
        backgroundColor: kPrimaryColor,
        label: Text(S.current.finish, style: kButtonText),
        onPressed: saveDifficultyAndMore,
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
                    : saveDifficultyAndMore,
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
      );
    }
  }
}
