import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

class WeeklyProteinChartSampleWidget extends StatelessWidget {
  final Color? color;
  final Color? shadowColor;
  final double? padding;

  const WeeklyProteinChartSampleWidget({
    Key? key,
    this.color,
    this.shadowColor,
    this.padding,
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
      color: color,
      allPadding: padding,
      borderRadius: 28,
      shadowColor: shadowColor,
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
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.greenAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    S.current.addProteins,
                    style: TextStyles.subtitle1_w900_greenAccent,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                S.current.proteinChartContentText,
                style: TextStyles.body2,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: BarChart(
                  BarChartData(
                    maxY: 10,
                    gridData: FlGridData(
                      horizontalInterval: 9,
                      drawVerticalLine: false,
                      show: true,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.greenAccent.withOpacity(0.5),
                        dashArray: [16, 4],
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final amount = (rod.y / 1.05 / 10 * 140).round();
                          final formattedAmount = Formatter.proteins(amount);

                          return BarTooltipItem(
                            '$formattedAmount g',
                            TextStyles.body1_black,
                          );
                        },
                      ),
                      touchCallback: (barTouchResponse) {},
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
                        margin: 24,
                        reservedSize: 24,
                        getTextStyles: (_) => TextStyles.caption1_grey,
                        getTitles: (double value) {
                          final toOriginalNumber = (value / 10 * 140).round();

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
                    barGroups: randomData(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> randomData() {
    return [
      _makeBarChartGroupData(x: 0, y: 7),
      _makeBarChartGroupData(x: 1, y: 6),
      _makeBarChartGroupData(x: 2, y: 8.9),
      _makeBarChartGroupData(x: 3, y: 8),
      _makeBarChartGroupData(x: 4, y: 6.8),
      _makeBarChartGroupData(x: 5, y: 10),
      _makeBarChartGroupData(x: 6, y: 9),
    ];
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [Colors.greenAccent],
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
