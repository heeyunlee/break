import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/charts/no_data_in_chart_message_widget.dart';
import 'package:workout_player/view_models/main_model.dart';

import '../../../../../view_models/weekly_measurements_chart_model.dart';

class WeeklyMeasurementsChart extends StatefulWidget {
  final WeeklyMeasurementsChartModel model;
  final User user;
  final List<Measurement> measurements;

  const WeeklyMeasurementsChart({
    Key? key,
    required this.model,
    required this.user,
    required this.measurements,
  }) : super(key: key);

  @override
  _WeeklyMeasurementsChartState createState() =>
      _WeeklyMeasurementsChartState();
}

class _WeeklyMeasurementsChartState extends State<WeeklyMeasurementsChart> {
  List<Color> hasDataColors = [kSecondaryColor];
  List<Color> noDataColors = [kSecondaryColor.withOpacity(0.5)];

  @override
  Widget build(BuildContext context) {
    widget.model.init();
    widget.model.setMaxY(widget.measurements);

    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            children: [
              LineChart(
                LineChartData(
                  gridData: FlGridData(
                    horizontalInterval: widget.model.horizontalInterval,
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
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, _) => TextStyles.body2,
                      getTitles: (value) {
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
                      reservedSize: 56,
                      getTextStyles: (context, _) => TextStyles.caption1Grey,
                      getTitles: (value) {
                        final unit = Formatter.unitOfMass(
                          widget.user.unitOfMass,
                          widget.user.unitOfMassEnum,
                        );
                        final maxY = widget.model.maxY;
                        final minY = widget.model.minY;

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
                    border: const Border(
                      bottom: BorderSide(color: Colors.white12),
                    ),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: widget.model.minY,
                  maxY: widget.model.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      colors: (widget.model.thisWeekData.isNotEmpty)
                          ? hasDataColors
                          : noDataColors,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      spots: (widget.model.thisWeekData.isNotEmpty)
                          ? actualSpots()
                          : _randomSpots(),
                    ),
                  ],
                ),
              ),
              if (widget.model.thisWeekData.isEmpty)
                const NoDataInChartMessageWidget(color: kSecondaryColor),
            ],
          )),
    );
  }

  List<FlSpot> actualSpots() {
    return List.generate(
      widget.model.thisWeekData.length,
      (index) {
        final diff = widget.model.now
            .difference(widget.model.thisWeekData[index]!.loggedDate)
            .inDays
            .toDouble();
        logger.d('diff is $diff');

        return FlSpot(
          widget.model.flipNumber(diff),
          widget.model.thisWeekData[index]!.bodyWeight!.toDouble(),
        );
      },
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
