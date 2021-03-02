import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/main_muscle_group.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditWorkoutMainMuscleGroupScreen extends StatefulWidget {
  const EditWorkoutMainMuscleGroupScreen({
    Key key,
    this.workout,
    this.database,
    this.user,
  }) : super(key: key);

  final Workout workout;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context, {Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditWorkoutMainMuscleGroupScreen(
          database: database,
          workout: workout,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditWorkoutMainMuscleGroupScreenState createState() =>
      _EditWorkoutMainMuscleGroupScreenState();
}

class _EditWorkoutMainMuscleGroupScreenState
    extends State<EditWorkoutMainMuscleGroupScreen> {
  // MainMuscleGroup _mainMuscleGroup;
  Map<String, bool> _mainMuscleGroup = MainMuscleGroup.values[0].map;
  List _selectedMainMuscleGroup = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // for (var i = 0; i < MainMuscleGroup.values.length; i++) {
    //   if (MainMuscleGroup.values[i].label == widget.workout.mainMuscleGroup)
    //     _mainMuscleGroup = MainMuscleGroup.values[i];
    // }
    Map<String, bool> mainMuscleGroup = {
      'Abs': (widget.workout.mainMuscleGroup.contains('Abs')) ? true : false,
      'Arms': (widget.workout.mainMuscleGroup.contains('Arms')) ? true : false,
      'Cardio':
          (widget.workout.mainMuscleGroup.contains('Cardio')) ? true : false,
      'Chest':
          (widget.workout.mainMuscleGroup.contains('Chest')) ? true : false,
      'Full Body':
          (widget.workout.mainMuscleGroup.contains('Full Body')) ? true : false,
      'Glutes':
          (widget.workout.mainMuscleGroup.contains('Glutes')) ? true : false,
      'Hamstring':
          (widget.workout.mainMuscleGroup.contains('Hamstring')) ? true : false,
      'Lats': (widget.workout.mainMuscleGroup.contains('Lats')) ? true : false,
      'Leg': (widget.workout.mainMuscleGroup.contains('Leg')) ? true : false,
      'Lower Back': (widget.workout.mainMuscleGroup.contains('Lower Back'))
          ? true
          : false,
      'Quads':
          (widget.workout.mainMuscleGroup.contains('Quads')) ? true : false,
      'Shoulder':
          (widget.workout.mainMuscleGroup.contains('Shoulder')) ? true : false,
      'Stretch':
          (widget.workout.mainMuscleGroup.contains('Stretch')) ? true : false,
    };
    _mainMuscleGroup = mainMuscleGroup;
    _mainMuscleGroup.forEach((key, value) {
      if (_mainMuscleGroup[key]) {
        _selectedMainMuscleGroup.add(key);
      } else {
        _selectedMainMuscleGroup.remove(key);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addOrRemoveMainMuscleGroup(String key, bool value) async {
    try {
      setState(() {
        _mainMuscleGroup[key] = value;
      });
      if (_mainMuscleGroup[key]) {
        _selectedMainMuscleGroup.add(key);
      } else {
        _selectedMainMuscleGroup.remove(key);
      }

      // Image URL
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final imageIndex = Random().nextInt(2);
      final imageUrl = await ref
          .child('${_selectedMainMuscleGroup[0]}$imageIndex.jpeg')
          .getDownloadURL();

      final workout = {
        'imageUrl': imageUrl,
        'mainMuscleGroup': _selectedMainMuscleGroup,
      };
      await widget.database.updateWorkout(widget.workout, workout);
      debugPrint('$_selectedMainMuscleGroup');
    } on FirebaseException catch (e) {
      logger.d(e);
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  Future<void> updateMainMuscleGroup() async {
    // Get Image Url
    try {
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final imageIndex = Random().nextInt(2);
      final imageUrl = await ref
          .child('${_selectedMainMuscleGroup[0]}$imageIndex.jpeg')
          .getDownloadURL();

      final workout = {
        'imageUrl': imageUrl,
        'mainMuscleGroup': _selectedMainMuscleGroup,
      };

      await widget.database.updateWorkout(widget.workout, workout);
    } on Exception catch (e) {
      logger.d(e);
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            if (_selectedMainMuscleGroup.length >= 1) {
              Navigator.of(context).pop();
            } else {
              showAlertDialog(
                context,
                title: 'No Main Muscle Group Selected',
                content:
                    'Please Select at least one equipment required for this routine',
                defaultActionText: 'OK',
              );
            }
          },
        ),
        title: const Text(' Main Muscle Group', style: Subtitle1),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _mainMuscleGroup.keys.map((String key) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (_mainMuscleGroup[key]) ? PrimaryColor : Grey700,
                      child: CheckboxListTile(
                        selected: _mainMuscleGroup[key],
                        activeColor: Primary700Color,
                        title: Text(key, style: ButtonText),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _mainMuscleGroup[key],
                        onChanged: (bool value) =>
                            _addOrRemoveMainMuscleGroup(key, value),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: BackgroundColor,
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     leading: IconButton(
    //       icon: const Icon(
    //         Icons.arrow_back_rounded,
    //         color: Colors.white,
    //       ),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //     title: const Text('Main Muscle Group', style: Subtitle1),
    //     flexibleSpace: AppbarBlurBG(),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: <Widget>[
    //         Theme(
    //           data: ThemeData(
    //             unselectedWidgetColor: Colors.grey,
    //           ),
    //           child: ListView.builder(
    //             shrinkWrap: true,
    //             physics: const NeverScrollableScrollPhysics(),
    //             itemCount: MainMuscleGroup.values.length,
    //             itemBuilder: (context, index) => Padding(
    //               padding:
    //                   const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(10),
    //                 child: Container(
    //                   height: 56,
    //                   color: Grey700,
    //                   child: RadioListTile<MainMuscleGroup>(
    //                     title: Text(
    //                       '${MainMuscleGroup.values[index].label}',
    //                       style: ButtonText,
    //                     ),
    //                     activeColor: PrimaryColor,
    //                     value: MainMuscleGroup.values[index],
    //                     groupValue: _mainMuscleGroup,
    //                     onChanged: (MainMuscleGroup value) {
    //                       setState(() {
    //                         _mainMuscleGroup = value;
    //                         debugPrint('${_mainMuscleGroup.label}');
    //                         updateMainMuscleGroup();
    //                       });
    //                     },
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
