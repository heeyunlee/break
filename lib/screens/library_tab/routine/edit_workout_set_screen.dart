import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
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
  FocusNode focusNode3;
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
  // double _value = 25;
  int _setOrRest = 0;
  // int _slider = 0;

  CountDownController _countDownController = CountDownController();
  AnimationController _animationController;
  TabController tabController;

  @override
  void initState() {
    super.initState();

    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();

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
    focusNode3.dispose();
    super.dispose();
    _animationController.dispose();
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
    print('ADD Button Pressed');
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
            isRest: (_setOrRest == 0) ? false : true,
            setTitle: (_setOrRest == 0) ? _setTitle : '휴식',
            weights: (_setOrRest == 0) ? int.parse(_setWeights) : null,
            reps: (_setOrRest == 0) ? int.parse(_setReps) : null,
            restTime: (_setOrRest == 0) ? null : restTime,
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
          // Get.snackbar(null, (_setOrRest == 0) ? '세트를 추가했습니다.' : '휴식을 추가했습니다.');
          showFlushBar(
            context: context,
            message: (_setOrRest == 0) ? '세트를 추가했습니다.' : '휴식을 추가했습니다.',
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            (widget.set == null && _setOrRest == 0)
                ? '세트 추가하기'
                : (widget.set == null && _setOrRest == 1)
                    ? '휴식 추가하기'
                    : (widget.set != null && _setOrRest == 0)
                        ? '세트 수정하기'
                        : '휴식 수정하기',
            style: Subtitle1,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                (widget.set == null) ? '완료' : 'SAVE',
                style: ButtonText,
              ),
              onPressed: _submit,
            ),
          ],
          flexibleSpace: AppbarBlurBG(),
          bottom: TabBar(
            physics: NeverScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.start,
            controller: tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Grey400,
            indicatorColor: PrimaryColor,
            onTap: (_) {
              if (_setOrRest == 1) {
                setState(() {
                  _setOrRest = 0;
                  debugPrint('$_setOrRest');
                });
              } else {
                focusNode1.unfocus();
                focusNode2.unfocus();
                focusNode3.unfocus();
                setState(() {
                  _setOrRest = 1;
                  debugPrint('$_setOrRest');
                });
              }
            },
            tabs: [
              Tab(text: '세트'),
              Tab(text: '휴식'),
            ],
          ),
        ),
        body: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: Form(
        key: _formKey,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            _buildSetForm(),
            _buildRestForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildSetForm() {
    final size = MediaQuery.of(context).size;

    return KeyboardActions(
      config: _buildConfig(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),

              /// Set Title
              TextFormField(
                autocorrect: false,
                focusNode: focusNode1,
                textInputAction: TextInputAction.next,
                controller: _textController1,
                textAlign: TextAlign.center,
                style: BodyText1,
                decoration: new InputDecoration(
                  labelText: '세트 제목',
                  labelStyle: Subtitle2.copyWith(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PrimaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                onEditingComplete: () => focusNode2.requestFocus(),
                validator: (value) =>
                    value.isNotEmpty ? null : '세트에 제목을 지어주세요!',
                onChanged: (value) => _setTitle = value,
                onFieldSubmitted: (value) => _setTitle = value,
                onSaved: (value) => _setTitle = value,
              ),
              SizedBox(height: 32),

              // ListTile(
              //   tileColor: Colors.blueAccent,
              //   trailing: Text('Kg'),
              //   title: TextFormField(
              //     focusNode: focusNode2,
              //     controller: _textController2,
              //     textInputAction: TextInputAction.next,
              //     textAlign: TextAlign.center,
              //     style: BodyText1,
              //     keyboardType: TextInputType.numberWithOptions(
              //       signed: true,
              //     ),
              //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //     decoration: new InputDecoration(
              //       // labelText: '무게: Kg',
              //       labelStyle: Subtitle2.copyWith(color: Colors.grey),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //       ),
              //     ),
              //     onEditingComplete: () => focusNode3.requestFocus(),
              //     onChanged: (value) => _setWeights = value,
              //     onFieldSubmitted: (value) => _setWeights = value,
              //     onSaved: (value) => _setWeights = value,
              //   ),
              // ),
              //
              // SizedBox(height: 32),

              // Container(
              //   width: size.width - 32,
              //   child: CupertinoSlidingSegmentedControl(
              //     children: {
              //       0: Text(
              //         '맨몸',
              //         style: TextStyle(
              //           color: (_slider == 0) ? Colors.black : Colors.white,
              //         ),
              //       ),
              //       1: Text(
              //         '웨이트',
              //         style: TextStyle(
              //           color: (_slider == 1) ? Colors.black : Colors.white,
              //         ),
              //       ),
              //     },
              //     groupValue: _slider,
              //     onValueChanged: (newValue) {
              //       setState(() {
              //         _slider = newValue;
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(height: 32),

              /// Weights
              TextFormField(
                focusNode: focusNode2,
                controller: _textController2,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                style: BodyText1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: new InputDecoration(
                  labelText: '무게: Kg',
                  labelStyle: Subtitle2.copyWith(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PrimaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                onEditingComplete: () => focusNode3.requestFocus(),
                validator: (value) => value.isNotEmpty ? null : '무게를 입력해 주세요!',
                onChanged: (value) => _setWeights = value,
                onFieldSubmitted: (value) => _setWeights = value,
                onSaved: (value) => _setWeights = value,
              ),
              SizedBox(height: 32),

              /// Reps
              TextFormField(
                focusNode: focusNode3,
                controller: _textController3,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                style: BodyText1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: new InputDecoration(
                  labelText: '횟수: X',
                  labelStyle: Subtitle2.copyWith(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PrimaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                validator: (value) => value.isNotEmpty ? null : '횟수를 입력해 주세요!',
                onChanged: (value) => _setReps = value,
                onFieldSubmitted: (value) => _setReps = value,
                onSaved: (value) => _setReps = value,
              ),

              // Text(
              //   '횟수',
              //   style: Headline4,
              // ),
              //
              // Slider(
              //   value: _value,
              //   onChanged: (value) {
              //     setState(() => _value = value);
              //   },
              //   min: 0,
              //   max: 50,
              //   label: '${_value.toInt()}',
              //   divisions: 50,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
      keyboardBarColor: Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode1,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode2,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode3,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('완료', style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  Widget _buildRestForm() {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: (_start == null) ? 162 : 120),
        if (_start == null)
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
        if (_start == null) SizedBox(height: 162),
        if (_start != null)
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
        if (_start != null) SizedBox(height: 120),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: (size.width - 48) / 2,
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
            SizedBox(width: 16),
            Container(
              height: 48,
              width: (size.width - 48) / 2,
              child: RaisedButton.icon(
                icon: AnimatedIcon(
                  size: 32,
                  color: Colors.white,
                  icon: AnimatedIcons.play_pause,
                  progress: _animationController,
                ),
                label: Text(
                  (_isPaused) ? '시작하기' : '일지성지',
                  style: ButtonText,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
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
          ],
        ),
      ],
    );
  }
}
