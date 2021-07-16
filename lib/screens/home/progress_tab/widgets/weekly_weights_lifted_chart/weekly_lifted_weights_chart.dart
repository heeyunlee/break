import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'weekly_lifted_weights_chart_model.dart';

class WeeklyLiftedWeightsChart extends StatefulWidget {
  final User user;
  final WeeklyLiftedWeightsChartModel model;
  final List<RoutineHistory> routineHistories;

  const WeeklyLiftedWeightsChart({
    Key? key,
    required this.user,
    required this.model,
    required this.routineHistories,
  }) : super(key: key);

  @override
  _WeeklyLiftedWeightsChartState createState() =>
      _WeeklyLiftedWeightsChartState();
}

class _WeeklyLiftedWeightsChartState extends State<WeeklyLiftedWeightsChart> {
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
    widget.model.setData(widget.routineHistories, widget.user);

    final _interval = (widget.user.dailyWeightsGoal != null)
        ? widget.user.dailyWeightsGoal! / widget.model.maxY * 10
        : 1.00;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 8),
        child: BarChart(
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
                      (rod.y / 1.05 / 10 * widget.model.maxY).round();
                  final formattedWeights = Formatter.weights(weights);
                  final unit = Formatter.unitOfMass(widget.user.unitOfMass);

                  return BarTooltipItem(
                    '$formattedWeights $unit',
                    kBodyText1Black,
                  );
                },
              ),
              touchCallback: (barTouchResponse) {
                setState(() {
                  if (barTouchResponse.spot != null &&
                      barTouchResponse.touchInput is! PointerUpEvent &&
                      barTouchResponse.touchInput is! PointerExitEvent) {
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
                margin: 28,
                getTextStyles: (_) => TextStyles.caption1_grey,
                getTitles: (double value) {
                  final toOriginalNumber =
                      (value / 10 * widget.model.maxY).round();
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
                ? _barGroupsChild()
                : randomData(),
          ),
        ),
      ),
    );
  }

  // TODO: Make this better
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
      _makeBarChartGroupData(
        x: 0,
        y: 8,
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: 7,
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: 8,
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: 2,
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: 5.3,
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: 6.4,
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: 9.6,
        isTouched: touchedIndex == 6,
      ),
    ];
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
          y: isTouched ? y * 1.05 : y,
          colors: isTouched ? [kPrimary700Color] : [kPrimaryColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            // show: _data.isEmpty,
            show: false,
            y: 10,
            colors: [Colors.grey[800]!],
          ),
        ),
      ],
    );
  }
}
