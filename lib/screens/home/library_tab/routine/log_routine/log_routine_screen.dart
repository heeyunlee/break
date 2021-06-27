import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log_routine_provider.dart';

class LogRoutineScreen extends StatefulWidget {
  final User user;
  final Database database;
  final String uid;
  final Routine routine;
  final List<RoutineWorkout?> routineWorkouts;

  const LogRoutineScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.uid,
    required this.routine,
    required this.routineWorkouts,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Routine routine,
    required Database database,
    required String uid,
    required User user,
    required List<RoutineWorkout?> routineWorkouts,
  }) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => LogRoutineScreen(
          user: user,
          database: database,
          uid: uid,
          routine: routine,
          routineWorkouts: routineWorkouts,
        ),
      ),
    );
  }

  @override
  _LogRoutineScreenState createState() => _LogRoutineScreenState();
}

class _LogRoutineScreenState extends State<LogRoutineScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _workoutEndTime;
  late String _nowInString;
  late int _durationInMinutes;
  late TextEditingController _textController1;
  late FocusNode _focusNode1;

  late num _totalWeights;
  late TextEditingController _textController2;
  late FocusNode _focusNode2;

  String _notes = '';
  late TextEditingController _textController3;
  late FocusNode _focusNode3;

  double _effort = 2.5;
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    _workoutEndTime = DateTime.now();
    _nowInString = Formatter.yMdjmInDateTime(_workoutEndTime);

    _durationInMinutes = Formatter.durationInMin(widget.routine.duration);
    _textController1 =
        TextEditingController(text: _durationInMinutes.toString());

    _totalWeights = widget.routine.totalWeights;
    _textController2 = TextEditingController(text: _totalWeights.toString());

    _textController3 = TextEditingController(text: _notes);

    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _submit(
    BuildContext context, {
    required Routine routine,
    required List<RoutineWorkout?> routineWorkouts,
  }) async {
    try {
      debugPrint('submit button pressed');
      context.read(isLogRoutineButtonPressedProvider).toggleBoolValue();

      /// For Routine History
      final routineHistoryId = 'RH${documentIdFromCurrentDate()}';
      final _workoutStartTime = _workoutEndTime.subtract(
        Duration(minutes: _durationInMinutes),
      );

      final isBodyWeightWorkout = routineWorkouts.any(
        (element) => element!.isBodyWeightWorkout == true,
      );
      final workoutDate = DateTime.utc(
        _workoutEndTime.year,
        _workoutEndTime.month,
        _workoutEndTime.day,
      );

      // // For Calculating Total Weights
      // var totalWeights = 0.00;
      // var weightsCalculated = false;
      // if (!weightsCalculated) {
      //   for (var i = 0; i < routineWorkouts.length; i++) {
      //     var weights = routineWorkouts[i].totalWeights;
      //     totalWeights = totalWeights + weights;
      //   }
      //   weightsCalculated = true;
      // }

      final routineHistory = RoutineHistory(
        routineHistoryId: routineHistoryId,
        userId: widget.user.userId,
        username: widget.user.displayName,
        routineId: routine.routineId,
        routineTitle: routine.routineTitle,
        isPublic: true,
        mainMuscleGroup: routine.mainMuscleGroup,
        secondMuscleGroup: routine.secondMuscleGroup,
        workoutEndTime: Timestamp.fromDate(_workoutEndTime),
        workoutStartTime: Timestamp.fromDate(_workoutStartTime),
        notes: '',
        totalCalories: 0,
        totalDuration: _durationInMinutes * 60,
        totalWeights: _totalWeights,
        isBodyWeightWorkout: isBodyWeightWorkout,
        workoutDate: workoutDate,
        imageUrl: routine.imageUrl,
        unitOfMass: routine.initialUnitOfMass,
        equipmentRequired: routine.equipmentRequired,
      );

      /// For Workout Histories
      List<WorkoutHistory> workoutHistories = [];
      routineWorkouts.forEach(
        (rw) {
          final workoutHistoryId = documentIdFromCurrentDate();
          final uniqueId = UniqueKey().toString();
          // print('unique id is $uniqueId');

          final workoutHistory = WorkoutHistory(
            workoutHistoryId: 'WH$workoutHistoryId$uniqueId',
            routineHistoryId: routineHistoryId,
            workoutId: rw!.workoutId,
            routineId: rw.routineId,
            uid: widget.user.userId,
            index: rw.index,
            workoutTitle: rw.workoutTitle,
            numberOfSets: rw.numberOfSets,
            numberOfReps: rw.numberOfReps,
            totalWeights: rw.totalWeights,
            isBodyWeightWorkout: rw.isBodyWeightWorkout,
            duration: rw.duration,
            secondsPerRep: rw.secondsPerRep,
            translated: rw.translated,
            sets: rw.sets,
            workoutTime: Timestamp.fromDate(_workoutEndTime),
            workoutDate: Timestamp.fromDate(workoutDate),
            unitOfMass: widget.routine.initialUnitOfMass,
          );
          workoutHistories.add(workoutHistory);
        },
      );

      /// Update User Data
      // GET history data
      final histories = widget.user.dailyWorkoutHistories;

      final index = widget.user.dailyWorkoutHistories!
          .indexWhere((element) => element.date.toUtc() == workoutDate);

      if (index == -1) {
        final newHistory = DailyWorkoutHistory(
          date: workoutDate,
          totalWeights: _totalWeights,
        );
        histories!.add(newHistory);
      } else {
        final oldHistory = histories![index];

        final newHistory = DailyWorkoutHistory(
          date: oldHistory.date,
          totalWeights: oldHistory.totalWeights + _totalWeights,
        );
        histories[index] = newHistory;
      }

      // User
      final updatedUserData = {
        'totalWeights': widget.user.totalWeights + _totalWeights,
        'totalNumberOfWorkouts': widget.user.totalNumberOfWorkouts + 1,
        'dailyWorkoutHistories': histories.map((e) => e.toMap()).toList(),
      };

      await widget.database.setRoutineHistory(routineHistory);
      await widget.database.batchWriteWorkoutHistories(workoutHistories);
      await widget.database.updateUser(widget.uid, updatedUserData);

      Navigator.of(context).pop();

      getSnackbarWidget(
        '',
        S.current.afterWorkoutSnackbar,
      );

      context
          .read(miniplayerProviderNotifierProvider.notifier)
          .makeValuesNull();
      context.read(miniplayerIndexProvider).setEveryIndexToDefault(0);
      context.read(isLogRoutineButtonPressedProvider).toggleBoolValue();
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  void _showDatePicker(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: kCardColorLight,
          height: size.height / 3,
          child: CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              initialDateTime: _workoutEndTime,
              onDateTimeChanged: (value) => setState(() {
                _workoutEndTime = value;
                _nowInString = Formatter.yMdjmInDateTime(_workoutEndTime);
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        title: Text(S.current.addWorkoutLog, style: kSubtitle2),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: Container(
        width: size.width - 32,
        padding: EdgeInsets.only(
          bottom: (_focusNode1.hasFocus ||
                  _focusNode2.hasFocus ||
                  _focusNode3.hasFocus)
              ? 48
              : 0,
        ),
        child: Consumer(
          builder: (context, watch, child) {
            final isPressed =
                watch(isLogRoutineButtonPressedProvider).isButtonPressed;

            return FloatingActionButton.extended(
              onPressed: isPressed
                  ? null
                  : () => _submit(
                        context,
                        routine: widget.routine,
                        routineWorkouts: widget.routineWorkouts,
                      ),
              backgroundColor:
                  isPressed ? kPrimaryColor.withOpacity(0.8) : kPrimaryColor,
              heroTag: 'logRoutineSubmitButton',
              label: Text(S.current.submit),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    final unit = Formatter.unitOfMass(widget.routine.initialUnitOfMass);

    return Theme(
      data: ThemeData(
        primaryColor: kPrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.routine.routineTitle, style: kHeadline6w900),
                  const SizedBox(height: 16),
                  // Start Time
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () => _showDatePicker(context),
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(_nowInString, style: kBodyText1),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: -6,
                        child: Container(
                          color: kBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(S.current.startTime, style: kCaption1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Duration
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    focusNode: _focusNode1,
                    controller: _textController1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: S.current.durationHintText,
                      labelStyle: kBodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: kBodyText1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.current.durationHintText;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      _durationInMinutes = int.parse(value);
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _durationInMinutes = int.parse(value);
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Total Weights
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    focusNode: _focusNode2,
                    controller: _textController2,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: '${S.current.totalVolumeHintText} $unit',
                      labelStyle: kBodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: kBodyText1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.current.totalVolumeValidatorText;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      _totalWeights = double.parse(value);
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _totalWeights = double.parse(value);
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    focusNode: _focusNode3,
                    controller: _textController3,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: S.current.notes,
                      hintText: S.current.addNotes,
                      hintStyle: kBodyText1Grey,
                      labelStyle: kBodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: kBodyText1,
                    onChanged: (value) => setState(() {
                      _notes = value;
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _notes = value;
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Effort
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 64,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: RatingBar(
                            initialRating: _effort,
                            glow: false,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            ratingWidget: RatingWidget(
                              empty: Image.asset(
                                'assets/emojis/fire_none.png',
                              ),
                              full: Image.asset(
                                'assets/emojis/fire_full.png',
                              ),
                              half: Image.asset(
                                'assets/emojis/fire_half.png',
                              ),
                            ),
                            onRatingUpdate: (rating) {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                _effort = rating;
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: -6,
                        child: Container(
                          color: kBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(S.current.effort, style: kCaption1),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // isPublic
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        S.current.makeItVisibleTo,
                        style: kBodyText2Light,
                      ),
                      SizedBox(
                        width: 72,
                        child: Text(
                          (_isPublic) ? S.current.everyone : S.current.justMe,
                          style: kBodyText2w900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        (_isPublic)
                            ? Icons.public_rounded
                            : Icons.public_off_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _isPublic,
                        activeColor: kPrimaryColor,
                        onChanged: (bool value) {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _isPublic = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode2,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode3,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
