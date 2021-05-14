import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class LogRoutineScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AuthBase auth;
  final Routine routine;

  const LogRoutineScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.auth,
    required this.routine,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Routine routine,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => LogRoutineScreen(
          user: user,
          database: database,
          auth: auth,
          routine: routine,
        ),
      ),
    );
  }

  @override
  _LogRoutineScreenState createState() => _LogRoutineScreenState();
}

class _LogRoutineScreenState extends State<LogRoutineScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _workoutEndDate;
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
    _workoutEndDate = DateTime.now();
    _nowInString = Format.yMdjmInDateTime(_workoutEndDate);

    _durationInMinutes = Format.durationInMin(widget.routine.duration);
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
  Future<void> _submit(List<RoutineWorkout> routineWorkouts) async {
    debugPrint('submit Button Pressed!');
    if (_formKey.currentState!.validate()) {
      try {
        final _id = documentIdFromCurrentDate();
        final _isBodyWorkout =
            widget.routine.mainMuscleGroup.contains('Bodyweight');
        final _workoutStartTime = _workoutEndDate.subtract(
          Duration(minutes: _durationInMinutes),
        );
        final _workoutDate = DateTime.utc(
          _workoutEndDate.year,
          _workoutEndDate.month,
          _workoutEndDate.day,
        );

        final routineHistory = RoutineHistory(
          routineHistoryId: 'RH$_id',
          userId: widget.user.userId,
          username: widget.user.displayName,
          routineId: widget.routine.routineId,
          routineTitle: widget.routine.routineTitle,
          equipmentRequired: widget.routine.equipmentRequired,
          mainMuscleGroup: widget.routine.mainMuscleGroup,
          imageUrl: widget.routine.imageUrl,
          unitOfMass: widget.routine.initialUnitOfMass,
          totalDuration: _durationInMinutes * 60,
          totalWeights: _totalWeights,
          workoutStartTime: Timestamp.fromDate(_workoutStartTime),
          workoutEndTime: Timestamp.fromDate(_workoutEndDate),
          isPublic: _isPublic,
          effort: _effort,
          isBodyWeightWorkout: _isBodyWorkout,
          secondMuscleGroup: widget.routine.secondMuscleGroup,
          workoutDate: _workoutDate,
          notes: _notes,
        );

        /// Update User Data
        // GET history data
        final histories = widget.user.dailyWorkoutHistories;

        final index = widget.user.dailyWorkoutHistories!
            .indexWhere((element) => element.date.toUtc() == _workoutDate);

        print(index);

        if (index == -1) {
          final newHistory = DailyWorkoutHistory(
              date: _workoutDate, totalWeights: _totalWeights);
          histories!.add(newHistory);
          print(0);
        } else {
          final oldHistory = histories![index];

          final newHistory = DailyWorkoutHistory(
            date: oldHistory.date,
            totalWeights: oldHistory.totalWeights + _totalWeights,
          );
          histories[index] = newHistory;
          print(1);
        }

        // User
        final user = {
          'totalWeights': widget.user.totalWeights + _totalWeights,
          'totalNumberOfWorkouts': widget.user.totalNumberOfWorkouts + 1,
          'dailyWorkoutHistories': histories.map((e) => e.toMap()).toList(),
        };

        await widget.database.setRoutineHistory(routineHistory).then(
          (value) async {
            await widget.database.batchRoutineWorkouts(
              routineHistory,
              routineWorkouts,
            );
          },
        );
        await widget.database.updateUser(widget.user.userId, user);
        Navigator.of(context).pop();

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.loggedRoutineHistorySnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.d(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
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
              initialDateTime: _workoutEndDate,
              onDateTimeChanged: (value) => setState(() {
                _workoutEndDate = value;
                _nowInString = Format.yMdjmInDateTime(_workoutEndDate);
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

    return StreamBuilder<List<RoutineWorkout>>(
        stream: widget.database.routineWorkoutsStream(widget.routine),
        builder: (context, snapshot) {
          final routineWorkouts = snapshot.data;

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
              child: FloatingActionButton.extended(
                onPressed: () => _submit(routineWorkouts!),
                backgroundColor: kPrimaryColor,
                heroTag: 'logRoutineSubmitButton',
                label: Text(S.current.submit),
              ),
            ),
          );
        });
  }

  Widget _buildBody() {
    final unit = Format.unitOfMass(widget.routine.initialUnitOfMass);

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
                  child: Text(S.current.done, style: kButtonText),
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
                  child: Text(S.current.done, style: kButtonText),
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
                  child: Text(S.current.done, style: kButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
