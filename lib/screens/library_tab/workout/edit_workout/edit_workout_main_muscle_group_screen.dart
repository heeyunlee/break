import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

class EditWorkoutMainMuscleGroupScreen extends StatefulWidget {
  const EditWorkoutMainMuscleGroupScreen({
    Key? key,
    required this.workout,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Workout workout;
  final Database database;
  final User user;

  static Future<void> show(
    BuildContext context, {
    required Workout workout,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditWorkoutMainMuscleGroupScreen(
          database: database,
          workout: workout,
          user: user,
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

    // TODO: MAKE THIS BETTER
    var mainMuscleGroup = <String, bool>{
      MainMuscleGroup.abs.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.abs.toString()))
          ? true
          : false,
      MainMuscleGroup.arms.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.arms.toString()))
          ? true
          : false,
      MainMuscleGroup.back.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.back.toString()))
          ? true
          : false,
      MainMuscleGroup.cardio.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.cardio.toString()))
          ? true
          : false,
      MainMuscleGroup.chest.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.chest.toString()))
          ? true
          : false,
      MainMuscleGroup.fullBody.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.fullBody.toString()))
          ? true
          : false,
      MainMuscleGroup.glutes.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.glutes.toString()))
          ? true
          : false,
      MainMuscleGroup.hamstring.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.hamstring.toString()))
          ? true
          : false,
      MainMuscleGroup.lats.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.lats.toString()))
          ? true
          : false,
      MainMuscleGroup.lowerBody.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.lowerBody.toString()))
          ? true
          : false,
      MainMuscleGroup.lowerBack.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.lowerBack.toString()))
          ? true
          : false,
      MainMuscleGroup.quads.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.quads.toString()))
          ? true
          : false,
      MainMuscleGroup.shoulder.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.shoulder.toString()))
          ? true
          : false,
      MainMuscleGroup.stretch.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.stretch.toString()))
          ? true
          : false,
      MainMuscleGroup.traps.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.traps.toString()))
          ? true
          : false,
    };
    _mainMuscleGroup = mainMuscleGroup;
    _mainMuscleGroup.forEach((key, value) {
      if (_mainMuscleGroup[key]!) {
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
    if (_mainMuscleGroup[key]!) {
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
      logger.e(e);
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
      backgroundColor: kBackgroundColor,
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
        title: Text(S.current.mainMuscleGroup, style: kSubtitle1),
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
                    .translation!;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color:
                          (_mainMuscleGroup[key]!) ? kPrimaryColor : kGrey700,
                      child: CheckboxListTile(
                        selected: _mainMuscleGroup[key]!,
                        activeColor: kPrimary700Color,
                        title: Text(title, style: kButtonText),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _mainMuscleGroup[key],
                        onChanged: (bool? value) => _addOrRemoveMainMuscleGroup(
                          key,
                          value!,
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
