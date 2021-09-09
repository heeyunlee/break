import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

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

    // TODO: Refactor edit_workout_main_muscle_group_screen
    final mainMuscleGroup = <String, bool>{
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.abs.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.abs.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.arms.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.arms.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.back.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.back.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.cardio.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.cardio.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.chest.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.chest.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.fullBody.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.fullBody.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.glutes.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.glutes.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.hamstring.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.hamstring.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.lats.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.lats.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.lowerBody.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.lowerBody.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.lowerBack.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.lowerBack.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.quads.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.quads.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.shoulder.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.shoulder.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      MainMuscleGroup.stretch.toString(): (widget.workout.mainMuscleGroup
              .contains(MainMuscleGroup.stretch.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
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
  }

  Future<void> _submit() async {
    if (_selectedMainMuscleGroup.isNotEmpty) {
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
        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateMainMuscleGroupTitle,
          S.current.updateMainMuscleGroupMessage(S.current.workout),
        );
      } on FirebaseException catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.mainMuscleGroupAlertTitle,
        content: S.current.mainMuscleGroupAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: _submit,
        ),
        title: Text(S.current.mainMuscleGroup, style: TextStyles.subtitle1),
        flexibleSpace: const AppbarBlurBG(),
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
                        title: Text(title, style: TextStyles.button1),
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
