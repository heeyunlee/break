import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutritions_and_routine_histories.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../../progress_tab_model.dart';
import 'daily_summary_numbers_widget.dart';

class DailyActivityRingWidget extends StatelessWidget {
  final Database database;
  final AuthBase auth;
  final User user;
  final ProgressTabModel model;

  const DailyActivityRingWidget({
    required this.database,
    required this.auth,
    required this.user,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilderWidget<NutritionsAndRoutineHistories>(
      stream: database.nutritionsAndRoutineHistoriesStream(model.selectedDate),
      hasDataWidget: (context, data) {
        model.setDailyGoal(user);
        model.setDailyTotal(data);

        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth / 2,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (model.todaysMuscleWorked == '-')
                          Text('-', style: TextStyles.headline5_w900),
                        if (model.todaysMuscleWorked != '-')
                          SizedBox(
                            width: constraints.maxWidth / 5,
                            child: FittedBox(
                              alignment: Alignment.center,
                              child: Text(
                                model.todaysMuscleWorked,
                                style: TextStyles.headline5_w900,
                              ),
                            ),
                          ),
                        CircularPercentIndicator(
                          radius: (constraints.maxWidth - 104) / 2,
                          lineWidth: 12,
                          percent: model.nutritionDailyProgress,
                          backgroundColor: Colors.greenAccent.withOpacity(0.25),
                          progressColor: Colors.greenAccent,
                          animation: true,
                          animationDuration: 1000,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        CircularPercentIndicator(
                          radius: (constraints.maxWidth - 48) / 2,
                          lineWidth: 12,
                          percent: model.weightsLiftedDailyProgress,
                          backgroundColor: kPrimaryColor.withOpacity(0.25),
                          progressColor: kPrimaryColor,
                          animation: true,
                          animationDuration: 1000,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTotalWeightsWidget(),
                        const SizedBox(height: 8),
                        _buildTotalNutritionWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTotalWeightsWidget() {
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

    final unit = Formatter.unitOfMass(user.unitOfMass);

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

  Widget _buildTotalNutritionWidget() {
    String? hundreds;
    String? tens;
    String? ones;

    // if (data != null) {
    int length = model.nutritionDailyTotal.toString().length - 1;
    String totalProteinsInString = model.nutritionDailyTotal.toString();

    ones = totalProteinsInString[length];
    tens = (length > 0) ? totalProteinsInString[length - 1] : '0';
    hundreds = (length > 1) ? totalProteinsInString[length - 2] : '0';
    // }

    return DailySummaryNumbersWidget(
      title: S.current.proteins,
      backgroundColor: Colors.greenAccent,
      textStyle: kBodyText1MenloBlack,
      hundreds: hundreds,
      tens: tens,
      ones: ones,
      unit: 'g',
    );
  }
}
