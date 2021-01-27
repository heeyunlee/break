import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

class DuringWorkoutScreen extends StatefulWidget {
  const DuringWorkoutScreen({
    Key key,
    this.database,
    this.routine,
  }) : super(key: key);

  final Database database;
  final Routine routine;

  static void show({
    BuildContext context,
    Routine routine,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => DuringWorkoutScreen(
          database: database,
          routine: routine,
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
  Duration _restTime = Duration(minutes: 1, seconds: 30);
  int routineWorkoutIndex = 0;
  int setIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _isPaused = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      // backgroundColor: BackgroundColor,
      backgroundColor: Colors.deepPurple.withOpacity(0.1),
      body: _buildBody(),
    );
  }

  _buildBody() {
    final database = Provider.of<Database>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return StreamBuilder<List<RoutineWorkout>>(
        stream: database.routineWorkoutsStream(widget.routine),
        builder: (context, snapshot) {
          final routineWorkout = snapshot.data[routineWorkoutIndex];
          final workoutSet = routineWorkout.sets[setIndex];

          return Stack(
            children: [
              // Container(
              //   width: size.width,
              //   height: size.height,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [
              //         // BackgroundColor,
              //         Colors.greenAccent.withOpacity(0.01),
              //         Colors.greenAccent.withOpacity(0.1),
              //       ],
              //     ),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 104),
                  (!workoutSet.isRest)
                      ? _buildWeightsAndRepsWidget(workoutSet)
                      : _buildRestTimerWidget(workoutSet),
                  SizedBox(height: 40),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
                  SizedBox(height: 24),
                  Center(
                    child: Container(
                      color: Colors.grey[800],
                      height: 4,
                      width: size.width - 48,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      children: [
                        Text('1', style: BodyText2),
                        Spacer(),
                        Text('24', style: BodyText2),
                      ],
                    ),
                  ),
                  // SizedBox(height: 48),
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
                        onPressed: (setIndex == 0 && routineWorkoutIndex == 0)
                            ? null
                            : () {
                                setState(() {
                                  _isPaused = false;
                                  _animationController.reverse();
                                });
                                if (setIndex != 0) {
                                  setState(() {
                                    setIndex = --setIndex;
                                  });
                                } else {
                                  setState(() {
                                    setIndex = snapshot
                                            .data[routineWorkoutIndex - 1]
                                            .sets
                                            .length -
                                        1;
                                    routineWorkoutIndex = --routineWorkoutIndex;
                                  });
                                }
                                debugPrint('set index is $setIndex');
                                debugPrint('rW index is $routineWorkoutIndex');
                              },
                      ),
                      RawMaterialButton(
                        child: AnimatedIcon(
                          size: 48,
                          color: Colors.white,
                          icon: AnimatedIcons.pause_play,
                          progress: _animationController,
                        ),
                        onPressed: () {
                          if (!_isPaused) {
                            _animationController.forward();
                            if (workoutSet.isRest) _countDownController.pause();
                            setState(() {
                              _isPaused = !_isPaused;
                              debugPrint('$_isPaused');
                            });
                          } else {
                            _animationController.reverse();
                            if (workoutSet.isRest)
                              _countDownController.resume();
                            setState(() {
                              _isPaused = !_isPaused;
                              debugPrint('$_isPaused');
                            });
                          }
                        },
                      ),
                      RawMaterialButton(
                        child: Icon(
                          Icons.skip_next,
                          color: (routineWorkoutIndex ==
                                      snapshot.data.length - 1 &&
                                  setIndex == routineWorkout.sets.length - 1)
                              ? Colors.grey[700]
                              : Colors.white,
                          size: 48,
                        ),
                        onPressed: (routineWorkoutIndex ==
                                    snapshot.data.length - 1 &&
                                setIndex == routineWorkout.sets.length - 1)
                            ? null
                            : () {
                                setState(() {
                                  _isPaused = false;
                                  _animationController.reverse();
                                });
                                if (setIndex < routineWorkout.sets.length - 1) {
                                  setState(() {
                                    setIndex = ++setIndex;
                                  });
                                } else {
                                  if (routineWorkoutIndex <
                                      snapshot.data.length - 1) {
                                    setState(() {
                                      setIndex = 0;
                                      routineWorkoutIndex =
                                          ++routineWorkoutIndex;
                                    });
                                  }
                                }
                                debugPrint('set index is $setIndex');
                                debugPrint('rW index is $routineWorkoutIndex');
                              },
                      ),
                    ],
                  ),
                  SizedBox(height: (_isPaused) ? 48 : 160),
                  if (_isPaused)
                    Divider(
                      color: Grey700,
                      indent: 16,
                      endIndent: 16,
                    ),
                  if (_isPaused)
                    Container(
                      width: size.width,
                      height: 96,
                      child: FlatButton(
                        child: Text('SAVE WORKOUT', style: ButtonText),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                ],
              ),
            ],
          );
        });
  }

  Widget _buildWeightsAndRepsWidget(WorkoutSet workoutSet) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Card(
        // color: Colors.grey[800],
        color: CardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 6,
        child: Container(
          width: size.width - 48,
          height: size.width - 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (size.width - 56) / 2,
                child: Stack(
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Headline3.copyWith(
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '${workoutSet.weights}'),
                            TextSpan(
                              text: ' kg',
                              style: BodyText1.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('무게',
                              style: BodyText2.copyWith(color: Colors.grey)),
                        ),
                        Divider(
                          color: BackgroundColor,
                          endIndent: 4,
                          indent: 4,
                          height: 0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: BackgroundColor),
              Container(
                width: (size.width - 56) / 2,
                child: Stack(
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Headline3.copyWith(
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '${workoutSet.reps}'),
                            TextSpan(
                              text: ' x',
                              style: BodyText1.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('횟수',
                              style: BodyText2.copyWith(color: Colors.grey)),
                        ),
                        Divider(
                          color: BackgroundColor,
                          endIndent: 4,
                          indent: 4,
                          height: 0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRestTimerWidget(WorkoutSet workoutSet) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 6,
        child: Container(
          width: size.width - 48,
          height: size.width - 48,
          child: CircularCountDownTimer(
            textStyle: Headline2,
            controller: _countDownController,
            width: 240,
            height: 240,
            duration: _restTime.inSeconds,
            fillColor: Colors.grey[600],
            color: Colors.red,
            isReverse: true,
            strokeWidth: 8,
            onComplete: () {},
          ),
        ),
      ),
    );
  }
}
