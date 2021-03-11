import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditRoutineEquipmentRequiredScreen extends StatefulWidget {
  const EditRoutineEquipmentRequiredScreen({
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
        builder: (context) => EditRoutineEquipmentRequiredScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
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
  // Map<String, bool> _equipmentRequired = {
  //   'Barbell': false,
  //   'Dumbbell': false,
  //   'Bodyweight': false,
  //   'Cable': false,
  //   'Machine': false,
  //   'EZ Bar': false,
  //   'Gym ball': false,
  //   'Bench': false,
  // };
  Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;
  final List _selectedEquipmentRequired = [];

  @override
  void initState() {
    super.initState();
    var equipmentRequired = <String, bool>{
      'Barbell':
          (widget.routine.equipmentRequired.contains('Barbell')) ? true : false,
      'Bench':
          (widget.routine.equipmentRequired.contains('Bench')) ? true : false,
      'Bodyweight': (widget.routine.equipmentRequired.contains('Bodyweight'))
          ? true
          : false,
      'Cable':
          (widget.routine.equipmentRequired.contains('Cable')) ? true : false,
      'Chains':
          (widget.routine.equipmentRequired.contains('Chains')) ? true : false,
      'Dumbbell': (widget.routine.equipmentRequired.contains('Dumbbell'))
          ? true
          : false,
      'EZ Bar':
          (widget.routine.equipmentRequired.contains('EZ Bar')) ? true : false,
      'Gym ball': (widget.routine.equipmentRequired.contains('Gym ball'))
          ? true
          : false,
      'Kettlebell': (widget.routine.equipmentRequired.contains('Kettlebell'))
          ? true
          : false,
      'Machine':
          (widget.routine.equipmentRequired.contains('Machine')) ? true : false,
      'Others':
          (widget.routine.equipmentRequired.contains('Others')) ? true : false,
    };
    _equipmentRequired = equipmentRequired;
    _equipmentRequired.forEach((key, value) {
      if (_equipmentRequired[key]) {
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
    if (_equipmentRequired[key]) {
      _selectedEquipmentRequired.add(key);
    } else {
      _selectedEquipmentRequired.remove(key);
    }

    debugPrint('$_selectedEquipmentRequired');
  }

  Future<void> _submit() async {
    try {
      final routine = {
        'equipmentRequired': _selectedEquipmentRequired,
      };
      await widget.database.updateRoutine(widget.routine, routine);
      debugPrint('$_selectedEquipmentRequired');
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
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
            if (_selectedEquipmentRequired.isNotEmpty) {
              _submit();
              Navigator.of(context).pop();
            } else {
              showAlertDialog(
                context,
                title: 'No Equipment Required Selected',
                content:
                    'Please Select at least one equipment required for this routine',
                defaultActionText: 'OK',
              );
            }
          },
        ),
        title: const Text('Equipment Required', style: Subtitle1),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _equipmentRequired.keys.map((String key) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (_equipmentRequired[key]) ? PrimaryColor : Grey700,
                      child: CheckboxListTile(
                        selected: _equipmentRequired[key],
                        activeColor: Primary700Color,
                        title: Text(key, style: ButtonText),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _equipmentRequired[key],
                        onChanged: (bool value) =>
                            _addOrRemoveEquipmentRequired(key, value),
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