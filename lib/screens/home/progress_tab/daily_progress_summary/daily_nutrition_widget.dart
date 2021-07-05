import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../progress_tab_model.dart';
import 'daily_summary_numbers_widget.dart';

class DailyNutritionWidget extends StatelessWidget {
  final User user;
  final ProgressTabModel model;

  const DailyNutritionWidget({
    required this.user,
    required this.model,
  });

  static Widget create({
    required User user,
    required ProgressTabModel model,
  }) {
    return DailyNutritionWidget(
      user: user,
      model: model,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilderWidget<List<Nutrition>?>(
      stream: model.database!.nutritionsSelectedDayStream(model.selectedDate),
      loadingWidget: Container(),
      hasDataWidget: (context, data) {
        model.setNutritionDailyGoal(user.dailyProteinGoal);
        model.setNutritionDailyTotal(data);

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width / 2.4,
              child: Center(
                child: CircularPercentIndicator(
                  radius: size.width / 3,
                  lineWidth: 12,
                  percent: model.nutritionDailyProgress,
                  backgroundColor: Colors.greenAccent.withOpacity(0.25),
                  progressColor: Colors.greenAccent,
                  animation: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                SizedBox(height: size.height / 13),
                SizedBox(height: size.height / 13),
                SizedBox(
                  height: size.height / 13,
                  child: _buildTotalNutritionWidget(),
                ),
                SizedBox(height: size.height / 13),
              ],
            ),
          ],
        );
      },
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
