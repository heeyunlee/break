import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditWorkoutSecondMuscleGroupScreen extends StatefulWidget {
  const EditWorkoutSecondMuscleGroupScreen({
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
        builder: (context) => EditWorkoutSecondMuscleGroupScreen(
          database: database,
          workout: workout,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditWorkoutSecondMuscleGroupScreenState createState() =>
      _EditWorkoutSecondMuscleGroupScreenState();
}

class _EditWorkoutSecondMuscleGroupScreenState
    extends State<EditWorkoutSecondMuscleGroupScreen> {
  Map<String, bool> _secondMuscleGroup = {
    'Abductors': false,
    'Adductors': false,
    'Biceps': false,
    'Calves': false,
    'Chest': false,
    'Forearms': false,
    'Glutes': false,
    'Hamstring': false,
    'Hip Flexors': false,
    'IT Band': false,
    'Lats': false,
    'Lower Back': false,
    'Upper Back': false,
    'Neck': false,
    'Obliques': false,
    'Quads': false,
    'Shoulders': false,
    'Traps': false,
    'Triceps': false,
  };
  List _selectedSecondMuscleGroup = [];

  @override
  void initState() {
    super.initState();
    Map<String, bool> secondMuscleGroup = {
      'Abductors': (widget.workout.secondaryMuscleGroup.contains('Abductors'))
          ? true
          : false,
      'Adductors': (widget.workout.secondaryMuscleGroup.contains('Adductors'))
          ? true
          : false,
      'Biceps': (widget.workout.secondaryMuscleGroup.contains('Biceps'))
          ? true
          : false,
      'Calves': (widget.workout.secondaryMuscleGroup.contains('Calves'))
          ? true
          : false,
      'Chest': (widget.workout.secondaryMuscleGroup.contains('Chest'))
          ? true
          : false,
      'Forearms': (widget.workout.secondaryMuscleGroup.contains('Forearms'))
          ? true
          : false,
      'Glutes': (widget.workout.secondaryMuscleGroup.contains('Glutes'))
          ? true
          : false,
      'Hamstring': (widget.workout.secondaryMuscleGroup.contains('Hamstring'))
          ? true
          : false,
      'Hip Flexors':
          (widget.workout.secondaryMuscleGroup.contains('Hip Flexors'))
              ? true
              : false,
      'IT Band': (widget.workout.secondaryMuscleGroup.contains('IT Band'))
          ? true
          : false,
      'Lats':
          (widget.workout.secondaryMuscleGroup.contains('Lats')) ? true : false,
      'Lower Back': (widget.workout.secondaryMuscleGroup.contains('Lower Back'))
          ? true
          : false,
      'Upper Back': (widget.workout.secondaryMuscleGroup.contains('Upper Back'))
          ? true
          : false,
      'Neck':
          (widget.workout.secondaryMuscleGroup.contains('Neck')) ? true : false,
      'Obliques': (widget.workout.secondaryMuscleGroup.contains('Obliques'))
          ? true
          : false,
      'Quads': (widget.workout.secondaryMuscleGroup.contains('Quads'))
          ? true
          : false,
      'Shoulders': (widget.workout.secondaryMuscleGroup.contains('Shoulders'))
          ? true
          : false,
      'Traps': (widget.workout.secondaryMuscleGroup.contains('Traps'))
          ? true
          : false,
      'Triceps': (widget.workout.secondaryMuscleGroup.contains('Triceps'))
          ? true
          : false,
    };
    _secondMuscleGroup = secondMuscleGroup;
    _secondMuscleGroup.forEach((key, value) {
      if (_secondMuscleGroup[key]) {
        _selectedSecondMuscleGroup.add(key);
      } else {
        _selectedSecondMuscleGroup.remove(key);
      }
    });
  }

  Future<void> _addOrRemoveSecondMuscleGroup(String key, bool value) async {
    try {
      setState(() {
        _secondMuscleGroup[key] = value;
      });
      if (_secondMuscleGroup[key]) {
        _selectedSecondMuscleGroup.add(key);
        final workout = {
          'secondaryMuscleGroup': _selectedSecondMuscleGroup,
        };
        await widget.database.updateWorkout(widget.workout, workout);
      } else {
        _selectedSecondMuscleGroup.remove(key);
        final workout = {
          'secondaryMuscleGroup': _selectedSecondMuscleGroup,
        };
        await widget.database.updateWorkout(widget.workout, workout);
      }
      print(_selectedSecondMuscleGroup);
    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
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
            if (_selectedSecondMuscleGroup.length >= 1) {
              Navigator.of(context).pop();
            } else {
              showAlertDialog(
                context,
                title: 'No Second Muscle Group Selected',
                content: 'Please Select at least one second muscle group',
                defaultActionText: 'OK',
              );
            }
          },
        ),
        title: const Text('Second Muscle Group', style: Subtitle1),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _secondMuscleGroup.keys.map((String key) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (_secondMuscleGroup[key]) ? PrimaryColor : Grey700,
                      child: CheckboxListTile(
                        selected: _secondMuscleGroup[key],
                        activeColor: Primary700Color,
                        title: Text(key, style: ButtonText),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _secondMuscleGroup[key],
                        onChanged: (bool value) =>
                            _addOrRemoveSecondMuscleGroup(key, value),
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
