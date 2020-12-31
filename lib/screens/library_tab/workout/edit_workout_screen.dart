import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/appbar_blur_bg.dart';
import '../../../common_widgets/show_alert_dialog.dart';
import '../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../constants.dart';
import '../../../models/workout.dart';
import '../../../services/database.dart';

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({Key key, @required this.database, this.workout})
      : super(key: key);

  final Database database;
  final Workout workout;

  static Future<void> show(BuildContext context, {Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditWorkoutScreen(
          database: database,
          workout: workout,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // FocusScopeNode _focusScopeNode = FocusScopeNode();
  // final _controller1 = TextEditingController();
  // final _controller2 = TextEditingController();
  //
  // void _handleSubmitted(String value) {
  //   _focusScopeNode.nextFocus();
  // }

  String _workoutOwnerId;
  String _workoutTitle;
  String _mainMuscleGroup;
  List _secondaryMuscleGroup;
  String _description;
  String _equipmentRequired;
  String _imageUrl;
  // TODO: Add
  // String _forceType;
  // String _exerciseType;
  // String _mechanics;
  // String _experienceLevel;
  // String _instructions;
  // String _tips;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _workoutOwnerId = widget.workout.workoutOwnerId;
      _workoutTitle = widget.workout.workoutTitle;
      _mainMuscleGroup = widget.workout.mainMuscleGroup;
      _secondaryMuscleGroup = widget.workout.secondaryMuscleGroup;
      _description = widget.workout.description;
      _equipmentRequired = widget.workout.equipmentRequired;
      _imageUrl = widget.workout.imageUrl;
      // TODO: ADD
      // _forceType = widget.workout.forceType;
      // _exerciseType = widget.workout.exerciseType;
      // _mechanics = widget.workout.mechanics;
      // _experienceLevel = widget.workout.experienceLevel;
      // _instructions = widget.workout.instructions;
      // _tips = widget.workout.tips;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final workouts = await widget.database.workoutsStream().first;
        final allNames =
            workouts.map((workout) => workout.workoutTitle).toList();
        if (widget.workout != null) {
          allNames.remove(widget.workout.workoutTitle);
        }
        if (allNames.contains(_workoutTitle)) {
          showAlertDialog(
            context,
            title: '같은 이름의 운동이 존재해요',
            content: 'Please choose a different workout name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.workout?.workoutId ?? documentIdFromCurrentDate();
          final workout = Workout(
            workoutId: id,
            workoutOwnerId: _workoutOwnerId,
            workoutTitle: _workoutTitle,
            mainMuscleGroup: _mainMuscleGroup,
            secondaryMuscleGroup: _secondaryMuscleGroup,
            description: _description,
            equipmentRequired: _equipmentRequired,
            imageUrl: _imageUrl,
            // TODO: ADD
            // forceType: _forceType,
            // exerciseType: _exerciseType,
            // mechanics: _mechanics,
            // experienceLevel: _experienceLevel,
            // instructions: _instructions,
            // tips: _tips,
          );
          await widget.database.setWorkout(workout);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        ShowExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
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
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.workout == null ? '' : '운동 수정하기',
          style: Subtitle1,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('SAVE', style: ButtonText),
            onPressed: _submit,
          ),
        ],
        flexibleSpace: widget.workout == null ? null : AppbarBlurBG(),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: CardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FocusScope(
      // node: _focusScopeNode,
      child: Theme(
        data: ThemeData(
          primaryColor: PrimaryColor,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildFormChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    String dropdownValueMainMuscleGroup = _mainMuscleGroup;
    List dropdownValueSecondMuscleGroup = _secondaryMuscleGroup;
    String dropdownValueEquipment = _equipmentRequired;
    // String dropdownValueForceType = _forceType;
    // String dropdownValueExerciseType = _exerciseType;
    // String dropdownValueMechanics = _mechanics;
    // String dropdownExperienceLevel = _experienceLevel;

    return [
      /// Workout Title
      TextFormField(
        // controller: _controller1,
        style: BodyText2,
        autofocus: true,
        initialValue: _workoutTitle,
        decoration: InputDecoration(
          labelText: '운동 이름',
          labelStyle: Subtitle2Grey,
          hintText: 'ex) 스쿼트',
          hintStyle: BodyText2LightGrey,
        ),
        validator: (value) => value.isNotEmpty ? null : '운동에 이름을 지어 주세요!',
        // onFieldSubmitted: _handleSubmitted,
        onSaved: (value) => _workoutTitle = value,
      ),

      /// Main Muscle Group
      DropdownButtonFormField(
        value: dropdownValueMainMuscleGroup,
        decoration: InputDecoration(
          labelText: '주요 자극 부위',
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValueMainMuscleGroup = newValue;
          });
        },
        items: <String>[
          '가슴',
          '등',
          '팔',
          '복근',
          '하체',
          '어깨',
        ].map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toString()),
            );
          },
        ).toList(),
        onSaved: (value) => _mainMuscleGroup = value,
      ),

      // /// Second Muscle Group
      // DropdownButtonFormField(
      //   value: dropdownValueSecondMuscleGroup,
      //   decoration: InputDecoration(
      //     labelText: '보조 자극 부위',
      //   ),
      //   onChanged: (String newValue) {
      //     setState(() {
      //       dropdownValueSecondMuscleGroup = newValue;
      //     });
      //   },
      //   items: <String>[
      //     // TODO: Change Dropdown Menu Item
      //     'Shoulder',
      //     'b',
      //     'c',
      //     'd',
      //   ].map<DropdownMenuItem<String>>(
      //     (String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value.toString()),
      //       );
      //     },
      //   ).toList(),
      //   onSaved: (value) => _secondaryMuscleGroup = value,
      // ),

      /// Description
      TextFormField(
        initialValue: _description,
        decoration: InputDecoration(labelText: 'Description'),
        onSaved: (value) => _description = value,
      ),

      // Equipment Required
      DropdownButtonFormField(
        value: dropdownValueEquipment,
        decoration: InputDecoration(
          labelText: 'Equipment',
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValueEquipment = newValue;
          });
        },
        items: <String>[
          '바벨',
          '덤벨',
          '맨몸',
          '케이블',
          '헬스장 기구',
        ].map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toString()),
            );
          },
        ).toList(),
        onSaved: (value) => _equipmentRequired = value,
      ),

      /// Image Url
      TextFormField(
        initialValue: _imageUrl,
        decoration: InputDecoration(labelText: 'Image Url'),
        onSaved: (value) => _imageUrl = value,
      ),

      // // Force Type
      // DropdownButtonFormField(
      //   value: dropdownValueForceType,
      //   decoration: InputDecoration(
      //     labelText: 'Force Type',
      //   ),
      //   onChanged: (String newValue) {
      //     setState(() {
      //       dropdownValueForceType = newValue;
      //     });
      //   },
      //   items: <String>[
      //     // TODO: Change Dropdown Menu Item
      //     'a',
      //     'b',
      //     'c',
      //     'd',
      //   ].map<DropdownMenuItem<String>>(
      //     (String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value.toString()),
      //       );
      //     },
      //   ).toList(),
      //   onSaved: (value) => _forceType = value,
      // ),
      //
      // // Exercise Type
      // DropdownButtonFormField(
      //   value: dropdownValueExerciseType,
      //   decoration: InputDecoration(
      //     labelText: 'Exercise Type',
      //   ),
      //   onChanged: (String newValue) {
      //     setState(() {
      //       dropdownValueExerciseType = newValue;
      //     });
      //   },
      //   items: <String>[
      //     // TODO: Change Dropdown Menu Item
      //     'a',
      //     'b',
      //     'c',
      //     'd',
      //   ].map<DropdownMenuItem<String>>(
      //     (String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value.toString()),
      //       );
      //     },
      //   ).toList(),
      //   onSaved: (value) => _exerciseType = value,
      // ),
      //
      // // Mechanics
      // DropdownButtonFormField(
      //   value: dropdownValueMechanics,
      //   decoration: InputDecoration(
      //     labelText: 'Mechanics',
      //   ),
      //   onChanged: (String newValue) {
      //     setState(() {
      //       dropdownValueMechanics = newValue;
      //     });
      //   },
      //   items: <String>[
      //     // TODO: Change Dropdown Menu Item
      //     'a',
      //     'b',
      //     'c',
      //     'd',
      //   ].map<DropdownMenuItem<String>>(
      //     (String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value.toString()),
      //       );
      //     },
      //   ).toList(),
      //   onSaved: (value) => _mechanics = value,
      // ),
      //
      // // Experience Level
      // DropdownButtonFormField(
      //   value: dropdownExperienceLevel,
      //   decoration: InputDecoration(
      //     labelText: 'Experience Level',
      //   ),
      //   onChanged: (String newValue) {
      //     setState(() {
      //       dropdownExperienceLevel = newValue;
      //     });
      //   },
      //   items: <String>[
      //     // TODO: Change Dropdown Menu Item
      //     'a',
      //     'b',
      //     'c',
      //     'd',
      //   ].map<DropdownMenuItem<String>>(
      //     (String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value.toString()),
      //       );
      //     },
      //   ).toList(),
      //   onSaved: (value) => _experienceLevel = value,
      // ),
      //
      // // Instructions
      // TextFormField(
      //   initialValue: _instructions,
      //   decoration: InputDecoration(labelText: 'Instructions'),
      //   onSaved: (value) => _instructions = value,
      // ),
      //
      // // Tips
      // TextFormField(
      //   initialValue: _tips,
      //   decoration: InputDecoration(labelText: 'Tips'),
      //   onSaved: (value) => _tips = value,
      // ),
    ];
  }
}
