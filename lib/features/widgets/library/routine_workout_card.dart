import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/widgets/library/workout_set_rest_widget.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/routine_workout_card_model.dart';

class RoutineWorkoutCard extends ConsumerWidget {
  const RoutineWorkoutCard({
    Key? key,
    required this.index,
    required this.routine,
    required this.routineWorkout,
  }) : super(key: key);

  final int index;
  final Routine routine;
  final RoutineWorkout routineWorkout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(routineWorkoutCardModelProvider);
    final workoutSetModel = ref.watch(workoutSetWidgetModelProvider);
    final workoutSetRestModel = ref.watch(workoutSetRestWidgetModelProvider);
    final routineWorkoutCardModel = ref.watch(routineWorkoutCardModelProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        childrenPadding: EdgeInsets.zero,
        maintainState: true,
        initiallyExpanded: true,
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
        title: _buildTitle(),
        subtitle: Row(
          children: <Widget>[
            Text(
              RoutineWorkoutCardModel.numberOfSets(routineWorkout),
              style: TextStyles.subtitle2,
            ),
            const Text('   |   ', style: TextStyles.subtitle2),
            Text(
              RoutineWorkoutCardModel.totalWeights(routine, routineWorkout),
              style: TextStyles.subtitle2,
            ),
          ],
        ),
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
            CustomListViewBuilder<WorkoutSet>(
              items: routineWorkout.sets,
              itemBuilder: (context, item, index) {
                if (item.isRest) {
                  return WorkoutSetRestWidget(
                    routine: routine,
                    routineWorkout: routineWorkout,
                    workoutSet: item,
                    model: model,
                    index: index,
                    setRestWidgetModel: workoutSetRestModel,
                  );
                } else {
                  return WorkoutSetWidget(
                    routine: routine,
                    routineWorkout: routineWorkout,
                    workoutSet: item,
                    index: index,
                    model: workoutSetModel,
                  );
                }
              },
            ),
          if (routineWorkout.sets.isNotEmpty == true &&
              routineWorkoutCardModel.isOwner(routine))
            kCustomDividerIndent8,
          if (routineWorkoutCardModel.isOwner(routine))
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
                Container(height: 36, width: 1, color: Colors.grey[700]),
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
                Container(height: 36, width: 1, color: Colors.grey[700]),
                SizedBox(
                  width: 100,
                  child: IconButton(
                    onPressed: () => _showModalBottomSheet(
                      HomeScreenModel.homeScreenNavigatorKey.currentContext!,
                      model,
                    ),
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.grey,
                    ),
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
    return showAdaptiveModalBottomSheet(
      context,
      useRootNavigator: false,
      message: S.current.deleteRoutineWorkoutMessage,
      cancelText: S.current.cancel,
      isCancelDefault: true,
      firstActionText: S.current.deleteRoutineWorkoutButton,
      isFirstActionDefault: false,
      firstActionOnPressed: () => model.deleteRoutineWorkout(
        context,
        routine: routine,
        routineWorkout: routineWorkout,
      ),
    );
  }
}
