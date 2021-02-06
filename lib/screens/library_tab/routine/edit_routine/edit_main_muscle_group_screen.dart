import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

class EditMainMuscleGroupScreen extends StatefulWidget {
  const EditMainMuscleGroupScreen({
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
        builder: (context) => EditMainMuscleGroupScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditMainMuscleGroupScreenState createState() =>
      _EditMainMuscleGroupScreenState();
}

class _EditMainMuscleGroupScreenState extends State<EditMainMuscleGroupScreen> {
  Map<String, bool> _mainMuscleGroup = {
    'Chest': false,
    'Shoulder': false,
    'Leg': false,
    'Back': false,
    'Abs': false,
    'Arms': false,
    'Full Body': false,
    'Cardio': false,
  };
  List _selectedMainMuscleGroup = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, bool> mainMuscleGroup = {
      'Chest':
          (widget.routine.mainMuscleGroup.contains('Chest')) ? true : false,
      'Shoulder':
          (widget.routine.mainMuscleGroup.contains('Shoulder')) ? true : false,
      'Leg': (widget.routine.mainMuscleGroup.contains('Leg')) ? true : false,
      'Back': (widget.routine.mainMuscleGroup.contains('Back')) ? true : false,
      'Abs': (widget.routine.mainMuscleGroup.contains('Abs')) ? true : false,
      'Arms': (widget.routine.mainMuscleGroup.contains('Arms')) ? true : false,
      'Full Body':
          (widget.routine.mainMuscleGroup.contains('Full Body')) ? true : false,
      'Cardio':
          (widget.routine.mainMuscleGroup.contains('Cardio')) ? true : false,
    };
    _mainMuscleGroup = mainMuscleGroup;
    _mainMuscleGroup.forEach((key, value) {
      if (_mainMuscleGroup[key]) {
        _selectedMainMuscleGroup.add(key);
      } else {
        _selectedMainMuscleGroup.remove(key);
      }
      print(_selectedMainMuscleGroup);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _addOrRemoveMainMuscleGroup(String key, bool value) async {
    setState(() {
      _mainMuscleGroup[key] = value;
    });
    if (_mainMuscleGroup[key]) {
      _selectedMainMuscleGroup.add(key);
      final routine = {
        'mainMuscleGroup': _selectedMainMuscleGroup,
      };
      await widget.database.updateRoutine(widget.routine, routine);
    } else {
      _selectedMainMuscleGroup.remove(key);
      final routine = {
        'mainMuscleGroup': _selectedMainMuscleGroup,
      };
      await widget.database.updateRoutine(widget.routine, routine);
    }
    print(_selectedMainMuscleGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Main Muscle Group', style: Subtitle1),
        flexibleSpace: widget.routine == null ? null : AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
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
