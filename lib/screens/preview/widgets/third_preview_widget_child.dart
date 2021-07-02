import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ThirdPreviewWidgetChild extends StatelessWidget {
  const ThirdPreviewWidgetChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<String> _daysOfTheWeek = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    return Column(
      children: [
        SizedBox(height: (size.width - 296) / 2),
        Card(
          color: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
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
                        Icons.fitness_center_rounded,
                        color: kPrimaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        S.current.liftedWeights,
                        style: kSubtitle1w900Primary,
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
                        maxY: 10000,
                        gridData: FlGridData(
                          horizontalInterval: 7500,
                          drawVerticalLine: false,
                          show: true,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: kPrimaryColor.withOpacity(0.5),
                            dashArray: [16, 4],
                          ),
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.y} kg',
                                kBodyText1Black,
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
                            margin: 28,
                            getTextStyles: (valie) => kCaption1Grey,
                            getTitles: (double value) {
                              final formatted =
                                  NumberFormat.compact().format(value);

                              switch (value.toInt()) {
                                case 0:
                                  return '0 kg';
                                case 5000:
                                  return '$formatted kg';
                                case 10000:
                                  return '$formatted kg';
                                default:
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
        ),
        SizedBox(height: (size.width - 296) / 2),
      ],
    );
  }

  List<BarChartGroupData> _randomData() {
    return [
      _makeBarChartGroupData(
        x: 0,
        y: 8000,
        isAboveGoal: true,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: 7000,
        isAboveGoal: false,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: 8000,
        isAboveGoal: true,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: 2000,
        isAboveGoal: false,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: 5300,
        isAboveGoal: false,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: 6400,
        isAboveGoal: false,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: 9600,
        isAboveGoal: true,
      ),
    ];
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    required isAboveGoal,
    double width = 16,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: isAboveGoal ? [kPrimary700Color] : [kPrimaryColor],
          width: width,
        ),
      ],
    );
  }
}
