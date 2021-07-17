import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/progress_tab_class.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

import 'routine_histories_screen.dart';
import 'weekly_lifted_weights_chart.dart';
import 'weekly_lifted_weights_chart_model.dart';

class WeeklyLiftedWeightsCard extends StatelessWidget {
  final ProgressTabClass progressTabClass;
  final BoxConstraints constraints;

  const WeeklyLiftedWeightsCard({
    Key? key,
    required this.progressTabClass,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 2 : 1.5;

    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight / heightFactor,
      child: BlurBackgroundCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => RoutineHistoriesScreen.show(context),
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.fitness_center_rounded,
                            color: kPrimaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            S.current.liftedWeights,
                            style: kSubtitle1w900Primary,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: kPrimaryColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        S.current.weightsChartMessage,
                        style: TextStyles.body2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, watch, child) => WeeklyLiftedWeightsChart(
                  routineHistories: progressTabClass.routineHistories,
                  model: watch(weeklyLiftedWeightsChartModelProvider),
                  user: progressTabClass.user,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
