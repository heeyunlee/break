import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/proteins_eaten/weekly_nutrition_chart_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

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
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _interval = (widget.user.dailyProteinGoal != null)
        ? widget.user.dailyProteinGoal! / widget.model.nutritionMaxY * 10
        : 1.00;
    widget.model.setRelativeList(widget.nutritions);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: BarChart(
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
                      (rod.y / 1.05 / 10 * widget.model.nutritionMaxY).round();
                  final formattedAmount = Formatter.proteins(amount);

                  return BarTooltipItem(
                    '$formattedAmount g',
                    kBodyText1Black,
                  );
                },
              ),
              touchCallback: (barTouchResponse) {
                setState(() {
                  if (barTouchResponse.spot != null &&
                      barTouchResponse.touchInput is! PointerExitEvent &&
                      barTouchResponse.touchInput is! PointerUpEvent) {
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
              },
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
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.05 * y : y,
          colors: isTouched ? [Colors.green] : [Colors.greenAccent],
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

  // TODO: Polish code here
  List<BarChartGroupData> _barGroupsChild() {
    return [
      _makeBarChartGroupData(
        x: 0,
        y: widget.model.relativeYs[0],
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: widget.model.relativeYs[1],
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: widget.model.relativeYs[2],
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: widget.model.relativeYs[3],
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: widget.model.relativeYs[4],
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: widget.model.relativeYs[5],
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: widget.model.relativeYs[6],
        isTouched: touchedIndex == 6,
      ),
    ];
  }

  List<BarChartGroupData> randomData() {
    return [
      _makeBarChartGroupData(x: 0, y: 7, isTouched: touchedIndex == 0),
      _makeBarChartGroupData(x: 1, y: 6, isTouched: touchedIndex == 1),
      _makeBarChartGroupData(x: 2, y: 8.9, isTouched: touchedIndex == 2),
      _makeBarChartGroupData(x: 3, y: 8, isTouched: touchedIndex == 3),
      _makeBarChartGroupData(x: 4, y: 6.8, isTouched: touchedIndex == 4),
      _makeBarChartGroupData(x: 5, y: 10, isTouched: touchedIndex == 5),
      _makeBarChartGroupData(x: 6, y: 9, isTouched: touchedIndex == 6),
    ];
  }
}
