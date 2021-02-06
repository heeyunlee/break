import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import '../routine_detail_screen.dart';

class CreateNewRoutineScreen extends StatefulWidget {
  const CreateNewRoutineScreen({
    Key key,
    @required this.database,
    this.user,
  }) : super(key: key);

  final Database database;
  final User user;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateNewRoutineScreen(
          database: database,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _CreateNewRoutineScreenState createState() => _CreateNewRoutineScreenState();
}

class _CreateNewRoutineScreenState extends State<CreateNewRoutineScreen> {
  String _routineTitle;
  var _textController1 = TextEditingController();

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
  Map<String, bool> _equipmentRequired = {
    'Barbell': false,
    'Dumbbell': false,
    'Bodyweight': false,
    'Cable': false,
    'Machine': false,
    'EZ Bar': false,
    'Gym ball': false,
    'Bench': false,
  };
  List _selectedEquipmentRequired = List();

  int _pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _routineTitle = null;
    _textController1 = TextEditingController(text: _routineTitle);
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    debugPrint('_submit button pressed!');
    final routineId = documentIdFromCurrentDate();
    final userId = widget.user.uid;
    final userName = widget.user.displayName;
    final date = Timestamp.now();
    final timestamp = Timestamp.now();
    final imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/workout-pictures%2Fpush_ups_preview.jpeg?alt=media&token=8485e262-baa9-4bff-80a1-31c05e5feb7a';
    final imageIndex = Random().nextInt(4);

    try {
      final routine = Routine(
        routineId: routineId,
        routineOwnerId: userId,
        routineOwnerUserName: userName,
        routineTitle: _routineTitle,
        lastEditedDate: timestamp,
        routineCreatedDate: date,
        mainMuscleGroup: _selectedMainMuscleGroup,
        secondMuscleGroup: _selectedSecondMuscleGroup,
        equipmentRequired: _selectedEquipmentRequired,
        imageUrl: imageUrl,
        imageIndex: imageIndex,
      );
      await widget.database.setRoutine(routine).then((value) {
        Navigator.of(context).pop();
        RoutineDetailScreen.show(
          context: context,
          routine: routine,
          isRootNavigation: false,
        );
      });
    } on FirebaseException catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  void saveTitle() {
    debugPrint('saveTitle Pressed');
    if (_routineTitle != null && _routineTitle != '') {
      setState(() {
        _pageIndex = 1;
      });
    } else {
      showAlertDialog(
        context,
        title: 'No routine Title!',
        content: 'Please Add a routine title',
        defaultActionText: 'OK',
      );
    }
  }

  void saveMainMuscleGroup() {
    debugPrint('saveMainMuscleGroup Pressed');
    if (_selectedMainMuscleGroup.length > 0) {
      setState(() {
        _pageIndex = 2;
      });
    } else {
      showAlertDialog(
        context,
        title: 'Main Muscle Group',
        content: 'Select at least 1 main muscle group',
        defaultActionText: 'OK',
      );
    }
  }

  void saveSecondMuscleGroup() {
    debugPrint('saveMainMuscleGroup Pressed');
    if (_selectedSecondMuscleGroup.length > 0) {
      setState(() {
        _pageIndex = 3;
      });
    } else {
      showAlertDialog(
        context,
        title: 'Secondary Muscle Group',
        content: 'Select at least 1 secondary muscle group',
        defaultActionText: 'OK',
      );
    }
  }

  void saveEquipmentRequired() {
    debugPrint('saveEquipmentRequired Pressed');
    if (_selectedEquipmentRequired.length > 0) {
      setState(() {
        _pageIndex = 4;
      });
      _submit();
    } else {
      showAlertDialog(
        context,
        title: 'Select Equipment needed',
        content: 'Select at least 1 Equipment for this routine',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          (_pageIndex == 0)
              ? 'Routine Title'
              : (_pageIndex == 1)
                  ? 'Main Muscle Group'
                  : (_pageIndex == 2)
                      ? 'Secondary Muscle Group'
                      : 'Equipment Required',
          style: Subtitle2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: AppbarBlurBG(),
      ),
      body: (_pageIndex == 0)
          ? _editTitleWidget()
          : (_pageIndex == 1)
              ? _selectMainMuscleGroupWidget()
              : (_pageIndex == 2)
                  ? _selectSecondMuscleGroup()
                  : _selectEquipmentRequired(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        child: Icon(
          (_pageIndex == 3) ? Icons.done : Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
        onPressed: (_pageIndex == 0)
            ? saveTitle
            : (_pageIndex == 1)
                ? saveMainMuscleGroup
                : (_pageIndex == 2)
                    ? saveSecondMuscleGroup
                    : saveEquipmentRequired,
      ),
    );
  }

  Widget _editTitleWidget() {
    return Center(
      child: Container(
        height: 48,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        padding: EdgeInsets.all(8),
        child: TextFormField(
          style: Headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          controller: _textController1,
          decoration: InputDecoration(
            hintStyle: SearchBarHintStyle,
            hintText: 'Give your routine a name',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: PrimaryColor),
            ),
          ),
          onChanged: (value) => setState(() {
            _routineTitle = value;
          }),
          onSaved: (value) => setState(() {
            _routineTitle = value;
          }),
          onFieldSubmitted: (value) => setState(() {
            _routineTitle = value;
            saveTitle();
          }),
        ),
      ),
    );
  }

  Widget _selectMainMuscleGroupWidget() {
    return SingleChildScrollView(
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
                      activeColor: Primary700Color,
                      title: Text(key, style: ButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _mainMuscleGroup[key],
                      onChanged: (bool value) {
                        setState(() {
                          _mainMuscleGroup[key] = value;
                        });
                        if (_mainMuscleGroup[key]) {
                          _selectedMainMuscleGroup.add(key);
                        } else {
                          _selectedMainMuscleGroup.remove(key);
                        }
                        print(_selectedMainMuscleGroup);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _selectSecondMuscleGroup() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _secondMuscleGroup.keys.map((String key) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: (_secondMuscleGroup[key]) ? PrimaryColor : Grey700,
                    child: CheckboxListTile(
                      activeColor: Primary700Color,
                      title: Text(key, style: ButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _secondMuscleGroup[key],
                      onChanged: (bool value) {
                        setState(() {
                          _secondMuscleGroup[key] = value;
                        });
                        if (_secondMuscleGroup[key]) {
                          _selectedSecondMuscleGroup.add(key);
                        } else {
                          _selectedSecondMuscleGroup.remove(key);
                        }
                        print(_selectedSecondMuscleGroup);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _selectEquipmentRequired() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView(
            physics: NeverScrollableScrollPhysics(),
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
                      activeColor: Primary700Color,
                      title: Text(key, style: ButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _equipmentRequired[key],
                      onChanged: (bool value) {
                        setState(() {
                          _equipmentRequired[key] = value;
                        });
                        if (_equipmentRequired[key]) {
                          _selectedEquipmentRequired.add(key);
                        } else {
                          _selectedEquipmentRequired.remove(key);
                        }
                        print(_selectedEquipmentRequired);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
