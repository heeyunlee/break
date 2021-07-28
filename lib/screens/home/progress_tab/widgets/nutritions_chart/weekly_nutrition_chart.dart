import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/classes/nutrition.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/widgets/no_data_in_chart_message_widget.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'weekly_nutrition_chart_model.dart';

class WeeklyNutritionChart extends StatefulWidget {
  final WeeklyNutritionChartModel model;
  final List<Nutrition> nutritions;
  final User user;

  const WeeklyNutritionChart({
    Key? key,
    required this.model,
    required this.nutritions,
    required this.user,
  }) : super(key: key);

  @override
  _WeeklyNutritionChartState createState() => _WeeklyNutritionChartState();
}

class _WeeklyNutritionChartState extends State<WeeklyNutritionChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.init();
  }

  @override
  Widget build(BuildContext context) {
    widget.model.setRelativeList(widget.nutritions, widget.user);

    final _interval = (widget.user.dailyProteinGoal != null)
        ? widget.user.dailyProteinGoal! / widget.model.nutritionMaxY * 10
        : 1.00;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Stack(
          children: [
            BarChart(
              BarChartData(
                maxY: 10,
                gridData: FlGridData(
                  horizontalInterval: _interval,
                  drawVerticalLine: false,
                  show: widget.user.dailyProteinGoal != null,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.greenAccent.withOpacity(0.5),
                    dashArray: [16, 4],
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final amount =
                          (rod.y / 1.05 / 10 * widget.model.nutritionMaxY)
                              .round();
                      final formattedAmount = Formatter.proteins(amount);

                      return BarTooltipItem(
                        '$formattedAmount g',
                        TextStyles.body1_black,
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
                    margin: 24,
                    reservedSize: 24,
                    getTextStyles: (_) => TextStyles.caption1_grey,
                    getTitles: (double value) {
                      final toOriginalNumber =
                          (value / 10 * widget.model.nutritionMaxY).round();

                      switch (value.toInt()) {
                        case 0:
                          return '0g';
                        case 5:
                          return '$toOriginalNumber g';
                        case 10:
                          return '$toOriginalNumber g';

                        default:
                          return '';
                      }
                    },
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: (widget.nutritions.isNotEmpty)
                    ? _barGroupsChild()
                    : randomData(),
              ),
            ),
            if (widget.nutritions.isEmpty)
              NoDataInChartMessageWidget(
                color: Colors.greenAccent,
                textStyle: TextStyles.caption1_black,
              ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _barGroupsChild() {
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
    List<double> listOfYs = [7, 6, 9.7, 4, 10, 5, 9.5];

    return List.generate(
      listOfYs.length,
      (index) => _makeBarChartGroupData(
        x: index,
        y: listOfYs[index],
        defaultColor: Colors.greenAccent.withOpacity(0.25),
        touchedColor: Colors.green.withOpacity(0.50),
        isTouched: widget.model.touchedIndex == index,
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
    bool isTouched = false,
    Color defaultColor = Colors.greenAccent,
    Color touchedColor = Colors.green,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.05 * y : y,
          colors: isTouched ? [touchedColor] : [defaultColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
            y: 10,
            colors: [kCardColorLight],
          ),
        ),
      ],
    );
  }
}
