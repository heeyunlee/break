import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/screens/during_workout/weights_and_reps_widget.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'routine_history_summary_screen.dart';

Logger logger = Logger();

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

  static Future<void> show(
    BuildContext context, {
    Routine routine,
    // User user,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userDocument(auth.currentUser.uid);

    await HapticFeedback.mediumImpact();

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => DuringWorkoutScreen(
          database: database,
          routine: routine,
          user: user,
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
  final CountDownController _countDownController = CountDownController();

  bool _isPaused;
  Duration _restTime = Duration();
  int routineWorkoutIndex = 0;
  int setIndex = 0;
  int setLength = 0;
  int currentIndex = 1;
  bool setLengthCalculated = false;
  Timestamp _workoutStartTime;

  // List _selectedSets = List();

  // // For App Bar Title
  // int _appBarTitleIndex = 0;
  // PageController _pageController = PageController(
  //   initialPage: 0,
  // );

  @override
  void initState() {
    super.initState();
    print('init');
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _isPaused = false;
    _workoutStartTime = Timestamp.now();
  }

  @override
  void dispose() {
    print('dispose');

    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit(List<RoutineWorkout> routineWorkouts) async {
    try {
      debugPrint('submit button pressed');

      final routineHistoryId = documentIdFromCurrentDate();
      final workoutEndTime = Timestamp.now();
      final workoutStartDate = _workoutStartTime.toDate();
      final workoutEndDate = workoutEndTime.toDate();
      final duration = workoutEndDate.difference(workoutStartDate).inSeconds;
      final isBodyWeightWorkout = routineWorkouts.any(
        (element) => element.isBodyWeightWorkout == true,
      );
      final workoutDate = DateTime.utc(
        workoutStartDate.year,
        workoutStartDate.month,
        workoutStartDate.day,
      );

      // For Calculating Total Weights
      var totalWeights = 0.00;
      var weightsCalculated = false;
      if (!weightsCalculated) {
        for (var i = 0; i < routineWorkouts.length; i++) {
          var weights = routineWorkouts[i].totalWeights;
          totalWeights = totalWeights + weights;
        }
        weightsCalculated = true;
      }

      final routineHistory = RoutineHistory(
        routineHistoryId: routineHistoryId,
        userId: widget.user.userId,
        username: widget.user.userName,
        routineId: widget.routine.routineId,
        routineTitle: widget.routine.routineTitle,
        isPublic: true,
        mainMuscleGroup: widget.routine.mainMuscleGroup,
        secondMuscleGroup: widget.routine.secondMuscleGroup,
        workoutStartTime: _workoutStartTime,
        workoutEndTime: workoutEndTime,
        notes: '',
        totalCalories: 0,
        totalDuration: duration,
        totalWeights: totalWeights,
        isBodyWeightWorkout: isBodyWeightWorkout,
        workoutDate: workoutDate,
        imageUrl: widget.routine.imageUrl,
        unitOfMass: widget.routine.initialUnitOfMass,
        equipmentRequired: widget.routine.equipmentRequired,
      );

      /// Update User Data
      // GET history data
      final histories = widget.user.dailyWorkoutHistories;

      final index = widget.user.dailyWorkoutHistories
          .indexWhere((element) => element.date.toUtc() == workoutDate);

      print(index);

      if (index == -1) {
        final newHistory =
            DailyWorkoutHistory(date: workoutDate, totalWeights: totalWeights);
        histories.add(newHistory);
        print(0);
      } else {
        // final index = widget.user.dailyWorkoutHistories
        //     .indexWhere((element) => element.date.toUtc() == workoutDate);
        final oldHistory = histories[index];

        final newHistory = DailyWorkoutHistory(
          date: oldHistory.date,
          totalWeights: oldHistory.totalWeights + totalWeights,
        );
        histories[index] = newHistory;
        print(1);
      }

      // User
      final user = {
        'totalWeights': widget.user.totalWeights + totalWeights,
        'totalNumberOfWorkouts': widget.user.totalNumberOfWorkouts + 1,
        'dailyWorkoutHistories': histories.map((e) => e.toMap()).toList(),
      };

      await widget.database
          .setRoutineHistory(routineHistory)
          .then((value) async {
        await widget.database.batchRoutineWorkouts(
          routineHistory,
          routineWorkouts,
        );
      });
      await widget.database.updateUser(widget.user.userId, user);
      Navigator.of(context).popUntil((route) => route.isFirst);
      RoutineHistorySummaryScreen.show(
        context: context,
        routineHistory: routineHistory,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You\'ve finished your workout! \nKeep Lifting! 🎉'),
      ));
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e.toString(),
      );
    }
  }

  Future<void> _previousWorkout(List<RoutineWorkout> routineWorkouts) async {
    setState(() {
      _isPaused = false;
      _animationController.reverse();
      currentIndex = currentIndex -
          setIndex -
          routineWorkouts[routineWorkoutIndex - 1].sets.length;
      setIndex = 0;
      routineWorkoutIndex--;
    });

    debugPrint('current Index is $currentIndex');
    debugPrint('set index is $setIndex');
    debugPrint('rW index is $routineWorkoutIndex');
  }

  Future<void> _skipPrevious(List<RoutineWorkout> routineWorkouts) async {
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
        setIndex = routineWorkouts[routineWorkoutIndex - 1].sets.length - 1;
        routineWorkoutIndex--;
      });
    }

    debugPrint('current Index is $currentIndex');
    debugPrint('set index is $setIndex');
    debugPrint('rW index is $routineWorkoutIndex');
  }

  Future<void> _pausePlay(WorkoutSet workoutSet) async {
    if (!_isPaused) {
      await _animationController.forward();
      if (workoutSet.isRest) _countDownController.pause();
      setState(() {
        _isPaused = !_isPaused;
        debugPrint('_isPaused is $_isPaused');
      });
    } else {
      await _animationController.reverse();
      if (workoutSet.isRest) _countDownController.resume();
      setState(() {
        _isPaused = !_isPaused;
        debugPrint('_isPaused is $_isPaused');
      });
    }
  }

  Future<void> _skipNext(
    List<RoutineWorkout> routineWorkouts,
    RoutineWorkout routineWorkout,
    WorkoutSet workoutSet,
  ) async {
    final workoutSetLength = routineWorkout.sets.length - 1;
    final routineWorkoutLength = routineWorkouts.length - 1;
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

    debugPrint('current Index is $currentIndex');
    debugPrint('set index is $setIndex');
    debugPrint('rW index is $routineWorkoutIndex');
  }

  Future<void> _skipWorkout(
    WorkoutSet workoutSet,
    RoutineWorkout routineWorkout,
  ) async {
    final workoutSetLength = routineWorkout.sets.length - 1;

    print(workoutSetLength);
    print(setIndex);

    setState(() {
      _isPaused = false;
      _animationController.reverse();
      if (workoutSet.isRest) _restTime = Duration(seconds: workoutSet.restTime);
      currentIndex = currentIndex - setIndex + workoutSetLength + 1;
      setIndex = 0;
      routineWorkoutIndex++;
    });

    debugPrint('current Index is $currentIndex');
    debugPrint('set index is $setIndex');
    debugPrint('rW index is $routineWorkoutIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text('${widget.routine.routineTitle}', style: BodyText2w900),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () async {
            await _closeModalBottomSheet();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      body: _buildBody(),
    );

    // return _buildBody();
  }

  Widget _buildBody() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<RoutineWorkout>>(
      stream: database.routineWorkoutsStream(widget.routine),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final routineWorkouts = snapshot.data;

          if (routineWorkouts.isNotEmpty) {
            final routineWorkout = routineWorkouts[routineWorkoutIndex];

            if (routineWorkout.sets.isNotEmpty) {
              final workoutSet = routineWorkout.sets[setIndex];

              if (workoutSet.isRest) {
                _restTime = Duration(
                  seconds: workoutSet.restTime,
                );
              }
              if (!setLengthCalculated) {
                for (var i = 0; i < routineWorkouts.length; i++) {
                  var length = routineWorkouts[i].sets.length;
                  setLength = setLength + length;
                  debugPrint('$setLength');
                }
                setLengthCalculated = true;
              }

              return _buildStreamBody(
                routineWorkouts,
                routineWorkout,
                workoutSet,
              );
            } else {
              return const EmptyContent(
                message: 'Add few sets to your workout',
              );
            }
          } else {
            return const EmptyContent(
              message: 'Add Workouts to your routine!',
            );
          }
        } else if (snapshot.hasError) {
          return const EmptyContent(
            message: 'Something went wrong',
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildStreamBody(
    List<RoutineWorkout> routineWorkouts,
    RoutineWorkout routineWorkout,
    WorkoutSet workoutSet,
  ) {
    final f = NumberFormat('#,###');

    final size = MediaQuery.of(context).size;
    final routineWorkoutsLength = routineWorkouts.length - 1;
    final workoutSetsLength = routineWorkout.sets.length - 1;
    final currentProgress = currentIndex / setLength * 100;
    final formattedCurrentProgress = '${f.format(currentProgress)} %';

    return Stack(
      children: [
        Container(color: Colors.green.withOpacity(0.02)),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (!workoutSet.isRest)
                  ? WeightsAndRepsWidget(
                      workoutSet: workoutSet,
                      routineWorkout: routineWorkout,
                      routine: widget.routine,
                    )
                  : _buildRestTimerWidget(
                      routineWorkouts,
                      routineWorkout,
                      workoutSet,
                    ),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                child: Text(workoutSet.setTitle,
                    style: Headline5.copyWith(fontSize: size.height * 0.03)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${routineWorkout.index}.  ',
                      style:
                          Headline6Grey.copyWith(fontSize: size.height * 0.02),
                    ),
                    Text(
                      routineWorkout.workoutTitle,
                      style: Headline6Grey,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        color: Colors.grey[800],
                        height: 4,
                        width: size.width - 48,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        color: PrimaryColor,
                        height: 4,
                        width: (size.width - 48) * currentIndex / setLength,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      formattedCurrentProgress,
                      style: BodyText2.copyWith(fontSize: size.height * 0.017),
                    ),
                    Spacer(),
                    Text(
                      '100 %',
                      style: BodyText2.copyWith(fontSize: size.height * 0.017),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ButtonTheme(
                padding: EdgeInsets.all(0),
                minWidth: size.width / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    /// Previous Workout Button
                    Tooltip(
                      verticalOffset: -56,
                      message: 'To Previous Workout',
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/skip_previous_twice-24px.svg',
                          height: size.height * 0.03,
                          width: size.height * 0.03,
                          color: (routineWorkoutIndex == 0)
                              ? Colors.grey[700]
                              : Colors.white,
                        ),
                        onPressed: (routineWorkoutIndex == 0)
                            ? null
                            : () => _previousWorkout(routineWorkouts),
                      ),
                    ),

                    /// Previous Set
                    Tooltip(
                      verticalOffset: -56,
                      message: 'To previous set',
                      child: IconButton(
                        iconSize: size.height * 0.06,
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: (setIndex == 0 && routineWorkoutIndex == 0)
                              ? Colors.grey[700]
                              : Colors.white,
                          size: size.height * 0.06,
                        ),
                        onPressed: (currentIndex > 1)
                            ? () => _skipPrevious(routineWorkouts)
                            : null,
                      ),
                    ),

                    /// Pause Play
                    Tooltip(
                      verticalOffset: -56,
                      message: (_isPaused)
                          ? 'Pause the Workout'
                          : 'Start the Workout',
                      child: IconButton(
                        onPressed: () => _pausePlay(workoutSet),
                        iconSize: size.height * 0.06,
                        icon: Container(
                          child: AnimatedIcon(
                            size: size.height * 0.06,
                            color: Colors.white,
                            icon: AnimatedIcons.pause_play,
                            progress: _animationController,
                          ),
                        ),
                      ),
                    ),

                    /// Skip Next Set
                    Tooltip(
                      verticalOffset: -56,
                      message: 'To Next Set',
                      child: IconButton(
                        iconSize: size.height * 0.06,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: (setIndex == workoutSetsLength)
                              ? Colors.grey[700]
                              : Colors.white,
                          size: size.height * 0.06,
                        ),
                        onPressed: (setIndex == workoutSetsLength)
                            ? null
                            : () => _skipNext(
                                  routineWorkouts,
                                  routineWorkout,
                                  workoutSet,
                                ),
                      ),
                    ),

                    /// Skip Next Routine Workout
                    Tooltip(
                      verticalOffset: -56,
                      message: 'To Next Workout',
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/skip_next_twice-24px.svg',
                          width: size.height * 0.03,
                          height: size.height * 0.03,
                          color: (routineWorkoutIndex == routineWorkoutsLength)
                              ? Colors.grey[700]
                              : Colors.white,
                        ),
                        onPressed:
                            (routineWorkoutIndex == routineWorkoutsLength)
                                ? null
                                : () => _skipWorkout(
                                      workoutSet,
                                      routineWorkout,
                                    ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                height: size.height * 0.1,
                child: (_isPaused)
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: MaxWidthRaisedButton(
                          width: double.infinity,
                          buttonText: 'SAVE & END WORKOUT',
                          color: Colors.grey[700],
                          onPressed: () => _submit(routineWorkouts),
                        ),
                        // child: StreamBuilder<User>(
                        //     stream: widget.database.userStream(
                        //       userId: widget.user.userId,
                        //     ),
                        //     builder: (context, snapshot) {
                        //       final userData = snapshot.data;

                        //       return MaxWidthRaisedButton(
                        //         color: Colors.grey[700],
                        //         buttonText: 'SAVE & END WORKOUT',
                        //         onPressed: () =>
                        //             _submit(routineWorkouts, userData),
                        //       );
                        //     }),
                      )
                    : (routineWorkoutIndex == routineWorkoutsLength &&
                            setIndex == workoutSetsLength)
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MaxWidthRaisedButton(
                              width: double.infinity,
                              onPressed: () {},
                              color: PrimaryColor,
                              buttonText: 'ADD NEW WORKOUT',
                            ),
                          )
                        : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestTimerWidget(
    List<RoutineWorkout> routineWorkouts,
    RoutineWorkout routineWorkout,
    WorkoutSet workoutSet,
  ) {
    final size = MediaQuery.of(context).size;
    final routineWorkoutLength = routineWorkouts.length - 1;
    final workoutSetLength = routineWorkout.sets.length - 1;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        child: Container(
          width: size.width - 56,
          height: size.width - 56,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CircularCountDownTimer(
              textStyle: Headline2,
              controller: _countDownController,
              width: 280,
              height: 280,
              duration: _restTime.inSeconds,
              fillColor: Colors.grey[600],
              ringColor: Colors.red,
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
