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
import 'package:workout_player/models/enum/main_muscle_group.dart';
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
  Map<String, bool> _mainMuscleGroup = MainMuscleGroup.values[0].map;
  final List _selectedMainMuscleGroup = [];

  @override
  void initState() {
    super.initState();

    var mainMuscleGroup = <String, bool>{
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

  void _addOrRemoveMainMuscleGroup(String key, bool value) {
    setState(() {
      _mainMuscleGroup[key] = value;
    });
    if (_mainMuscleGroup[key]) {
      _selectedMainMuscleGroup.add(key);
    } else {
      _selectedMainMuscleGroup.remove(key);
    }

    debugPrint('$_selectedMainMuscleGroup');
  }

  Future<void> _submit() async {
    try {
      // Image URL
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final imageIndex = Random().nextInt(2);
      final imageUrl = await ref
          .child('${_selectedMainMuscleGroup[0]}$imageIndex.jpeg')
          .getDownloadURL();

      // New Workout Data
      final workout = {
        'imageUrl': imageUrl,
        'mainMuscleGroup': _selectedMainMuscleGroup,
      };

      await widget.database.updateWorkout(widget.workout, workout);
      debugPrint('$_selectedMainMuscleGroup');
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e.toString(),
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
            if (_selectedMainMuscleGroup.isNotEmpty) {
              _submit();
              Navigator.of(context).pop();
            } else {
              showAlertDialog(
                context,
                title: 'No Main Muscle Group Selected',
                content:
                    'Please Select at least one Main Muscle Group for this routine',
                defaultActionText: 'OK',
              );
            }
          },
        ),
        title: const Text('Main Muscle Group', style: Subtitle1),
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
                        onChanged: (bool value) => _addOrRemoveMainMuscleGroup(
                          key,
                          value,
                        ),
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
  }
}
