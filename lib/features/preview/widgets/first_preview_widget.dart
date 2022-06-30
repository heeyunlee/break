import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/providers.dart' show previewScreenState;
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/progress/progress_widgets.dart';

class FirstPreviewWidget extends StatelessWidget {
  const FirstPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widgets = _previewWidgets(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(previewScreenState);

            return VisibilityDetector(
              key: const Key('preview-widgets'),
              onVisibilityChanged: (info) => model.onVisibilityChanged(
                info,
                widgets.length,
              ),
              child: SizedBox(
                height: size.width,
                width: size.width,
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: widgets[model.currentWidgetIndex],
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: size.height / 10,
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyles.body1Menlo,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  RotateAnimatedText(S.current.previewScreenMessage1),
                  RotateAnimatedText(
                    S.current.previewScreenMessage2,
                    textAlign: TextAlign.center,
                  ),
                  RotateAnimatedText(
                    S.current.previewScreenMessage3,
                    textAlign: TextAlign.center,
                  ),
                  RotateAnimatedText(S.current.previewScreenMessage4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _previewWidgets(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return [
      MostRecentWorkout(
        cardMargin: const EdgeInsets.all(24),
        contentPadding: const EdgeInsets.all(16),
        workoutEndTime: DateTime.now(),
        routineTitle: 'Chest Workout',
        totalWeights: 12000,
        unit: UnitOfMass.kilograms,
        durationInMins: 75,
      ),
      ActivityRing(
        width: size.width,
        height: size.height,
        muscleName: 'Chest',
        liftedWeights: 10000,
        weightGoal: 20000,
        consumedProtein: 75,
        proteinGoal: 150,
        unit: UnitOfMass.kilograms,
        cardColor: Colors.transparent,
        elevation: 0,
      ),
      WeeklyBarChart(
        cardMargin: const EdgeInsets.all(24),
        height: 340,
        color: Colors.red,
        leadingIcon: Icons.fitness_center_rounded,
        yValues: const [7500, 2000, 3000, 5000, 10000, 5000, 9500],
        title: 'Lift Weights',
        unit: UnitOfMass.kilograms.label,
      ),
      WeeklyWorkoutSummary(
        height: 163,
        weeklyWorkedOutMuscles: [
          null,
          S.current.chest,
          S.current.back,
          S.current.lowerBody,
          null,
          S.current.shoulder,
          S.current.chest,
        ],
      ),
      WeeklyBarChart(
        cardMargin: const EdgeInsets.all(24),
        height: 340,
        color: Colors.green,
        leadingIcon: Icons.local_fire_department_outlined,
        title: S.current.consumedCalorie,
        unit: 'Kcal',
        yValues: const [2000, 1500, 0, 2400, 2600, 3200, 3300],
      ),
      WeeklyBarChart(
        cardMargin: const EdgeInsets.all(24),
        height: 340,
        color: Colors.green,
        leadingIcon: Icons.local_fire_department_outlined,
        title: 'Eat Proteins',
        unit: UnitOfMass.kilograms.gram,
        yValues: const [150, 140, 123, 150, 120, 160, 100],
      ),

      // const LatestBodyFatSampleWidget(padding: 16),
      // const WeeklyMeasurementsSampleWidget(padding: 24),
      // const LatestBodyWeightSampleWidget(padding: 16),
    ];
  }
}
