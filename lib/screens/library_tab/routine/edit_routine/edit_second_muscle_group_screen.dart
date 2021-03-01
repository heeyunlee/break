import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditSecondMuscleGroupScreen extends StatefulWidget {
  const EditSecondMuscleGroupScreen({
    Key key,
    this.routine,
    this.database,
    this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditSecondMuscleGroupScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditSecondMuscleGroupScreenState createState() =>
      _EditSecondMuscleGroupScreenState();
}

class _EditSecondMuscleGroupScreenState
    extends State<EditSecondMuscleGroupScreen> {
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
  List _selectedSecondMuscleGroup = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, bool> secondMuscleGroup = {
      'Abductors': (widget.routine.secondMuscleGroup.contains('Abductors'))
          ? true
          : false,
      'Adductors': (widget.routine.secondMuscleGroup.contains('Adductors'))
          ? true
          : false,
      'Biceps':
          (widget.routine.secondMuscleGroup.contains('Biceps')) ? true : false,
      'Calves':
          (widget.routine.secondMuscleGroup.contains('Calves')) ? true : false,
      'Chest':
          (widget.routine.secondMuscleGroup.contains('Chest')) ? true : false,
      'Forearms': (widget.routine.secondMuscleGroup.contains('Forearms'))
          ? true
          : false,
      'Glutes':
          (widget.routine.secondMuscleGroup.contains('Glutes')) ? true : false,
      'Hamstring': (widget.routine.secondMuscleGroup.contains('Hamstring'))
          ? true
          : false,
      'Hip Flexors': (widget.routine.secondMuscleGroup.contains('Hip Flexors'))
          ? true
          : false,
      'IT Band':
          (widget.routine.secondMuscleGroup.contains('IT Band')) ? true : false,
      'Lats':
          (widget.routine.secondMuscleGroup.contains('Lats')) ? true : false,
      'Lower Back': (widget.routine.secondMuscleGroup.contains('Lower Back'))
          ? true
          : false,
      'Upper Back': (widget.routine.secondMuscleGroup.contains('Upper Back'))
          ? true
          : false,
      'Neck':
          (widget.routine.secondMuscleGroup.contains('Neck')) ? true : false,
      'Obliques': (widget.routine.secondMuscleGroup.contains('Obliques'))
          ? true
          : false,
      'Quads':
          (widget.routine.secondMuscleGroup.contains('Quads')) ? true : false,
      'Shoulders': (widget.routine.secondMuscleGroup.contains('Shoulders'))
          ? true
          : false,
      'Traps':
          (widget.routine.secondMuscleGroup.contains('Traps')) ? true : false,
      'Triceps':
          (widget.routine.secondMuscleGroup.contains('Triceps')) ? true : false,
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addOrRemoveSecondMuscleGroup(String key, bool value) async {
    try {
      setState(() {
        _secondMuscleGroup[key] = value;
      });
      if (_secondMuscleGroup[key]) {
        _selectedSecondMuscleGroup.add(key);
        final routine = {
          'secondMuscleGroup': _selectedSecondMuscleGroup,
        };
        await widget.database.updateRoutine(widget.routine, routine);
      } else {
        _selectedSecondMuscleGroup.remove(key);
        final routine = {
          'secondMuscleGroup': _selectedSecondMuscleGroup,
        };
        await widget.database.updateRoutine(widget.routine, routine);
      }
      print(_selectedSecondMuscleGroup);
    } on FirebaseException catch (e) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
