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
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_difficulty_and_mre_screen.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_equipment_required_screen.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_main_muscle_group.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/new_routine_title_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import '../routine_detail_screen.dart';

Logger logger = Logger();

class CreateNewRoutineScreen extends StatefulWidget {
  const CreateNewRoutineScreen({
    Key key,
    @required this.database,
    this.user,
    @required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userDocument(auth.currentUser.uid);

    await HapticFeedback.mediumImpact();
    await pushNewScreen(
      context,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
      withNavBar: false,
      screen: CreateNewRoutineScreen(
        database: database,
        auth: auth,
        user: user,
      ),
    );
  }

  @override
  _CreateNewRoutineScreenState createState() => _CreateNewRoutineScreenState();
}

class _CreateNewRoutineScreenState extends State<CreateNewRoutineScreen> {
  String _routineTitle;
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
    final userName = widget.user.userName;
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

      // print(imageUrl);

      await widget.database.setRoutine(routine);
      await Navigator.of(context, rootNavigator: false).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => RoutineDetailScreen(
            routine: routine,
            auth: widget.auth,
            database: widget.database,
            tag: 'newRoutine-${routine.routineId}',
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
    if (_routineTitle != null && _routineTitle != '') {
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
      backgroundColor: BackgroundColor,
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
          style: Subtitle2,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: Builder(builder: (BuildContext context) {
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
            return null;
        }
      }),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    if (_pageIndex == 3) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.done, color: Colors.white),
        backgroundColor: PrimaryColor,
        label: Text(S.current.finish, style: ButtonText),
        onPressed: saveDifficultyAndMore,
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
                    : saveDifficultyAndMore,
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
      );
    }
  }
}
