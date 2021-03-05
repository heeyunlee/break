import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import '../../../format.dart';
import 'workout_set/workout_set_widget.dart';

Logger logger = Logger();

class WorkoutMediumCard extends StatefulWidget {
  WorkoutMediumCard({
    this.database,
    this.routine,
    this.routineWorkout,
    this.user,
  });

  final Database database;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final User user;

  @override
  _WorkoutMediumCardState createState() => _WorkoutMediumCardState();
}

class _WorkoutMediumCardState extends State<WorkoutMediumCard> {
  /// Add a New Set
  Future<void> _addNewSet() async {
    debugPrint('_addNewSet Button pressed');
    try {
      final routineWorkout = widget.routineWorkout;
      WorkoutSet newSet;

      if (routineWorkout.sets
          .where((element) => element.isRest == false)
          .isNotEmpty) {
        debugPrint('sets exist');

        /// Workout Set
        final List<WorkoutSet> sets = widget.routineWorkout.sets
            .where((element) => element.isRest == false)
            .toList();

        final String id = UniqueKey().toString();
        final int setIndex = sets.length + 1;

        // Get latest set data
        final WorkoutSet latestSet = sets.last;

        // Update new set value
        newSet = WorkoutSet(
          workoutSetId: id,
          isRest: false,
          index: setIndex,
          setTitle: 'Set $setIndex',
          weights: latestSet.weights,
          reps: latestSet.reps,
          restTime: 0,
        );
      } else {
        debugPrint('sets DO NOT exist');

        /// Workout Set
        final String id = UniqueKey().toString();
        final int setIndex = 1;

        // Create new set
        newSet = WorkoutSet(
          workoutSetId: id,
          isRest: false,
          index: setIndex,
          setTitle: 'Set $setIndex',
          weights: 0,
          reps: 0,
          restTime: 0,
        );
      }

      /// Routine Workout
      final int numberOfSets = routineWorkout.numberOfSets + 1;
      final int numberOfReps = routineWorkout.numberOfReps + newSet.reps;
      final double totalWeights =
          routineWorkout.totalWeights + (newSet.weights * newSet.reps);
      final int duration = routineWorkout.duration +
          (newSet.reps * routineWorkout.secondsPerRep ?? 2);

      final updatedRoutineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayUnion([newSet.toMap()]),
      };

      /// Routine
      final routine = {
        'totalWeights':
            widget.routine.totalWeights + (newSet.weights * newSet.reps),
        'duration': widget.routine.duration +
            (newSet.reps * widget.routineWorkout.secondsPerRep),
      };

      await widget.database
          .setWorkoutSet(
        widget.routine,
        widget.routineWorkout,
        updatedRoutineWorkout,
      )
          .then((value) async {
        await widget.database.updateRoutine(widget.routine, routine);
      });
      debugPrint('Added a new Set');
    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  /// Add new a Rest
  Future<void> _addNewRest() async {
    debugPrint('_addNewRest Button pressed');
    try {
      final routineWorkout = widget.routineWorkout;
      if (routineWorkout.sets
          .where((element) => element.isRest == true)
          .isNotEmpty) {
        debugPrint('rest exist');

        /// Workout Set
        final List<WorkoutSet> rests = widget.routineWorkout.sets
            .where((element) => element.isRest == true)
            .toList();

        final String id = UniqueKey().toString();
        final int restIndex = rests.length + 1;

        // Get latest set data
        final WorkoutSet latestRest = rests.last;

        // Create new set
        final WorkoutSet newSet = WorkoutSet(
          workoutSetId: id,
          isRest: true,
          index: restIndex,
          setTitle: 'Rest $restIndex',
          weights: 0,
          reps: 0,
          restTime: latestRest.restTime,
        );

        /// Routine Workout
        final int duration = routineWorkout.duration + newSet.restTime;

        final updatedRoutineWorkout = {
          'duration': duration,
          'sets': FieldValue.arrayUnion([newSet.toMap()]),
        };

        /// Routine
        final routine = {
          'duration': widget.routine.duration + newSet.restTime,
        };

        await widget.database
            .setWorkoutSet(
          widget.routine,
          widget.routineWorkout,
          updatedRoutineWorkout,
        )
            .then((value) async {
          await widget.database.updateRoutine(widget.routine, routine);
        });
        debugPrint('Added a new Rest');
      } else {
        debugPrint('rest DO NOT exist');

        /// Workout Set
        final String id = UniqueKey().toString();
        final int restIndex = 1;

        // Create new set
        final WorkoutSet newSet = WorkoutSet(
          workoutSetId: id,
          isRest: true,
          index: restIndex,
          setTitle: 'Rest $restIndex',
          weights: 0,
          reps: 0,
          restTime: 60,
        );

        /// Routine Workout
        final int duration = routineWorkout.duration + newSet.restTime;

        final updatedRoutineWorkout = {
          'duration': duration,
          'sets': FieldValue.arrayUnion([newSet.toMap()]),
        };

        /// Routine
        final now = Timestamp.now();

        final routine = {
          'duration': widget.routine.duration + newSet.restTime,
          'lastEditedDate': now,
        };

        await widget.database
            .setWorkoutSet(
          widget.routine,
          widget.routineWorkout,
          updatedRoutineWorkout,
        )
            .then((value) async {
          await widget.database.updateRoutine(widget.routine, routine);
        });
        debugPrint('Added a new Rest');
      }
    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
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
      await widget.database.deleteRoutineWorkout(routine, routineWorkout).then(
        (value) async {
          final routine = {
            'totalWeights':
                widget.routine.totalWeights - routineWorkout.totalWeights,
            'duration': widget.routine.duration - routineWorkout.duration,
          };
          await widget.database.updateRoutine(widget.routine, routine);
        },
      );
    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routine = widget.routine;
    final routineWorkout = widget.routineWorkout;

    // Sets
    final int numberOfSets = routineWorkout?.numberOfSets ?? 0;
    final String formattedNumberOfSets =
        '$numberOfSets ${(numberOfSets > 1) ? 'sets' : 'set'}';

    final weights = Format.weights(routineWorkout.totalWeights);
    final unit = Format.unitOfMass(routine.initialUnitOfMass);

    final formattedTotalWeights = (widget.routineWorkout.isBodyWeightWorkout &&
            widget.routineWorkout.totalWeights == 0)
        ? 'Bodyweight'
        : (widget.routineWorkout.isBodyWeightWorkout)
            ? 'Bodyweight + $weights $unit'
            : '$weights $unit';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: CardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.white,
          unselectedWidgetColor: Colors.white,
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
          title: (routineWorkout.workoutTitle.length > 24)
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: Text(routineWorkout.workoutTitle),
                )
              : Text(
                  routineWorkout.workoutTitle,
                  style: Headline6,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
          subtitle: Row(
            children: <Widget>[
              Text(formattedNumberOfSets, style: Subtitle2),
              const Text('  •  ', style: Subtitle2),
              Text(formattedTotalWeights, style: Subtitle2),
            ],
          ),
          childrenPadding: const EdgeInsets.all(0),
          maintainState: true,
          children: [
            if (routineWorkout.sets == null || routineWorkout.sets.isEmpty)
              const Divider(endIndent: 8, indent: 8, color: Grey700),
            if (routineWorkout.sets == null || routineWorkout.sets.isEmpty)
              Container(
                height: 80,
                child: const Center(
                  child: Text('Add a set', style: BodyText2),
                ),
              ),
            const Divider(endIndent: 8, indent: 8, color: Grey700),
            if (routineWorkout.sets != null)
              ListView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: routineWorkout.sets.length,
                itemBuilder: (context, index) {
                  return WorkoutSetWidget(
                    database: widget.database,
                    routine: widget.routine,
                    routineWorkout: routineWorkout,
                    set: routineWorkout.sets[index],
                    index: index,
                    user: widget.user,
                  );
                },
              ),
            if (routineWorkout.sets.isNotEmpty == true &&
                widget.user.userId == widget.routine.routineOwnerId)
              const Divider(endIndent: 8, indent: 8, color: Grey700),
            if (widget.user.userId == widget.routine.routineOwnerId)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    child: FlatButton(
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        _addNewSet();
                      },
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: Grey800,
                  ),
                  Container(
                    width: 100,
                    child: FlatButton(
                      child: const Icon(
                        Icons.timer_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        _addNewRest();
                      },
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: Grey800,
                  ),
                  Container(
                    width: 100,
                    child: FlatButton(
                      child: const Icon(
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

  Future<bool> _showModalBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: const Text(
          'Delete the workout? You cannot undo this process',
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Delete workout'),
            onPressed: () {
              _deleteRoutineWorkout(
                context,
                widget.routine,
                widget.routineWorkout,
              );
              Navigator.of(context).pop();

              // TODO: ADD SNACKBAR
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
