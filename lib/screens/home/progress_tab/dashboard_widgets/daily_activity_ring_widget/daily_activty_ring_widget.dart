import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/combined/progress_tab_class.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'daily_activity_ring_widget_model.dart';
import 'daily_summary_numbers_widget.dart';

class DailyActivityRingWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final ProgressTabClass progressTabClass;

  const DailyActivityRingWidget({
    Key? key,
    required this.constraints,
    required this.progressTabClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;

    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight / heightFactor,
      child: Consumer(
        builder: (context, watch, child) {
          final model = watch(dailyActivityRingWidgetModelProvider);

          model.setDailyGoal(progressTabClass.user);
          model.setDailyTotal(
            progressTabClass.selectedDayNutritions,
            progressTabClass.selectedDayRoutineHistories,
          );

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth / 2 - 16,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildMuscleWorked(model),
                    CircularPercentIndicator(
                      radius: (constraints.maxWidth / 2 * 0.65),
                      lineWidth: 12,
                      percent: model.nutritionDailyProgress,
                      backgroundColor: Colors.greenAccent.withOpacity(0.25),
                      progressColor: Colors.greenAccent,
                      animation: true,
                      animationDuration: 1000,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    FittedBox(
                      child: CircularPercentIndicator(
                        radius: (constraints.maxWidth - 48) / 2,
                        lineWidth: 12,
                        percent: model.weightsLiftedDailyProgress,
                        backgroundColor: kPrimaryColor.withOpacity(0.25),
                        progressColor: kPrimaryColor,
                        animation: true,
                        animationDuration: 1000,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth / 2 - 16,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTotalWeightsWidget(model),
                      const SizedBox(height: 8),
                      _buildTotalNutritionWidget(model),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMuscleWorked(DailyActivityRingWidgetModel model) {
    if (model.todaysMuscleWorked.length == 1) {
      return Text(
        model.todaysMuscleWorked,
        style: TextStyles.headline4_w900,
      );
    } else {
      return SizedBox(
        width: constraints.maxWidth / 5,
        child: FittedBox(
          alignment: Alignment.center,
          child: Text(
            model.todaysMuscleWorked,
            style: TextStyles.headline5_w900,
          ),
        ),
      );
    }
  }

  Widget _buildTotalWeightsWidget(DailyActivityRingWidgetModel model) {
    String? tensOfThousands;
    String? thousands;
    String? hundreds;
    String? tens;
    String? ones;

    int length = model.weightsLiftedDailyTotal.toString().length - 1;
    String totalWeightsInString = model.weightsLiftedDailyTotal.toString();

    ones = totalWeightsInString[length];
    tens = (length > 0) ? totalWeightsInString[length - 1] : '0';
    hundreds = (length > 1) ? totalWeightsInString[length - 2] : '0';
    thousands = (length > 2) ? totalWeightsInString[length - 3] : '0';
    tensOfThousands = (length > 3) ? totalWeightsInString[length - 4] : '0';

    final unit = Formatter.unitOfMass(progressTabClass.user.unitOfMass);

    return DailySummaryNumbersWidget(
      title: S.current.liftedWeights,
      tensOfTousands: tensOfThousands,
      thousands: thousands,
      hundreds: hundreds,
      tens: tens,
      ones: ones,
      unit: unit,
    );
  }

  Widget _buildTotalNutritionWidget(DailyActivityRingWidgetModel model) {
    String? hundreds;
    String? tens;
    String? ones;

    int length = model.nutritionDailyTotal.toString().length - 1;
    String totalProteinsInString = model.nutritionDailyTotal.toString();

    ones = totalProteinsInString[length];
    tens = (length > 0) ? totalProteinsInString[length - 1] : '0';
    hundreds = (length > 1) ? totalProteinsInString[length - 2] : '0';

    return DailySummaryNumbersWidget(
      title: S.current.proteins,
      backgroundColor: Colors.greenAccent,
      textStyle: TextStyles.body1_menlo_black,
      hundreds: hundreds,
      tens: tens,
      ones: ones,
      unit: 'g',
    );
  }
}
