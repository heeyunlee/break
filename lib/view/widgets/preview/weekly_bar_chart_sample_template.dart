import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

class WeeklyBarChartSampleTemplate extends StatelessWidget {
  final Color? cardColor;
  final double? cardPadding;
  final Color defaultColor;
  final Color aboveGoalColor;
  final IconData leadingIcon;
  final String title;
  final double horizontalInterval;
  final String unit;
  final double maxY;
  final List<double> randomData;

  const WeeklyBarChartSampleTemplate({
    Key? key,
    this.cardColor,
    this.cardPadding,
    required this.defaultColor,
    required this.aboveGoalColor,
    required this.leadingIcon,
    required this.title,
    required this.horizontalInterval,
    required this.unit,
    required this.maxY,
    required this.randomData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _daysOfTheWeek = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    return BlurBackgroundCard(
      allPadding: cardPadding,
      color: cardColor,
      borderRadius: 28,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Icon(
                    leadingIcon,
                    color: defaultColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyles.subtitle1_w900.copyWith(
                      color: defaultColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 8),
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    gridData: FlGridData(
                      horizontalInterval: horizontalInterval,
                      drawVerticalLine: false,
                      show: true,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: defaultColor.withOpacity(0.5),
                        dashArray: [16, 4],
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final formatted = Formatter.numWithoutDecimal(rod.y);

                          return BarTooltipItem(
                            '$formatted $unit',
                            TextStyles.body1_black,
                          );
                        },
                      ),
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
                              return _daysOfTheWeek[0];
                            case 1:
                              return _daysOfTheWeek[1];
                            case 2:
                              return _daysOfTheWeek[2];
                            case 3:
                              return _daysOfTheWeek[3];
                            case 4:
                              return _daysOfTheWeek[4];
                            case 5:
                              return _daysOfTheWeek[5];
                            case 6:
                              return _daysOfTheWeek[6];
                            default:
                              return '';
                          }
                        },
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        margin: 34,
                        getTextStyles: (_) => TextStyles.caption1_grey,
                        getTitles: (double value) {
                          final formatted =
                              NumberFormat.compact().format(value);

                          if (value == 0) {
                            return '0 $unit';
                          } else if (value == maxY / 2) {
                            return '$formatted $unit';
                          } else if (value == maxY) {
                            return '$formatted $unit';
                          } else {
                            return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _randomData(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _randomData() {
    return List.generate(
      7,
      (index) => _makeBarChartGroupData(
        x: index,
        y: randomData[index],
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: (y >= horizontalInterval) ? [aboveGoalColor] : [defaultColor],
          width: 16,
        ),
      ],
    );
  }
}
