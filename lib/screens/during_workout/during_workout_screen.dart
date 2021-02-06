import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/screens/during_workout/weights_and_reps_widget.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'routine_summary_screen.dart';

class DuringWorkoutScreen extends StatefulWidget {
  const DuringWorkoutScreen({
    Key key,
    this.database,
    this.routine,
    this.user,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final User user;

  static void show({
    BuildContext context,
    Routine routine,
    User user,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => DuringWorkoutScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _DuringWorkoutScreenState createState() => _DuringWorkoutScreenState();
}

class _DuringWorkoutScreenState extends State<DuringWorkoutScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  CountDownController _countDownController = CountDownController();
  bool _isPaused;
  Duration _restTime = Duration();
  int routineWorkoutIndex = 0;
  int setIndex = 0;
  int setLength = 0;
  int currentIndex = 1;
  bool setLengthCalculated = false;
  Timestamp _workoutStartTime;

  List _selectedSets = List();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _isPaused = false;
    _workoutStartTime = Timestamp.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submit(AsyncSnapshot snapshot) async {
    try {
      debugPrint('submit button pressed');
      List<RoutineWorkout> routineWorkouts = snapshot.data;

      final String routineHistoryId = documentIdFromCurrentDate();
      final Timestamp workoutEndTime = Timestamp.now();
      final workoutStartDate = _workoutStartTime.toDate();
      final workoutEndDate = workoutEndTime.toDate();
      final duration = workoutEndDate.difference(workoutStartDate).inMinutes;
      final isBodyWeightWorkout = routineWorkouts.any(
        (element) => element.isBodyWeightWorkout == true,
      );
      final imageIndex = Random().nextInt(4);
      final workoutDate = DateTime(
        workoutStartDate.year,
        workoutStartDate.month,
        workoutStartDate.day,
      );

      // For Calculating Total Weights
      int totalWeights = 0;
      bool weightsCalculated = false;
      if (!weightsCalculated) {
        for (var i = 0; i < routineWorkouts.length; i++) {
          var weights = routineWorkouts[i].totalWeights;
          totalWeights = totalWeights + weights;
        }
        weightsCalculated = true;
      }

      final routineHistory = RoutineHistory(
        routineHistoryId: routineHistoryId,
        userId: widget.user.uid,
        routineId: widget.routine.routineId,
        routineTitle: widget.routine.routineTitle,
        mainMuscleGroup: widget.routine.mainMuscleGroup,
        secondMuscleGroup: widget.routine.secondMuscleGroup,
        workoutStartTime: _workoutStartTime,
        workoutEndTime: workoutEndTime,
        notes: null,
        totalCalories: 500,
        totalDuration: duration,
        totalWeights: totalWeights,
        isBodyWeightWorkout: isBodyWeightWorkout,
        imageIndex: imageIndex,
        workoutDate: workoutDate,
      );

      await widget.database
          .setRoutineHistory(routineHistory)
          .then((value) async {
        await widget.database.batchRoutineWorkouts(
          routineHistory,
          snapshot.data,
        );
      });
      Navigator.of(context).popUntil((route) => route.isFirst);
      RoutineSummaryScreen.show(
        context: context,
        routineHistory: routineHistory,
      );
      showFlushBar(context: context, message: 'Finished Your Workout!!');
    } on FirebaseException catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  Future<void> _skipPrevious(AsyncSnapshot snapshot) async {
    setState(() {
      _isPaused = false;
      _animationController.reverse();
      currentIndex--;
    });
    if (setIndex != 0) {
      setState(() {
        setIndex--;
      });
    } else {
      setState(() {
        setIndex = snapshot.data[routineWorkoutIndex - 1].sets.length - 1;
        routineWorkoutIndex--;
      });
    }
    debugPrint('set index is $setIndex');
    debugPrint('rW index is $routineWorkoutIndex');
  }

  Future<void> _pausePlay(WorkoutSet workoutSet) async {
    if (!_isPaused) {
      _animationController.forward();
      if (workoutSet.isRest) _countDownController.pause();
      setState(() {
        _isPaused = !_isPaused;
        debugPrint('_isPaused is $_isPaused');
      });
    } else {
      _animationController.reverse();
      if (workoutSet.isRest) _countDownController.resume();
      setState(() {
        _isPaused = !_isPaused;
        debugPrint('_isPaused is $_isPaused');
      });
    }
  }

  Future<void> _skipNext(
    WorkoutSet workoutSet,
    int workoutSetLength,
    int routineWorkoutLength,
  ) async {
    setState(() {
      _isPaused = false;
      _animationController.reverse();
      currentIndex++;
      if (workoutSet.isRest) _restTime = Duration(seconds: workoutSet.restTime);
    });
    if (setIndex < workoutSetLength) {
      setState(() {
        setIndex++;
      });
    } else {
      if (routineWorkoutIndex < routineWorkoutLength) {
        setState(() {
          setIndex = 0;
          routineWorkoutIndex++;
        });
      }
    }
    debugPrint('set index is $setIndex');
    debugPrint('rW index is $routineWorkoutIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.routine.routineTitle}',
          style: BodyText2.copyWith(fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () async {
            await _closeModalBottomSheet();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      body: _buildBody(),
    );
  }

  _buildBody() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<RoutineWorkout>>(
      stream: database.routineWorkoutsStream(widget.routine),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<RoutineWorkout> items = snapshot.data;
          if (items.isNotEmpty) {
            final routineWorkout = snapshot.data[routineWorkoutIndex];

            if (routineWorkout.sets.isNotEmpty) {
              final workoutSet = routineWorkout.sets[setIndex];

              if (workoutSet.isRest)
                _restTime = Duration(
                  seconds: workoutSet.restTime,
                );
              if (!setLengthCalculated) {
                for (var i = 0; i < snapshot.data.length; i++) {
                  var length = snapshot.data[i].sets.length;
                  setLength = setLength + length;
                  debugPrint('$setLength');
                }
                setLengthCalculated = true;
              }

              return _buildStreamBody(workoutSet, routineWorkout, snapshot);
            } else {
              return EmptyContent(
                message: 'Add few sets to your workout',
              );
            }
          } else {
            return EmptyContent(
              message: 'Add few sets to your workout',
            );
          }
        } else if (snapshot.hasError) {
          return EmptyContent(
            message: 'Something went wrong',
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _buildStreamBody(
    WorkoutSet workoutSet,
    RoutineWorkout routineWorkout,
    AsyncSnapshot snapshot,
  ) {
    final size = MediaQuery.of(context).size;
    final routineWorkoutLength = snapshot.data.length - 1;
    final workoutSetLength = routineWorkout.sets.length - 1;

    return Stack(
      children: [
        Container(color: Colors.deepPurple.withOpacity(0.05)),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (!workoutSet.isRest)
                  ? WeightsAndRepsWidget(
                      workoutSet: workoutSet,
                      routineWorkout: routineWorkout,
                    )
                  : _buildRestTimerWidget(routineWorkout, workoutSet, snapshot),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                child: Text(workoutSet.setTitle, style: Headline5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      routineWorkout.workoutTitle,
                      style: Headline6.copyWith(color: Colors.grey),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.list, color: Colors.white),
                    //   onPressed: () {
                    //     print(routineWorkout.sets.length);
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Stack(
                children: [
                  Center(
                    child: Container(
                      color: Colors.grey[800],
                      height: 4,
                      width: size.width - 48,
                    ),
                  ),
                  Positioned(
                    left: 24,
                    child: Container(
                      color: PrimaryColor,
                      height: 4,
                      width: (size.width - 48) * currentIndex / setLength,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text('$currentIndex', style: BodyText2),
                    Spacer(),
                    Text('$setLength', style: BodyText2),
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    child: Icon(
                      Icons.skip_previous,
                      color: (setIndex == 0 && routineWorkoutIndex == 0)
                          ? Colors.grey[700]
                          : Colors.white,
                      size: 48,
                    ),
                    onPressed: (currentIndex > 1)
                        ? () => _skipPrevious(snapshot)
                        : null,
                  ),
                  RawMaterialButton(
                    child: AnimatedIcon(
                      size: 48,
                      color: Colors.white,
                      icon: AnimatedIcons.pause_play,
                      progress: _animationController,
                    ),
                    onPressed: () => _pausePlay(workoutSet),
                  ),
                  RawMaterialButton(
                    child: Icon(
                      Icons.skip_next,
                      color: (routineWorkoutIndex == routineWorkoutLength &&
                              setIndex == workoutSetLength)
                          ? Colors.grey[700]
                          : Colors.white,
                      size: 48,
                    ),
                    onPressed: (routineWorkoutIndex == routineWorkoutLength &&
                            setIndex == workoutSetLength)
                        ? null
                        : () => _skipNext(
                              workoutSet,
                              workoutSetLength,
                              routineWorkoutLength,
                            ),
                  ),
                ],
              ),
              SizedBox(height: (_isPaused) ? 24 : 120),
              if (_isPaused)
                Divider(
                  color: Grey700,
                  indent: 16,
                  endIndent: 16,
                ),
              if (_isPaused)
                Container(
                  width: size.width,
                  height: 80,
                  child: FlatButton(
                    child: Text('SAVE WORKOUT', style: ButtonText),
                    onPressed: () => _submit(snapshot),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  _buildRestTimerWidget(
    RoutineWorkout routineWorkout,
    WorkoutSet workoutSet,
    AsyncSnapshot snapshot,
  ) {
    final size = MediaQuery.of(context).size;
    final routineWorkoutLength = snapshot.data.length - 1;
    final workoutSetLength = routineWorkout.sets.length - 1;

    return Center(
      child: Card(
        color: CardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 6,
        child: Container(
          width: size.width - 48,
          height: size.width - 48,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CircularCountDownTimer(
              textStyle: Headline2,
              controller: _countDownController,
              width: 280,
              height: 280,
              duration: _restTime.inSeconds,
              fillColor: Colors.grey[600],
              color: Colors.red,
              isReverse: true,
              strokeWidth: 8,
              onComplete: (routineWorkoutIndex == routineWorkoutLength &&
                      setIndex == workoutSetLength)
                  ? null
                  : () {
                      setState(() {
                        _isPaused = false;
                        currentIndex++;
                      });
                      if (setIndex < workoutSetLength) {
                        setState(() {
                          setIndex++;
                        });
                      } else {
                        if (routineWorkoutIndex < routineWorkoutLength) {
                          setState(() {
                            setIndex = 0;
                            routineWorkoutIndex++;
                          });
                        }
                      }
                    },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _closeModalBottomSheet() {
    return showAdaptiveModalBottomSheet(
      context: context,
      title: Text('Stop your workout? Data won\'t be saved',
          textAlign: TextAlign.center),
      firstActionText: 'Stop the workout',
      isFirstActionDefault: false,
      firstActionOnPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      cancelText: 'Cancel',
      isCancelDefault: true,
    );
  }
}
