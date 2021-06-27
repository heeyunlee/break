import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'workout_set_widget.dart';

class RoutineWorkoutCard extends StatefulWidget {
  RoutineWorkoutCard({
    required this.database,
    required this.routine,
    required this.routineWorkout,
    required this.auth,
  });

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final AuthBase auth;

  @override
  _RoutineWorkoutCardState createState() => _RoutineWorkoutCardState();
}

class _RoutineWorkoutCardState extends State<RoutineWorkoutCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Add a New Set
  Future<void> _addNewSet() async {
    debugPrint('_addNewSet Button pressed');
    try {
      final routineWorkout = widget.routineWorkout;
      WorkoutSet newSet;

      if (routineWorkout.sets!
          .where((element) => element.isRest == false)
          .isNotEmpty) {
        debugPrint('sets exist');

        /// Workout Set
        final sets = widget.routineWorkout.sets!
            .where((element) => element.isRest == false)
            .toList();

        print('set length is ${sets.length}');

        final id = UniqueKey().toString();
        final setIndex = sets.length + 1;

        print('set Index is $setIndex');

        // Get latest set data
        final latestSet = sets.last;

        // Update new set value
        newSet = WorkoutSet(
          workoutSetId: id,
          isRest: false,
          index: setIndex,
          setTitle: 'Set $setIndex',
          weights: latestSet.weights,
          reps: latestSet.reps,
          restTime: 0,
          setIndex: setIndex,
        );
      } else {
        debugPrint('sets DO NOT exist');

        /// Workout Set
        final id = UniqueKey().toString();
        final setIndex = 1;

        // Create new set
        newSet = WorkoutSet(
          workoutSetId: id,
          isRest: false,
          index: setIndex,
          setTitle: 'Set $setIndex',
          weights: 0.00,
          reps: 0,
          restTime: 0,
          setIndex: setIndex,
        );
      }

      /// Routine Workout
      final numberOfSets = routineWorkout.numberOfSets + 1;
      final numberOfReps = routineWorkout.numberOfReps + newSet.reps!;
      final totalWeights =
          routineWorkout.totalWeights + (newSet.weights! * newSet.reps!);
      final duration = routineWorkout.duration +
          (newSet.reps! * routineWorkout.secondsPerRep);

      final updatedRoutineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayUnion([newSet.toJson()]),
      };

      /// Routine
      final routine = {
        'totalWeights':
            widget.routine.totalWeights + (newSet.weights! * newSet.reps!),
        'duration': widget.routine.duration +
            (newSet.reps! * widget.routineWorkout.secondsPerRep),
      };

      await widget.database
          .setWorkoutSet(
        routine: widget.routine,
        routineWorkout: widget.routineWorkout,
        data: updatedRoutineWorkout,
      )
          .then((value) async {
        await widget.database.updateRoutine(widget.routine, routine);
      });

      debugPrint('Added a new Set');
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// Add new a Rest
  Future<void> _addNewRest() async {
    debugPrint('_addNewRest Button pressed');
    try {
      final routineWorkout = widget.routineWorkout;
      if (routineWorkout.sets!
          .where((element) => element.isRest == true)
          .isNotEmpty) {
        debugPrint('rest exist');

        /// Workout Set
        final rests = widget.routineWorkout.sets!
            .where((element) => element.isRest == true)
            .toList();

        final id = UniqueKey().toString();
        final restIndex = rests.length + 1;

        // Get latest set data
        final latestRest = rests.last;

        // Create new set
        final newSet = WorkoutSet(
          workoutSetId: id,
          isRest: true,
          index: restIndex,
          setTitle: 'Rest $restIndex',
          weights: 0,
          reps: 0,
          restTime: latestRest.restTime,
          restIndex: restIndex,
        );

        /// Routine Workout
        final duration = routineWorkout.duration + newSet.restTime!;

        final updatedRoutineWorkout = {
          'duration': duration,
          'sets': FieldValue.arrayUnion([newSet.toJson()]),
        };

        /// Routine
        final routine = {
          'duration': widget.routine.duration + newSet.restTime!,
        };

        await widget.database
            .setWorkoutSet(
          routine: widget.routine,
          routineWorkout: widget.routineWorkout,
          data: updatedRoutineWorkout,
        )
            .then((value) async {
          await widget.database.updateRoutine(widget.routine, routine);
        });
        debugPrint('Added a new Rest');
      } else {
        debugPrint('rest DO NOT exist');

        /// Workout Set
        final id = UniqueKey().toString();
        final restIndex = 1;

        // Create new set
        final newSet = WorkoutSet(
          workoutSetId: id,
          isRest: true,
          index: restIndex,
          setTitle: 'Rest $restIndex',
          weights: 0,
          reps: 0,
          restTime: 60,
          restIndex: restIndex,
        );

        /// Routine Workout
        final duration = routineWorkout.duration + newSet.restTime!;

        final updatedRoutineWorkout = {
          'duration': duration,
          'sets': FieldValue.arrayUnion([newSet.toJson()]),
        };

        /// Routine
        final now = Timestamp.now();

        final routine = {
          'duration': widget.routine.duration + newSet.restTime!,
          'lastEditedDate': now,
        };

        await widget.database
            .setWorkoutSet(
          routine: widget.routine,
          routineWorkout: widget.routineWorkout,
          data: updatedRoutineWorkout,
        )
            .then((value) async {
          await widget.database.updateRoutine(widget.routine, routine);
        });
        debugPrint('Added a new Rest');
      }
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// Delete Routine Workout Method
  Future<void> _deleteRoutineWorkout(
    BuildContext context,
    Routine routine,
    RoutineWorkout routineWorkout,
  ) async {
    try {
      await widget.database.deleteRoutineWorkout(routine, routineWorkout);

      final updatedRoutine = {
        'totalWeights':
            widget.routine.totalWeights - routineWorkout.totalWeights,
        'duration': widget.routine.duration - routineWorkout.duration,
      };

      await widget.database.updateRoutine(widget.routine, updatedRoutine);

      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.deleteRoutineHistorySnackbarTitle,
        S.current.deleteRoutineWorkoutSnakbarMessage,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routine = widget.routine;
    final routineWorkout = widget.routineWorkout;

    // FORMATTING
    final numberOfSets = routineWorkout.numberOfSets;
    final formattedNumberOfSets = (numberOfSets > 1)
        ? '$numberOfSets ${S.current.sets}'
        : '$numberOfSets ${S.current.set}';

    final weights = Formatter.weights(routineWorkout.totalWeights);
    final unit = Formatter.unitOfMass(routine.initialUnitOfMass);

    final formattedTotalWeights = (widget.routineWorkout.isBodyWeightWorkout &&
            widget.routineWorkout.totalWeights == 0)
        ? S.current.bodyweight
        : (widget.routineWorkout.isBodyWeightWorkout)
            ? '${S.current.bodyweight} + $weights $unit'
            : '$weights $unit';

    final locale = Intl.getCurrentLocale();
    final translation = widget.routineWorkout.translated;
    final title = (translation.isEmpty)
        ? widget.routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? widget.routineWorkout.translated[locale]
            : widget.routineWorkout.workoutTitle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.white,
          unselectedWidgetColor: Colors.white,
          hintColor: Colors.white,
        ),
        child: ExpansionTile(
          leading: Container(
            height: 48,
            width: 24,
            child: Center(
              child: Text(
                routineWorkout.index.toString(),
                style: GoogleFonts.blackHanSans(
                  color: Colors.white,
                  fontSize: 24,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          initiallyExpanded: true,
          title: (title.length > 24)
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: Text(title, style: kHeadline6),
                )
              : Text(
                  title,
                  style: kHeadline6,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
          subtitle: Row(
            children: <Widget>[
              Text(formattedNumberOfSets, style: kSubtitle2),
              const Text('   |   ', style: kSubtitle2),
              Text(formattedTotalWeights, style: kSubtitle2),
            ],
          ),
          childrenPadding: const EdgeInsets.all(0),
          maintainState: true,
          children: [
            if (routineWorkout.sets == null || routineWorkout.sets!.isEmpty)
              const Divider(endIndent: 8, indent: 8, color: kGrey700),
            if (routineWorkout.sets == null || routineWorkout.sets!.isEmpty)
              Container(
                height: 80,
                child: Center(
                  child: Text(S.current.addASet, style: TextStyles.body2),
                ),
              ),
            const Divider(endIndent: 8, indent: 8, color: kGrey700),
            if (routineWorkout.sets != null)
              ListView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: routineWorkout.sets!.length,
                itemBuilder: (context, index) {
                  return WorkoutSetWidget(
                    database: widget.database,
                    routine: widget.routine,
                    routineWorkout: routineWorkout,
                    set: routineWorkout.sets![index],
                    index: index,
                    auth: widget.auth,
                    // user: widget.user,
                  );
                },
              ),
            if (routineWorkout.sets!.isNotEmpty == true &&
                widget.auth.currentUser!.uid == widget.routine.routineOwnerId)
              const Divider(endIndent: 8, indent: 8, color: kGrey700),
            if (widget.auth.currentUser!.uid == widget.routine.routineOwnerId)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    child: IconButton(
                      onPressed: () async {
                        await HapticFeedback.mediumImpact();
                        await _addNewSet();
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: kGrey800,
                  ),
                  Container(
                    width: 100,
                    child: IconButton(
                      icon: const Icon(
                        Icons.timer_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        await HapticFeedback.mediumImpact();
                        await _addNewRest();
                      },
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: kGrey800,
                  ),
                  Container(
                    width: 100,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        await _showModalBottomSheet();
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showModalBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          S.current.deleteRoutineWorkoutMessage,
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => _deleteRoutineWorkout(
              context,
              widget.routine,
              widget.routineWorkout,
            ),
            child: Text(S.current.deleteRoutineWorkoutButton),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.cancel),
        ),
      ),
    );
  }
}
