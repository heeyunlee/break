import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:workout_player/models/combined/auth_and_database.dart';
import 'package:workout_player/view/widgets/library/workout_set_widget.dart';
import 'package:workout_player/view_models/workout_set_widget_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

import '../../../view_models/routine_workout_card_model.dart';

class RoutineWorkoutCard extends ConsumerWidget {
  final int index;
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final AuthAndDatabase authAndDatabase;

  const RoutineWorkoutCard({
    required this.index,
    required this.routine,
    required this.routineWorkout,
    required this.authAndDatabase,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(routineWorkoutCardModelProvider(authAndDatabase));
    final workoutSetModel = watch(
      workoutSetWidgetModelProvider(authAndDatabase),
    );

    final bool isOwner =
        authAndDatabase.auth.currentUser!.uid == routine.routineOwnerId;

    // FORMATTING
    final numberOfSets = routineWorkout.numberOfSets;
    final formattedNumberOfSets = (numberOfSets > 1)
        ? '$numberOfSets ${S.current.sets}'
        : '$numberOfSets ${S.current.set}';

    final weights = Formatter.numWithOrWithoutDecimal(
      routineWorkout.totalWeights,
    );

    final unit = Formatter.unitOfMass(
      routine.initialUnitOfMass,
      routine.unitOfMassEnum,
    );

    final formattedTotalWeights =
        (routineWorkout.isBodyWeightWorkout && routineWorkout.totalWeights == 0)
            ? S.current.bodyweight
            : (routineWorkout.isBodyWeightWorkout)
                ? '${S.current.bodyweight} + $weights $unit'
                : '$weights $unit';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        leading: SizedBox(
          height: 48,
          width: 48,
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: TextStyles.blackHans1,
            ),
          ),
        ),
        // initiallyExpanded: false,
        title: _buildTitle(),
        subtitle: Row(
          children: <Widget>[
            Text(formattedNumberOfSets, style: TextStyles.subtitle2),
            const Text('   |   ', style: TextStyles.subtitle2),
            Text(formattedTotalWeights, style: TextStyles.subtitle2),
          ],
        ),
        childrenPadding: EdgeInsets.zero,
        maintainState: true,
        children: [
          kCustomDividerIndent8,
          if (routineWorkout.sets.isEmpty)
            Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(S.current.addASet, style: TextStyles.body2),
                  ),
                ),
                kCustomDividerIndent8,
              ],
            ),
          if (routineWorkout.sets.isNotEmpty)
            ImplicitlyAnimatedList<WorkoutSet>(
              items: routineWorkout.sets,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              areItemsTheSame: (a, b) => a.workoutSetId == b.workoutSetId,
              removeDuration: const Duration(milliseconds: 200),
              insertDuration: const Duration(milliseconds: 200),
              itemBuilder: (context, animation, item, index) {
                return SizeFadeTransition(
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  animation: animation,
                  child: WorkoutSetWidget(
                    database: authAndDatabase.database,
                    routine: routine,
                    routineWorkout: routineWorkout,
                    workoutSet: item,
                    index: index,
                    auth: authAndDatabase.auth,
                    model: workoutSetModel,
                  ),
                );
              },
            ),
          if (routineWorkout.sets.isNotEmpty == true && isOwner)
            kCustomDividerIndent8,
          if (isOwner)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: IconButton(
                    onPressed: () => model.addNewSet(
                      context,
                      routine: routine,
                      routineWorkout: routineWorkout,
                    ),
                    icon: const Icon(Icons.add_rounded, color: Colors.grey),
                  ),
                ),
                Container(height: 36, width: 1, color: kGrey800),
                SizedBox(
                  width: 100,
                  child: IconButton(
                    onPressed: () => model.addNewRest(
                      context,
                      routine: routine,
                      routineWorkout: routineWorkout,
                    ),
                    icon: const Icon(Icons.timer_rounded, color: Colors.grey),
                  ),
                ),
                Container(height: 36, width: 1, color: kGrey800),
                SizedBox(
                  width: 100,
                  child: IconButton(
                    onPressed: () => _showModalBottomSheet(context, model),
                    icon: const Icon(Icons.delete_rounded, color: Colors.grey),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final title = Formatter.localizedTitle(
      routineWorkout.workoutTitle,
      routineWorkout.translated,
    );

    if (title.length > 24) {
      return FittedBox(
        fit: BoxFit.cover,
        child: Text(title, style: TextStyles.headline6),
      );
    } else {
      return Text(
        title,
        style: TextStyles.headline6,
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
      );
    }
  }

  Future<bool?> _showModalBottomSheet(
    BuildContext context,
    RoutineWorkoutCardModel model,
  ) {
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
            onPressed: () => model.deleteRoutineWorkout(
              context,
              routine: routine,
              routineWorkout: routineWorkout,
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
