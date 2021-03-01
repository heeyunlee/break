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
import 'package:workout_player/models/enum_values.dart';
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
    final user = await database.userStream(userId: auth.currentUser.uid).first;

    HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateNewRoutineScreen(
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );
  }

  @override
  _CreateNewRoutineScreenState createState() => _CreateNewRoutineScreenState();
}

class _CreateNewRoutineScreenState extends State<CreateNewRoutineScreen> {
  String _routineTitle;
  MainMuscleGroup _mainMuscleGroup;
  List _selectedEquipmentRequired = List();
  double _rating;

  int _pageIndex = 0;

  // Map<String, bool> _secondMuscleGroup = {
  //   'Abductors': false,
  //   'Adductors': false,
  //   'Abs': false,
  //   'Biceps': false,
  //   'Calves': false,
  //   'Chest': false,
  //   'Forearms': false,
  //   'Glutes': false,
  //   'Hamstring': false,
  //   'Hip Flexors': false,
  //   'IT Band': false,
  //   'Lats': false,
  //   'Lower Back': false,
  //   'Upper Back': false,
  //   'Neck': false,
  //   'Obliques': false,
  //   'Quads': false,
  //   'Shoulders': false,
  //   'Traps': false,
  //   'Triceps': false,
  // };
  // List _selectedSecondMuscleGroup = List();

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
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final String label = _mainMuscleGroup.label;
      final imageIndex = Random().nextInt(2);
      final imageUrl =
          await ref.child('$label$imageIndex.jpeg').getDownloadURL();

      // Create New Routine
      final routine = Routine(
        routineId: routineId,
        routineOwnerId: userId,
        routineOwnerUserName: userName,
        routineTitle: _routineTitle,
        lastEditedDate: lastEditedDate,
        routineCreatedDate: routineCreatedDate,
        mainMuscleGroup: _mainMuscleGroup.label,
        secondMuscleGroup: null,
        equipmentRequired: _selectedEquipmentRequired,
        imageUrl: imageUrl,
        trainingLevel: _rating.toInt(),
        duration: 0,
        totalWeights: 0,
        averageTotalCalories: 0,
        isPublic: true,
        initialUnitOfMass: initialUnitOfMass,
      );

      await widget.database.setRoutine(routine).then((value) {
        Navigator.of(context).pop();
      });

      RoutineDetailScreen.show(
        context,
        routine: routine,
        isRootNavigation: false,
        tag: 'newRoutine-${routine.routineId}',
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

  void saveTitle() {
    debugPrint('saveTitle Pressed');
    if (_routineTitle != null && _routineTitle != '') {
      setState(() {
        _pageIndex = 1;
      });
    } else {
      showAlertDialog(
        context,
        title: 'No routine Title!',
        content: 'Please Add a routine title',
        defaultActionText: 'OK',
      );
    }
  }

  void saveMainMuscleGroup() {
    debugPrint('saveMainMuscleGroup Pressed');
    if (_mainMuscleGroup != null) {
      setState(() {
        _pageIndex = 2;
      });
    } else {
      showAlertDialog(
        context,
        title: 'Main Muscle Group',
        content: 'Select at least 1 main muscle group',
        defaultActionText: 'OK',
      );
    }
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
        title: 'Select Equipment needed',
        content: 'Select at least 1 Equipment for this routine',
        defaultActionText: 'OK',
      );
    }
  }

  void saveDifficultyAndMore() {
    debugPrint('saveDifficultyAndMore Pressed');
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building scaffold...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
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
              ? 'Routine Title'
              : (_pageIndex == 1)
                  ? 'Main Muscle Group'
                  : (_pageIndex == 2)
                      ? 'Equipment Required'
                      : 'Difficulty and More',
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
                _mainMuscleGroup = value;
              }),
            );
          // case 2:
          //   return _selectSecondMuscleGroup();
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
            );
          default:
            return null;
        }
      }),
      floatingActionButton: _buildFAB(),
    );
  }

  // Widget _selectSecondMuscleGroup() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: <Widget>[
  //         ListView(
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           children: _secondMuscleGroup.keys.map((String key) {
  //             return Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Container(
  //                   color: (_secondMuscleGroup[key]) ? PrimaryColor : Grey700,
  //                   child: CheckboxListTile(
  //                     activeColor: Primary700Color,
  //                     title: Text(key, style: ButtonText),
  //                     controlAffinity: ListTileControlAffinity.trailing,
  //                     value: _secondMuscleGroup[key],
  //                     onChanged: (bool value) {
  //                       setState(() {
  //                         _secondMuscleGroup[key] = value;
  //                       });
  //                       if (_secondMuscleGroup[key]) {
  //                         _selectedSecondMuscleGroup.add(key);
  //                       } else {
  //                         _selectedSecondMuscleGroup.remove(key);
  //                       }
  //                       print(_selectedSecondMuscleGroup);
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFAB() {
    if (_pageIndex == 3) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.done, color: Colors.white),
        backgroundColor: PrimaryColor,
        label: const Text('Finish!', style: ButtonText),
        onPressed: saveDifficultyAndMore,
      );
    } else {
      return FloatingActionButton(
        backgroundColor: PrimaryColor,
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
        onPressed: (_pageIndex == 0)
            ? saveTitle
            : (_pageIndex == 1)
                ? saveMainMuscleGroup
                : (_pageIndex == 2)
                    ? saveEquipmentRequired
                    : saveDifficultyAndMore,
      );
    }
  }
}
