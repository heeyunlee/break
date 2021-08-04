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
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class EditRoutineEquipmentRequiredScreen extends StatefulWidget {
  const EditRoutineEquipmentRequiredScreen({
    Key? key,
    required this.routine,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static Future<void> show(
    BuildContext context, {
    required Routine routine,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditRoutineEquipmentRequiredScreen(
          database: database,
          routine: routine,
          user: user,
        ),
      ),
    );
  }

  @override
  _EditRoutineEquipmentRequiredScreenState createState() =>
      _EditRoutineEquipmentRequiredScreenState();
}

class _EditRoutineEquipmentRequiredScreenState
    extends State<EditRoutineEquipmentRequiredScreen> {
  Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;
  final List _selectedEquipmentRequired = [];

  @override
  void initState() {
    super.initState();
    // TODO: MAKE THIS BETTER
    final list = widget.routine.equipmentRequired ?? [];

    var equipmentRequired = <String, bool>{
      EquipmentRequired.band.toString():
          (list.contains(EquipmentRequired.band.toString())) ? true : false,
      EquipmentRequired.barbell.toString():
          (list.contains(EquipmentRequired.barbell.toString())) ? true : false,
      EquipmentRequired.bench.toString():
          (list.contains(EquipmentRequired.bench.toString())) ? true : false,
      EquipmentRequired.bodyweight.toString():
          (list.contains(EquipmentRequired.bodyweight.toString()))
              ? true
              : false,
      EquipmentRequired.cable.toString():
          (list.contains(EquipmentRequired.cable.toString())) ? true : false,
      EquipmentRequired.chains.toString():
          (list.contains(EquipmentRequired.chains.toString())) ? true : false,
      EquipmentRequired.dumbbell.toString():
          (list.contains(EquipmentRequired.dumbbell.toString())) ? true : false,
      EquipmentRequired.eZBar.toString():
          (list.contains(EquipmentRequired.eZBar.toString())) ? true : false,
      EquipmentRequired.gymBall.toString():
          (list.contains(EquipmentRequired.gymBall.toString())) ? true : false,
      EquipmentRequired.kettlebell.toString():
          (list.contains(EquipmentRequired.kettlebell.toString()))
              ? true
              : false,
      EquipmentRequired.machine.toString():
          (list.contains(EquipmentRequired.machine.toString())) ? true : false,
      EquipmentRequired.plate.toString():
          (list.contains(EquipmentRequired.plate.toString())) ? true : false,
      EquipmentRequired.other.toString():
          (list.contains(EquipmentRequired.other.toString())) ? true : false,
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

  @override
  void dispose() {
    super.dispose();
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
        final routine = {
          'equipmentRequired': _selectedEquipmentRequired,
        };
        await widget.database.updateRoutine(widget.routine, routine);

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateEquipmentRequiredTitle,
          S.current.updateEquipmentRequiredMessage(S.current.routine),
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
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
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
                    .translation;

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
                        title: Text(title!, style: TextStyles.button1),
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
