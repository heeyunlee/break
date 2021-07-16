import 'dart:io';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_workouts_tab/workout_set_widget/workout_set_widget.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class RoutineWorkoutCard extends StatelessWidget {
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

  /// Add new reps and weights
  Future<void> _addNewSet(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        await HapticFeedback.mediumImpact();
      }

      // WorkoutSet and RoutineWorkout
      final WorkoutSet? formerWorkoutSet = routineWorkout.sets.lastWhereOrNull(
        (element) => element.isRest == false,
      );

      final sets = routineWorkout.sets
          .where((element) => element.isRest == false)
          .toList();

      final id = Uuid().v1();

      final newSet = WorkoutSet(
        workoutSetId: id,
        isRest: false,
        index: routineWorkout.sets.length + 1,
        setIndex: sets.length + 1,
        setTitle: 'Set ${sets.length + 1}',
        weights: formerWorkoutSet?.weights ?? 0,
        reps: formerWorkoutSet?.reps ?? 0,
      );

      final reps = newSet.reps ?? 0;

      final numberOfSets = routineWorkout.numberOfSets + 1;
      final numberOfReps = routineWorkout.numberOfReps + newSet.reps!;
      final totalWeights =
          routineWorkout.totalWeights + (newSet.weights! * newSet.reps!);
      final duration =
          routineWorkout.duration + (reps * routineWorkout.secondsPerRep);

      final updatedRoutineWorkout = {
        'numberOfSets': numberOfSets,
        'numberOfReps': numberOfReps,
        'totalWeights': totalWeights,
        'duration': duration,
        'sets': FieldValue.arrayUnion([newSet.toJson()]),
      };

      await database.setWorkoutSet(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      // Routine
      final updatedRoutine = {
        'totalWeights': routine.totalWeights + (newSet.weights! * newSet.reps!),
        'duration':
            routine.duration + (newSet.reps! * routineWorkout.secondsPerRep),
      };

      await database.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  // Add new rest
  Future<void> _addNewRest(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        await HapticFeedback.mediumImpact();
      }

      final WorkoutSet? formerWorkoutSet = routineWorkout.sets.lastWhereOrNull(
        (element) => element.isRest == true,
      );

      final rests = routineWorkout.sets
          .where((element) => element.isRest == true)
          .toList();

      final id = Uuid().v1();

      final newSet = WorkoutSet(
        workoutSetId: id,
        isRest: true,
        index: routineWorkout.sets.length + 1,
        restIndex: rests.length + 1,
        setTitle: 'Rest ${rests.length + 1}',
        weights: 0,
        reps: 0,
        restTime: formerWorkoutSet?.restTime ?? 60,
      );

      final duration = routineWorkout.duration + newSet.restTime!;

      final updatedRoutineWorkout = {
        'duration': duration,
        'sets': FieldValue.arrayUnion([newSet.toJson()]),
      };

      await database.setWorkoutSet(
        routine: routine,
        routineWorkout: routineWorkout,
        data: updatedRoutineWorkout,
      );

      /// Routine
      final updatedRoutine = {
        'lastEditedDate': Timestamp.now(),
        'duration': routine.duration + newSet.restTime!,
      };

      await database.updateRoutine(routine, updatedRoutine);
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  // Delete Routine Workout Method
  Future<void> _deleteRoutineWorkout(BuildContext context) async {
    try {
      // Delete Routine Workout
      await database.deleteRoutineWorkout(
        routine,
        routineWorkout,
      );

      // Update Routine
      final updatedRoutine = {
        'totalWeights': routine.totalWeights - routineWorkout.totalWeights,
        'duration': routine.duration - routineWorkout.duration,
      };

      await database.updateRoutine(routine, updatedRoutine);

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
    // FORMATTING
    final numberOfSets = routineWorkout.numberOfSets;
    final formattedNumberOfSets = (numberOfSets > 1)
        ? '$numberOfSets ${S.current.sets}'
        : '$numberOfSets ${S.current.set}';

    final weights = Formatter.weights(routineWorkout.totalWeights);
    final unit = Formatter.unitOfMass(routine.initialUnitOfMass);

    final formattedTotalWeights =
        (routineWorkout.isBodyWeightWorkout && routineWorkout.totalWeights == 0)
            ? S.current.bodyweight
            : (routineWorkout.isBodyWeightWorkout)
                ? '${S.current.bodyweight} + $weights $unit'
                : '$weights $unit';

    final locale = Intl.getCurrentLocale();
    final translation = routineWorkout.translated;
    final title = translation.isEmpty
        ? routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? routineWorkout.translated[locale]
            : routineWorkout.workoutTitle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        leading: Container(
          height: 48,
          width: 48,
          child: Center(
            child: Text(
              routineWorkout.index.toString(),
              style: TextStyles.blackHans1,
            ),
          ),
        ),
        initiallyExpanded: true,
        title: (title.length > 24)
            ? FittedBox(
                fit: BoxFit.cover,
                child: Text(title, style: TextStyles.headline6),
              )
            : Text(
                title,
                style: TextStyles.headline6,
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
        subtitle: Row(
          children: <Widget>[
            Text(formattedNumberOfSets, style: TextStyles.subtitle2),
            const Text('   |   ', style: TextStyles.subtitle2),
            Text(formattedTotalWeights, style: TextStyles.subtitle2),
          ],
        ),
        childrenPadding: const EdgeInsets.all(0),
        maintainState: true,
        children: [
          const Divider(endIndent: 8, indent: 8, color: kGrey700),
          ListItemBuilder<WorkoutSet>(
            items: routineWorkout.sets,
            emptyContentWidget: Column(
              children: [
                Container(
                  height: 80,
                  child: Center(
                    child: Text(S.current.addASet, style: TextStyles.body2),
                  ),
                ),
                const Divider(endIndent: 8, indent: 8, color: kGrey700),
              ],
            ),
            itemBuilder: (context, item, index) {
              return WorkoutSetWidget(
                database: database,
                routine: routine,
                routineWorkout: routineWorkout,
                workoutSet: item,
                index: index,
                auth: auth,
              );
            },
          ),
          // if (routineWorkout.sets.isNotEmpty)
          //   ImplicitlyAnimatedList<WorkoutSet>(
          //     items: routineWorkout.sets,
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     areItemsTheSame: (a, b) => a.workoutSetId == b.workoutSetId,
          //     removeDuration: Duration(milliseconds: 200),
          //     insertDuration: Duration(milliseconds: 200),
          //     itemBuilder: (context, animation, item, index) {
          //       return SizeFadeTransition(
          //         sizeFraction: 0.7,
          //         curve: Curves.easeInOut,
          //         animation: animation,
          //         child: WorkoutSetWidget(
          //           database: database,
          //           routine: routine,
          //           routineWorkout: routineWorkout,
          //           workoutSet: item,
          //           index: index,
          //           auth: auth,
          //         ),
          //       );
          //     },
          //   ),
          if (routineWorkout.sets.isNotEmpty == true &&
              auth.currentUser!.uid == routine.routineOwnerId)
            const Divider(endIndent: 8, indent: 8, color: kGrey700),
          if (auth.currentUser!.uid == routine.routineOwnerId)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  child: IconButton(
                    onPressed: () => _addNewSet(context),
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
                    onPressed: () => _addNewRest(context),
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
                    onPressed: () => _showModalBottomSheet(context),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<bool?> _showModalBottomSheet(BuildContext context) {
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
            onPressed: () => _deleteRoutineWorkout(context),
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
