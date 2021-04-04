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
import 'package:workout_player/generated/l10n.dart';
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
  Map<String, bool> _mainMuscleGroup = MainMuscleGroup.values[0].map;
  final List _selectedMainMuscleGroup = [];

  @override
  void initState() {
    super.initState();
    var mainMuscleGroup = <String, bool>{
      MainMuscleGroup.abs.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.abs.toString()))
          ? true
          : false,
      MainMuscleGroup.arms.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.arms.toString()))
          ? true
          : false,
      MainMuscleGroup.cardio.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.cardio.toString()))
          ? true
          : false,
      MainMuscleGroup.chest.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.chest.toString()))
          ? true
          : false,
      MainMuscleGroup.fullBody.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.fullBody.toString()))
          ? true
          : false,
      MainMuscleGroup.glutes.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.glutes.toString()))
          ? true
          : false,
      MainMuscleGroup.hamstring.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.hamstring.toString()))
          ? true
          : false,
      MainMuscleGroup.lats.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.lats.toString()))
          ? true
          : false,
      MainMuscleGroup.lowerBody.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.lowerBody.toString()))
          ? true
          : false,
      MainMuscleGroup.lowerBack.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.lowerBack.toString()))
          ? true
          : false,
      MainMuscleGroup.quads.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.quads.toString()))
          ? true
          : false,
      MainMuscleGroup.shoulder.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.shoulder.toString()))
          ? true
          : false,
      MainMuscleGroup.stretch.toString(): (widget.routine.mainMuscleGroup
              .contains(MainMuscleGroup.stretch.toString()))
          ? true
          : false,
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
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
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
        brightness: Brightness.dark,
        centerTitle: true,
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
                title: S.current.mainMuscleGroupAlertTitle,
                content: S.current.mainMuscleGroupAlertContent,
                defaultActionText: S.current.ok,
              );
            }
          },
        ),
        title: Text(S.current.mainMuscleGroup, style: Subtitle1),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _mainMuscleGroup.keys.map((String key) {
                final title = MainMuscleGroup.values
                    .firstWhere((e) => e.toString() == key)
                    .translation;

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
                        title: Text(title, style: ButtonText),
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
