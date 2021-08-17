import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

class WeeklyMeasurementsSampleWidget extends StatelessWidget {
  final Color? color;
  final double? padding;

  const WeeklyMeasurementsSampleWidget({
    Key? key,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      kSecondaryColor,
      kSecondaryColor.withOpacity(0.95),
    ];

    return BlurBackgroundCard(
      color: color,
      allPadding: padding,
      borderRadius: 28,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.line_weight_rounded,
                      color: kSecondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.current.bodyMeasurement,
                      style: TextStyles.subtitle1_w900_secondary,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: kSecondaryColor,
                        size: 16,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    S.current.addMasurementDataMessage,
                    style: TextStyles.body2,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        horizontalInterval: 5,
                        drawVerticalLine: false,
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white12,
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white12,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          margin: 24,
                          getTextStyles: (value) => TextStyles.body2,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Sun';
                              case 1:
                                return 'Mon';
                              case 2:
                                return 'Tue';
                              case 3:
                                return 'Wed';
                              case 4:
                                return 'Thu';
                              case 5:
                                return 'Fri';
                              case 6:
                                return 'Sat';

                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          margin: 24,
                          getTextStyles: (_) => TextStyles.caption1_grey,
                          getTitles: (value) {
                            final unit = Formatter.unitOfMass(0);

                            final maxY = 80;
                            final minY = 70;

                            final interaval = (maxY - minY) / 4;

                            if (value == maxY) {
                              return '${maxY.toInt()} $unit';
                            } else if (value == maxY - interaval) {
                              return '${(maxY - interaval).toInt()} $unit';
                            } else if (value == maxY - interaval * 2) {
                              return '${(maxY - interaval * 2).toInt()} $unit';
                            } else if (value == maxY - interaval * 3) {
                              return '${(maxY - interaval * 3).toInt()} $unit';
                            } else if (value == minY) {
                              return '${minY.toInt()} $unit';
                            }
                            return '';
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.white12, width: 1),
                        ),
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 70,
                      maxY: 80,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _randomSpots(),
                          isCurved: true,
                          colors: gradientColors,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _randomSpots() {
    return [
      FlSpot(0, 77),
      FlSpot(1, 76.6),
      FlSpot(2, 76),
      FlSpot(3, 75.4),
      FlSpot(4, 75.5),
      FlSpot(5, 75),
      FlSpot(6, 74.2),
    ];
  }
}
