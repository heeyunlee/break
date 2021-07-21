import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/classes/routine_history.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'weekly_lifted_weights_chart_model.dart';
import '../../../../../widgets/no_data_in_chart_message_widget.dart';

class WeeklyLiftedWeightsChart extends StatefulWidget {
  final WeeklyLiftedWeightsChartModel model;
  final User user;
  final List<RoutineHistory> routineHistories;

  const WeeklyLiftedWeightsChart({
    Key? key,
    required this.model,
    required this.user,
    required this.routineHistories,
  }) : super(key: key);

  @override
  _WeeklyLiftedWeightsChartState createState() =>
      _WeeklyLiftedWeightsChartState();
}

class _WeeklyLiftedWeightsChartState extends State<WeeklyLiftedWeightsChart> {
  @override
  Widget build(BuildContext context) {
    widget.model.init();
    widget.model.setData(widget.routineHistories, widget.user);

    final _interval = (widget.user.dailyWeightsGoal != null)
        ? widget.user.dailyWeightsGoal! / widget.model.weightsLiftedMaxY * 10
        : 1.00;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 8),
        child: Stack(
          children: [
            BarChart(
              BarChartData(
                maxY: 10,
                gridData: FlGridData(
                  horizontalInterval: _interval,
                  drawVerticalLine: false,
                  show: widget.user.dailyWeightsGoal != null,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: kPrimaryColor.withOpacity(0.5),
                    dashArray: [16, 4],
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final weights =
                          (rod.y / 1.05 / 10 * widget.model.weightsLiftedMaxY)
                              .round();
                      final formattedWeights = Formatter.weights(weights);
                      final unit = Formatter.unitOfMass(widget.user.unitOfMass);

                      return BarTooltipItem(
                        '$formattedWeights $unit',
                        kBodyText1Black,
                      );
                    },
                  ),
                  touchCallback: widget.model.onTouchCallback,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => TextStyles.body2,
                    margin: 16,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return widget.model.daysOfTheWeek[0];
                        case 1:
                          return widget.model.daysOfTheWeek[1];
                        case 2:
                          return widget.model.daysOfTheWeek[2];
                        case 3:
                          return widget.model.daysOfTheWeek[3];
                        case 4:
                          return widget.model.daysOfTheWeek[4];
                        case 5:
                          return widget.model.daysOfTheWeek[5];
                        case 6:
                          return widget.model.daysOfTheWeek[6];
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    margin: 28,
                    getTextStyles: (_) => TextStyles.caption1_grey,
                    getTitles: (double value) {
                      final toOriginalNumber =
                          (value / 10 * widget.model.weightsLiftedMaxY.round());
                      final formatted =
                          NumberFormat.compact().format(toOriginalNumber);
                      final unit = Formatter.unitOfMass(widget.user.unitOfMass);

                      switch (value.toInt()) {
                        case 0:
                          return '0 $unit';
                        case 5:
                          return '$formatted $unit';
                        case 10:
                          return '$formatted $unit';
                        default:
                          return '';
                      }
                    },
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: (widget.model.relativeYs.isNotEmpty)
                    ? _hasData()
                    : randomData(),
              ),
            ),
            if (widget.model.relativeYs.isEmpty)
              const NoDataInChartMessageWidget(),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _hasData() {
    return List.generate(
      7,
      (index) => _makeBarChartGroupData(
        x: index,
        y: widget.model.relativeYs[index],
        isTouched: widget.model.touchedIndex == index,
      ),
    );
  }

  List<BarChartGroupData> randomData() {
    List<double> listOfYs = [8, 7, 8, 2, 9, 10, 9.5];

    return List.generate(
      listOfYs.length,
      (index) => _makeBarChartGroupData(
        x: index,
        y: listOfYs[index],
        isTouched: widget.model.touchedIndex == index,
        defaultColor: kPrimaryColor.withOpacity(0.25),
        touchedColor: kPrimaryColor.withOpacity(0.50),
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
    bool isTouched = false,
    Color defaultColor = kPrimaryColor,
    Color touchedColor = kPrimary700Color,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y * 1.05 : y,
          colors: isTouched ? [touchedColor] : [defaultColor],
          width: width,
        ),
      ],
    );
  }
}
