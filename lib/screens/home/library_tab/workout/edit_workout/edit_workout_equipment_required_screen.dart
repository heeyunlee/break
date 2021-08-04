import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class EditWorkoutEquipmentRequiredScreen extends StatefulWidget {
  const EditWorkoutEquipmentRequiredScreen({
    Key? key,
    required this.workout,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Workout workout;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context,
      {required Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditWorkoutEquipmentRequiredScreen(
          database: database,
          workout: workout,
          user: user,
        ),
      ),
    );
  }

  @override
  _EditWorkoutEquipmentRequiredScreenState createState() =>
      _EditWorkoutEquipmentRequiredScreenState();
}

class _EditWorkoutEquipmentRequiredScreenState
    extends State<EditWorkoutEquipmentRequiredScreen> {
  Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;
  final List _selectedEquipmentRequired = [];

  @override
  void initState() {
    super.initState();

    // TODO: MAKE THIS BETTER
    var equipmentRequired = <String, bool>{
      EquipmentRequired.band.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.band.toString()))
          ? true
          : false,
      EquipmentRequired.barbell.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.barbell.toString()))
          ? true
          : false,
      EquipmentRequired.bench.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.bench.toString()))
          ? true
          : false,
      EquipmentRequired.bodyweight.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.bodyweight.toString()))
          ? true
          : false,
      EquipmentRequired.cable.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.cable.toString()))
          ? true
          : false,
      EquipmentRequired.chains.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.chains.toString()))
          ? true
          : false,
      EquipmentRequired.dumbbell.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.dumbbell.toString()))
          ? true
          : false,
      EquipmentRequired.eZBar.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.eZBar.toString()))
          ? true
          : false,
      EquipmentRequired.gymBall.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.gymBall.toString()))
          ? true
          : false,
      EquipmentRequired.kettlebell.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.kettlebell.toString()))
          ? true
          : false,
      EquipmentRequired.machine.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.machine.toString()))
          ? true
          : false,
      EquipmentRequired.plate.toString(): (widget.workout.equipmentRequired
              .contains(EquipmentRequired.plate.toString()))
          ? true
          : false,
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
        await widget.database.updateWorkout(widget.workout, workout);

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateEquipmentRequiredTitle,
          S.current.updateEquipmentRequiredMessage(S.current.workout),
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
        title: S.current.equipmentRequiredAlertTitle,
        content: S.current.equipmentRequiredAlertContent,
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
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: _submit,
        ),
        title: Text(S.current.equipmentRequired, style: TextStyles.subtitle1),
        flexibleSpace: AppbarBlurBG(),
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
                      color:
                          (_equipmentRequired[key]!) ? kPrimaryColor : kGrey700,
                      child: CheckboxListTile(
                        selected: _equipmentRequired[key]!,
                        activeColor: kPrimary700Color,
                        title: Text(title, style: TextStyles.button1),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _equipmentRequired[key],
                        onChanged: (bool? value) =>
                            _addOrRemoveEquipmentRequired(key, value!),
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
