import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/nutrition.dart';

import 'package:workout_player/styles/text_styles.dart';

import 'no_data_in_chart_message_widget.dart';

class WeeklyBarChart2 extends StatelessWidget {
  const WeeklyBarChart2({
    Key? key,
    required this.nutritions,
    required this.maxY,
    required this.defaultColor,
    required this.touchedColor,
    required this.getBarTooltipText,
    this.barTooltipTextStyle = TextStyles.body1Bold,
    required this.onTouchCallback,
    required this.getDaysOfTheWeek,
    required this.listOfYs,
    required this.touchedIndex,
  }) : super(key: key);

  final List<Nutrition> nutritions;
  final double maxY;
  final Color defaultColor;
  final Color touchedColor;
  final String Function(double) getBarTooltipText;
  final TextStyle barTooltipTextStyle;
  final void Function(FlTouchEvent, BarTouchResponse?) onTouchCallback;
  final String Function(int) getDaysOfTheWeek;
  final List<double> listOfYs;
  final int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          BarChart(
            BarChartData(
              maxY: maxY,
              // gridData: _buildGrid(),
              gridData: FlGridData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      getBarTooltipText(rod.y),
                      barTooltipTextStyle,
                    );
                  },
                ),
                touchCallback: onTouchCallback,
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: SideTitles(showTitles: false),
                rightTitles: SideTitles(showTitles: false),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (_, __) => TextStyles.body2,
                  margin: 16,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return getDaysOfTheWeek(0);
                      case 1:
                        return getDaysOfTheWeek(1);
                      case 2:
                        return getDaysOfTheWeek(2);
                      case 3:
                        return getDaysOfTheWeek(3);
                      case 4:
                        return getDaysOfTheWeek(4);
                      case 5:
                        return getDaysOfTheWeek(5);
                      case 6:
                        return getDaysOfTheWeek(6);
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: false,
                  // reservedSize: 64,
                  // getTextStyles: (_, __) => TextStyles.caption1Grey,
                  // getTitles: (double value) {
                  //   switch (value.toInt()) {
                  //     case 0:
                  //       return widget.getSideTiles(value);
                  //     case 5:
                  //       return widget.getSideTiles(value);
                  //     case 10:
                  //       return widget.getSideTiles(value);
                  //     default:
                  //       return '';
                  //   }
                  // },
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(),
            ),
          ),
          if (nutritions.isEmpty)
            NoDataInChartMessageWidget(color: defaultColor),
        ],
      ),
    );
  }

  // FlGridData _buildGrid() {
  //   return FlGridData(
  //     horizontalInterval: widget.model.interval as double?,
  //     drawVerticalLine: false,
  //     show: widget.model.goalExists as bool?,
  //     getDrawingHorizontalLine: (_) => FlLine(
  //       color: widget.defaultColor.withOpacity(0.5),
  //       dashArray: [16, 4],
  //     ),
  //   );
  // }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(
      7,
      (index) => _makeBarChartGroupData(
        x: index,
        y: listOfYs[index],
        isTouched: touchedIndex == index,
        defaultColor: (nutritions.isNotEmpty)
            ? defaultColor
            : defaultColor.withOpacity(0.25),
        touchedColor: (nutritions.isNotEmpty)
            ? touchedColor
            : defaultColor.withOpacity(0.5),
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 20,
    bool isTouched = false,
    required Color defaultColor,
    required Color touchedColor,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          // backDrawRodData: BackgroundBarChartRodData(
          //   show: true,
          //   y: y,
          //   colors: [Colors.grey],
          // ),
          y: isTouched ? y * 1.05 : y,
          colors: isTouched ? [touchedColor] : [defaultColor],
          width: width,
        ),
      ],
    );
  }
}
