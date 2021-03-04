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
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditRoutineMainMuscleGroupScreen extends StatefulWidget {
  const EditRoutineMainMuscleGroupScreen({
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
        builder: (context) => EditRoutineMainMuscleGroupScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditRoutineMainMuscleGroupScreenState createState() =>
      _EditRoutineMainMuscleGroupScreenState();
}

class _EditRoutineMainMuscleGroupScreenState
    extends State<EditRoutineMainMuscleGroupScreen> {
  // MainMuscleGroup _mainMuscleGroup;
  Map<String, bool> _mainMuscleGroup = MainMuscleGroup.values[0].map;
  List _selectedMainMuscleGroup = List();

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i < MainMuscleGroup.values.length; i++) {
    //   if (MainMuscleGroup.values[i].label == widget.routine.mainMuscleGroup)
    //     _mainMuscleGroup = MainMuscleGroup.values[i];
    // }
    Map<String, bool> mainMuscleGroup = {
      'Abs': (widget.routine.mainMuscleGroup.contains('Abs')) ? true : false,
      'Arms': (widget.routine.mainMuscleGroup.contains('Arms')) ? true : false,
      'Cardio':
          (widget.routine.mainMuscleGroup.contains('Cardio')) ? true : false,
      'Chest':
          (widget.routine.mainMuscleGroup.contains('Chest')) ? true : false,
      'Full Body':
          (widget.routine.mainMuscleGroup.contains('Full Body')) ? true : false,
      'Glutes':
          (widget.routine.mainMuscleGroup.contains('Glutes')) ? true : false,
      'Hamstring':
          (widget.routine.mainMuscleGroup.contains('Hamstring')) ? true : false,
      'Lats': (widget.routine.mainMuscleGroup.contains('Lats')) ? true : false,
      'Leg': (widget.routine.mainMuscleGroup.contains('Leg')) ? true : false,
      'Lower Back': (widget.routine.mainMuscleGroup.contains('Lower Back'))
          ? true
          : false,
      'Quads':
          (widget.routine.mainMuscleGroup.contains('Quads')) ? true : false,
      'Shoulder':
          (widget.routine.mainMuscleGroup.contains('Shoulder')) ? true : false,
      'Stretch':
          (widget.routine.mainMuscleGroup.contains('Stretch')) ? true : false,
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

      final routine = {
        'imageUrl': imageUrl,
        'mainMuscleGroup': _selectedMainMuscleGroup,
      };
      await widget.database.updateRoutine(widget.routine, routine);
      debugPrint('$_selectedMainMuscleGroup');
    } on Exception catch (e) {
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
            if (_selectedMainMuscleGroup.length >= 1) {
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
  }
}
