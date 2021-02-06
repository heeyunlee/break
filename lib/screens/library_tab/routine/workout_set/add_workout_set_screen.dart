import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/appbar_blur_bg.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../common_widgets/show_flush_bar.dart';
import '../../../../constants.dart';
import '../../../../models/routine.dart';
import '../../../../models/routine_workout.dart';
import '../../../../models/workout_set.dart';
import '../../../../services/database.dart';

class AddWorkoutSetScreen extends StatefulWidget {
  const AddWorkoutSetScreen({
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
        builder: (context) => AddWorkoutSetScreen(
          database: database,
          routine: routine,
          routineWorkout: routineWorkout,
          set: set,
        ),
      ),
    );
  }

  @override
  _AddWorkoutSetScreenState createState() => _AddWorkoutSetScreenState();
}

class _AddWorkoutSetScreenState extends State<AddWorkoutSetScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  FocusNode focusNode1;
  FocusNode focusNode2;
  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();

  String _setWeights;
  String _setReps;
  Duration _restTime = Duration(minutes: 1, seconds: 30);
  int _start;
  bool cancelButtonDisabled;
  bool _isPaused;
  int _setOrRest = 0;

  CountDownController _countDownController = CountDownController();
  AnimationController _animationController;
  TabController tabController;

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
      // Weights
      _setWeights = widget.set.weights.toString();
      _textController1 = TextEditingController(text: _setWeights);

      // Reps
      _setReps = widget.set.reps.toString();
      _textController2 = TextEditingController(text: _setReps);
    }
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
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
        // Create new set
        final restLength = widget.routineWorkout.sets
            .where((element) => element.isRest)
            .length;
        final setLength = widget.routineWorkout.sets
            .where((element) => element.isRest == false)
            .length;
        final restIndex = widget.set?.workoutSetId ?? restLength + 1;
        final setIndex = widget.set?.workoutSetId ?? setLength + 1;
        final id = widget.set?.workoutSetId ?? UniqueKey().toString();
        final restTime = _restTime.inSeconds;

        final set = WorkoutSet(
          workoutSetId: id,
          index: (_setOrRest == 0) ? setIndex : restIndex,
          isRest: (_setOrRest == 0) ? false : true,
          setTitle: (_setOrRest == 0) ? 'Set $setIndex' : 'Rest $restIndex',
          weights: (_setOrRest == 0) ? int.parse(_setWeights) : null,
          reps: (_setOrRest == 0) ? int.parse(_setReps) : null,
          restTime: (_setOrRest == 0) ? null : restTime,
        );

        final numberOfSets = (set.isRest)
            ? widget.routineWorkout.numberOfSets
            : widget.routineWorkout.numberOfSets + 1;

        final numberOfReps = (set.isRest)
            ? widget.routineWorkout.numberOfReps
            : widget.routineWorkout.numberOfReps + set.reps;

        final totalWeights = (set.isRest)
            ? widget.routineWorkout.totalWeights
            : (set.weights == 0)
                ? widget.routineWorkout.totalWeights
                : widget.routineWorkout.totalWeights + (set.weights * set.reps);

        final routineWorkout = {
          'index': widget.routineWorkout.index,
          'workoutId': widget.routineWorkout.workoutId,
          'workoutTitle': widget.routineWorkout.workoutTitle,
          'numberOfSets': numberOfSets,
          'numberOfReps': numberOfReps,
          'totalWeights': totalWeights,
          'sets': FieldValue.arrayUnion([set.toMap()]),
        };

        await widget.database.setWorkoutSet(
          widget.routine,
          widget.routineWorkout,
          routineWorkout,
        );
        Navigator.of(context).pop();
        showFlushBar(
          context: context,
          message: (_setOrRest == 0) ? 'Added a new set' : 'Added a new rest',
        );
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
                ? 'Add new set'
                : (widget.set == null && _setOrRest == 1)
                    ? 'Add new rest'
                    : (widget.set != null && _setOrRest == 0)
                        ? 'Edit a set'
                        : 'Edit a rest',
            style: Subtitle1,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                (widget.set == null) ? 'DONE' : 'SAVE',
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
                setState(() {
                  _setOrRest = 1;
                  debugPrint('$_setOrRest');
                });
              }
            },
            tabs: [
              Tab(text: 'Set'),
              Tab(text: 'Rest'),
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
    return KeyboardActions(
      config: _buildConfig(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),

              /// Weights
              TextFormField(
                focusNode: focusNode1,
                controller: _textController1,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                style: BodyText1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: new InputDecoration(
                  labelText: 'Weights: Kg',
                  labelStyle: Subtitle2.copyWith(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PrimaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                onEditingComplete: () => focusNode2.requestFocus(),
                validator: (value) => value.isNotEmpty ? null : 'Add weights!',
                onChanged: (value) => _setWeights = value,
                onFieldSubmitted: (value) => _setWeights = value,
                onSaved: (value) => _setWeights = value,
              ),
              SizedBox(height: 32),

              /// Reps
              TextFormField(
                focusNode: focusNode2,
                controller: _textController2,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                style: BodyText1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: new InputDecoration(
                  labelText: 'Reps: X',
                  labelStyle: Subtitle2.copyWith(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PrimaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                validator: (value) => value.isNotEmpty ? null : 'Add reps!',
                onChanged: (value) => _setReps = value,
                onFieldSubmitted: (value) => _setReps = value,
                onSaved: (value) => _setReps = value,
              ),
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
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DONE', style: ButtonText),
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
                  'Cancel',
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
                  (_isPaused) ? 'Start' : 'Pause',
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
