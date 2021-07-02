import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../progress_tab_model.dart';
import 'daily_summary_numbers_widget.dart';

class DailyNutritionWidget extends StatelessWidget {
  final Database database;
  final AuthBase auth;
  final User user;
  final ProgressTabModel model;

  const DailyNutritionWidget({
    required this.database,
    required this.auth,
    required this.user,
    required this.model,
  });

  static Widget create(
    BuildContext context, {
    required User user,
    required ProgressTabModel model,
  }) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return DailyNutritionWidget(
      database: database,
      auth: auth,
      user: user,
      model: model,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilderWidget<List<Nutrition>?>(
      stream: database.nutritionsSelectedDayStream(model.selectedDate),
      loadingWidget: Container(),
      hasDataWidget: (context, data) {
        model.setNutritionDailyGoal(user.dailyProteinGoal);
        model.setNutritionDailyTotal(data);

        // () => model.setNutritionDailyGoal(user.dailyProteinGoal);
        // () => model.setNutritionDailyTotal(data);
        // num _proteinGoal = user.dailyProteinGoal ?? 150.0;

        // late num _totalProteins = 0;
        // late double _proteinsProgress = 0;

        // if (data != null) {
        //   data.forEach((e) {
        //     _totalProteins += e.proteinAmount.toInt();
        //   });
        //   // _proteinsProgress = _totalProteins / _proteinGoal;
        //   _proteinsProgress = _totalProteins / model.nutritionDailyGoal;

        //   if (_proteinsProgress >= 1) {
        //     _proteinsProgress = 1;
        //   }
        // }

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
                  child: _buildTotalNutritionWidget(
                      // data,
                      // model.nutritionDailyTotal,
                      ),
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
