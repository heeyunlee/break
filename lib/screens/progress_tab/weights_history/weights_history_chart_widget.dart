import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class WeightsHistoryChartWidget extends StatefulWidget {
  @override
  _WeightsHistoryChartWidgetState createState() =>
      _WeightsHistoryChartWidgetState();
}

class _WeightsHistoryChartWidgetState extends State<WeightsHistoryChartWidget> {
  List<Color> gradientColors = [Colors.green, Colors.greenAccent];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.heavyImpact();
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: CardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.line_weight_rounded,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text('Weights', style: Subtitle1w900Green),
                      Spacer(),
                      Row(
                        children: [
                          const Text('More', style: ButtonTextGrey),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                //   child: Text(
                //     'You\'ve worked out 4 times and lifted 45,064 lbs on average over the last 7 days!',
                //     style: BodyText2,
                //   ),
                // ),
                // const Divid  er(color: Grey700),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 2,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        drawVerticalLine: true,
                        show: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white24,
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white24,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTextStyles: (value) => BodyText2,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 30:
                                return 'Today';
                              case 20:
                                return '10d';
                              case 10:
                                return '20d';
                              default:
                                return '';
                            }
                          },
                          margin: 8,
                        ),
                        leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => BodyText2,
                            getTitles: (value) {
                              switch (value.toInt()) {
                                case 200:
                                  return '200';
                                case 150:
                                  return '150';
                                default:
                                  return '';
                              }
                            }),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 30,
                      minY: 120,
                      maxY: 200,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 176),
                            FlSpot(10, 175),
                            FlSpot(16, 170),
                            FlSpot(20, 172),
                            FlSpot(25, 165),
                            FlSpot(28, 164),
                            FlSpot(30, 162),
                          ],
                          isCurved: true,
                          colors: gradientColors,
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
