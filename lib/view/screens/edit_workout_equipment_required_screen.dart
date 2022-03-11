import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/workout.dart';

class EditWorkoutEquipmentRequiredScreen extends ConsumerStatefulWidget {
  const EditWorkoutEquipmentRequiredScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final Workout workout;

  static void show(
    BuildContext context, {
    required Workout workout,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => EditWorkoutEquipmentRequiredScreen(
        workout: workout,
      ),
    );
  }

  @override
  _EditWorkoutEquipmentRequiredScreenState createState() =>
      _EditWorkoutEquipmentRequiredScreenState();
}

class _EditWorkoutEquipmentRequiredScreenState
    extends ConsumerState<EditWorkoutEquipmentRequiredScreen> {
  Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;
  final List _selectedEquipmentRequired = [];

  @override
  void initState() {
    super.initState();

    // TODO: fix edit_workout_equipment_required_screen
    final equipmentRequired = <String, bool>{
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.band.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.band.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.barbell.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.barbell.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.bench.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.bench.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.bodyweight.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.bodyweight.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.cable.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.cable.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.chains.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.chains.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.dumbbell.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.dumbbell.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.eZBar.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.eZBar.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.gymBall.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.gymBall.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.kettlebell.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.kettlebell.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.machine.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.machine.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.plate.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.plate.toString()))
          ? true
          : false,
      // ignore: avoid_bool_literals_in_conditional_expressions
      EquipmentRequired.other.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.other.toString()))
          ? true
          : false,
    };
    _equipmentRequired = equipmentRequired;
    _equipmentRequired.forEach((key, value) {
      if (_equipmentRequired[key]!) {
        _selectedEquipmentRequired.add(key);
      } else {
        _selectedEquipmentRequired.remove(key);
      }
    });
  }

  void _addOrRemoveEquipmentRequired(String key, bool value) {
    setState(() {
      _equipmentRequired[key] = value;
    });
    if (_equipmentRequired[key]!) {
      _selectedEquipmentRequired.add(key);
    } else {
      _selectedEquipmentRequired.remove(key);
    }
  }

  Future<void> _submit() async {
    if (_selectedEquipmentRequired.isNotEmpty) {
      try {
        final workout = {
          'equipmentRequired': _selectedEquipmentRequired,
        };
        final database = ref.watch(databaseProvider);
        await database.updateWorkout(widget.workout, workout);

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateEquipmentRequiredTitle,
          S.current.updateEquipmentRequiredMessage(S.current.workout),
        );
      } on FirebaseException catch (e) {
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.equipmentRequiredAlertTitle,
        content: S.current.equipmentRequiredAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: AppBarBackButton(onPressed: _submit),
        title: Text(S.current.equipmentRequired, style: TextStyles.subtitle1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _equipmentRequired.keys.map((String key) {
                final title = EquipmentRequired.values
                    .firstWhere((e) => e.toString() == key)
                    .translation!;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (_equipmentRequired[key]!)
                          ? theme.primaryColor
                          : theme.cardTheme.color,
                      child: CheckboxListTile(
                        selected: _equipmentRequired[key]!,
                        activeColor: theme.primaryColorDark,
                        title: Text(title, style: TextStyles.button1),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _equipmentRequired[key],
                        onChanged: (bool? value) =>
                            _addOrRemoveEquipmentRequired(
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
