import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home/library_tab/routine/reorder_routine_workouts/reorder_routine_workouts_screen.dart';
import 'package:workout_player/styles/text_styles.dart';

// TODO: ADD FEATURE DISCOVERY FOR REORDER BUTTON
class ReorderRoutineWorkoutsButton extends StatelessWidget {
  final Routine routine;
  final List<RoutineWorkout?> list;

  const ReorderRoutineWorkoutsButton({
    Key? key,
    required this.routine,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<EnsureVisibleState> ensureVisibleGlobalKey =
        GlobalKey<EnsureVisibleState>();

    final button = EnsureVisible(
      key: ensureVisibleGlobalKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S.current.editRoutineWorkoutOrder,
              style: TextStyles.body2_grey,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.reorder_rounded,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );

    return InkWell(
      // return DescribedFeatureOverlay(
      //   featureId: 'reorder_routine_workouts',
      //   tapTarget: button,
      //   title: Text(
      //     'New Feature!',
      //     style: TextStyles.headline6,
      //   ),
      //   description: Text(
      //     'Change background of the progress tab',
      //     style: TextStyles.body2,
      //   ),
      //   backgroundColor: kPrimary800Color,
      //   targetColor: kPrimaryColor,
      //   textColor: Colors.white,
      //   onOpen: () async {
      //     WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      //       ensureVisibleGlobalKey.currentState!.ensureVisible();
      //     });
      //     return true;
      //   },
      //   onComplete: () async {
      //     await FeatureDiscovery.clearPreferences(context, <String>{
      //       'choose_background',
      //     });
      //     return true;
      //   },
      //   child: InkWell(
      onTap: () => ReorderRoutineWorkoutsScreen.show(
        context,
        routine: routine,
        routineWorkouts: list,
      ),
      child: button,
      // ),
    );
  }
}
