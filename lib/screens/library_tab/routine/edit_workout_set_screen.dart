import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class EditWorkoutSetScreen extends StatefulWidget {
  const EditWorkoutSetScreen({
    Key key,
    this.set,
    this.routine,
    this.routineWorkout,
    this.database,
  }) : super(key: key);

  final WorkoutSet set;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final Database database;

  static Future<void> show(
    BuildContext context, {
    WorkoutSet set,
    Routine routine,
    RoutineWorkout routineWorkout,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditWorkoutSetScreen(
          database: database,
          routine: routine,
          routineWorkout: routineWorkout,
          set: set,
        ),
      ),
    );
  }

  @override
  _EditWorkoutSetScreenState createState() => _EditWorkoutSetScreenState();
}

class _EditWorkoutSetScreenState extends State<EditWorkoutSetScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  FocusNode focusNode1;
  FocusNode focusNode2;
  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();
  var _textController3 = TextEditingController();

  String _setTitle;
  String _setWeights;
  String _setReps;
  Duration _restTime = Duration(minutes: 1, seconds: 30);
  int _start;
  bool cancelButtonDisabled;
  bool _isPaused;

  CountDownController _countDownController = CountDownController();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    focusNode1 = FocusNode();
    focusNode2 = FocusNode();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    cancelButtonDisabled = true;
    _isPaused = true;

    if (widget.set != null) {
      // Set Title
      _setTitle = widget.set.setTitle;
      _textController1 = TextEditingController(text: _setTitle);

      // Weights
      _setWeights = widget.set.weights.toString();
      _textController2 = TextEditingController(text: _setWeights);

      // Reps
      _setReps = widget.set.reps.toString();
      _textController3 = TextEditingController(text: _setReps);
    }
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
    // _animationController.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    print('submit Button Pressed');
    if (_validateAndSaveForm()) {
      print('_validateAndSaveForm is TRUE');
      try {
        if (widget.set != null) {
          print('Editing set');
          // // Edit Set
          // final set = WorkoutSet(
          //   workoutSetId: widget.set.workoutSetId,
          //   index: widget.set.index,
          //   isRest: widget.set.isRest,
          //   setTitle: _setTitle,
          //   weights: int.parse(_setWeights),
          //   reps: int.parse(_setReps),
          //   restTime: _restTime.inSeconds,
          // ).toMap();
          // final oldRoutineWorkout = {
          //   'index': widget.routineWorkout.index,
          //   'workoutId': widget.routineWorkout.workoutId,
          //   'workoutTitle': widget.routineWorkout.workoutTitle,
          //   'numberOfSets': widget.routineWorkout.numberOfSets,
          //   'numberOfReps': widget.routineWorkout.numberOfReps,
          //   'sets': FieldValue.arrayRemove([widget.set.toMap()]),
          // };
          // final newRoutineWorkout = {
          //   'index': widget.routineWorkout.index,
          //   'workoutId': widget.routineWorkout.workoutId,
          //   'workoutTitle': widget.routineWorkout.workoutTitle,
          //   'numberOfSets': widget.routineWorkout.numberOfSets,
          //   'numberOfReps': widget.routineWorkout.numberOfReps,
          //   'sets': FieldValue.arrayUnion([set]),
          // };
          // await widget.database.editWorkoutSet(
          //   widget.routine,
          //   widget.routineWorkout,
          //   oldRoutineWorkout,
          //   newRoutineWorkout,
          // );
          // Navigator.of(context).pop();
        } else {
          print('creating set');
          // Create new set
          final setLength = widget.routineWorkout.sets.length;
          final index = widget.set?.workoutSetId ?? setLength + 1;
          final id = widget.set?.workoutSetId ?? UniqueKey().toString();
          final restTime = _restTime.inSeconds;
          final set = WorkoutSet(
            workoutSetId: id,
            index: index,
            isRest: (_sliding == 0) ? false : true,
            setTitle: (_sliding == 0) ? _setTitle : '휴식',
            weights: (_sliding == 0) ? int.parse(_setWeights) : null,
            reps: (_sliding == 0) ? int.parse(_setReps) : null,
            restTime: (_sliding == 0) ? null : restTime,
          ).toMap();
          final routineWorkout = {
            'index': widget.routineWorkout.index,
            'workoutId': widget.routineWorkout.workoutId,
            'workoutTitle': widget.routineWorkout.workoutTitle,
            'numberOfSets': widget.routineWorkout.numberOfSets,
            'numberOfReps': widget.routineWorkout.numberOfReps,
            'sets': FieldValue.arrayUnion([set]),
          };
          await widget.database.setWorkoutSet(
            widget.routine,
            widget.routineWorkout,
            routineWorkout,
          );
          Navigator.of(context).pop();
          showFlushBar(
            context: context,
            message: (_sliding == 0) ? '세트를 추가했습니다.' : '휴식을 추가했습니다.',
          );
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
          (widget.set == null && _sliding == 0)
              ? '세트 추가하기'
              : (widget.set == null && _sliding == 1)
                  ? '휴식 추가하기'
                  : (widget.set != null && _sliding == 0)
                      ? '세트 수정하기'
                      : '휴식 수정하기',
          style: Subtitle1,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              (widget.set == null) ? 'ADD' : 'SAVE',
              style: ButtonText,
            ),
            onPressed: _submit,
          ),
        ],
        flexibleSpace: AppbarBlurBG(),
      ),
      body: _buildContents(),
    );
  }

  int _sliding = 0;

  Widget _buildContents() {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32),
          Container(
            width: size.width - 32,
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Text(
                  '세트',
                  style: TextStyle(
                    color: (_sliding == 0) ? Colors.black : Colors.white,
                  ),
                ),
                1: Text(
                  '휴식',
                  style: TextStyle(
                    color: (_sliding == 1) ? Colors.black : Colors.white,
                  ),
                ),
              },
              groupValue: _sliding,
              onValueChanged: (newValue) {
                setState(() {
                  _sliding = newValue;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: (_sliding == 0) ? _buildSetForm() : _buildRestForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSetForm() {
    return [
      /// Set Title
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController1,
        textAlign: TextAlign.center,
        style: BodyText1,
        decoration: new InputDecoration(
          labelText: '세트 제목',
          labelStyle: Subtitle2Grey,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: PrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        onEditingComplete: () => focusNode1.requestFocus(),
        validator: (value) => value.isNotEmpty ? null : '세트에 제목을 지어주세요!',
        onChanged: (value) => _setTitle = value,
        onFieldSubmitted: (value) => _setTitle = value,
        onSaved: (value) => _setTitle = value,
      ),
      SizedBox(height: 32),

      /// Weights
      TextFormField(
        focusNode: focusNode1,
        controller: _textController2,
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        style: BodyText1,
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: new InputDecoration(
          labelText: '무게: Kg',
          labelStyle: Subtitle2Grey,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: PrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        onEditingComplete: () => focusNode2.requestFocus(),
        onChanged: (value) => _setWeights = value,
        onFieldSubmitted: (value) => _setWeights = value,
        onSaved: (value) => _setWeights = value,
      ),
      SizedBox(height: 32),

      /// Reps
      TextFormField(
        focusNode: focusNode2,
        controller: _textController3,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: BodyText1,
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: new InputDecoration(
          labelText: '횟수: X',
          labelStyle: Subtitle2Grey,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: PrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        onChanged: (value) => _setReps = value,
        onFieldSubmitted: (value) => _setReps = value,
        onSaved: (value) => _setReps = value,
      ),
    ];
  }

  List<Widget> _buildRestForm() {
    final size = MediaQuery.of(context).size;

    return [
      if (_start == null)
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 42),
              CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    pickerTextStyle: BodyText1,
                  ),
                ),
                child: CupertinoTimerPicker(
                  alignment: Alignment.center,
                  onTimerDurationChanged: (value) => _restTime = value,
                  initialTimerDuration: _restTime,
                  mode: CupertinoTimerPickerMode.ms,
                ),
              ),
              SizedBox(height: 74),
            ],
          ),
        ),
      if (_start != null)
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularCountDownTimer(
                textStyle: Headline2,
                controller: _countDownController,
                width: 300,
                height: 300,
                duration: _restTime.inSeconds,
                fillColor: Grey800,
                color: Colors.red,
                backgroundColor: null,
                isReverse: true,
                strokeWidth: 8,
                onComplete: _submit,
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      Container(
        height: 48,
        child: RaisedButton(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedIcon(
                size: 32,
                color: Colors.white,
                icon: AnimatedIcons.play_pause,
                progress: _animationController,
              ),
              Center(
                child: Text(
                  (_isPaused) ? '시작' : '일지성지',
                  style: ButtonText,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: PrimaryColor,
          onPressed: () {
            setState(() {
              _start = _restTime.inSeconds;
              cancelButtonDisabled = false;
            });
            if (_isPaused) {
              _isPaused = !_isPaused;
              _animationController.forward();
              _countDownController.resume();
              print(_isPaused);
            } else {
              _isPaused = !_isPaused;
              _animationController.reverse();
              _countDownController.pause();
              print(_isPaused);
            }
          },
        ),
      ),
      SizedBox(height: 16),
      Container(
        height: 48,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: Grey700,
          disabledColor: Grey700,
          child: Text(
            '취소',
            style: (cancelButtonDisabled) ? ButtonTextGrey : ButtonText,
          ),
          onPressed: (cancelButtonDisabled)
              ? null
              : () {
                  if (!_isPaused) _animationController.reverse();
                  setState(() {
                    _start = null;
                    cancelButtonDisabled = true;
                    _isPaused = true;
                  });
                },
        ),
      ),
    ];
  }
}
