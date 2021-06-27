import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import 'measurements_screen.dart';

class MeasurementsLineChartWidget extends StatefulWidget {
  final User user;

  const MeasurementsLineChartWidget({Key? key, required this.user})
      : super(key: key);

  @override
  _MeasurementsLineChartWidgetState createState() =>
      _MeasurementsLineChartWidgetState();
}

class _MeasurementsLineChartWidgetState
    extends State<MeasurementsLineChartWidget> {
  List<Color> gradientColors = [
    kSecondaryColor,
    kSecondaryColor.withOpacity(0.95),
  ];

  double maxY = 80;
  double minY = 60;
  double horizontalInterval = 5;

  final DateTime _now = DateTime.now();
  late DateTime _today;
  late List<DateTime> _dates;
  List<String> _daysOfTheWeek = [];
  // ignore: prefer_final_fields
  List<Measurement> _thisWeekData = [];

  //  SET MAX Y
  Future<void> setMaxY(List<Measurement> measurements) async {
    // debugPrint('setMaxY func');
    if (measurements.isEmpty || measurements.length < 2) {
      maxY = 80;
      minY = 70;
      horizontalInterval = 5;
    } else {
      _dates.forEach(
        (date) {
          var data = measurements
              .where((element) => element.loggedDate.toUtc() == date);
          if (data.isNotEmpty) {
            _thisWeekData.add(data.first);
          }
        },
      );

      final largest =
          measurements.map<double>((e) => e.bodyWeight.toDouble()).reduce(max);
      final lowest =
          measurements.map<double>((e) => e.bodyWeight.toDouble()).reduce(min);

      final roundedLargest = (largest / 10).ceil() * 10;
      final roundedLowest = lowest ~/ 10 * 10;
      maxY = roundedLargest.toDouble();
      minY = roundedLowest.toDouble();

      if (maxY == minY) {
        maxY = minY + 10;
        minY = minY - 10;
        horizontalInterval = 5;
      } else {
        horizontalInterval = (maxY - minY) / 4;
      }
    }
  }

  double? flipNumber(double number) {
    // debugPrint('flipNumber func');

    switch (number.toInt()) {
      case 6:
        return 0.toDouble();
      case 5:
        return 1.toDouble();
      case 4:
        return 2.toDouble();
      case 3:
        return 3.toDouble();
      case 2:
        return 4.toDouble();
      case 1:
        return 5.toDouble();
      case 0:
        return 6.toDouble();
    }
  }

  @override
  void initState() {
    super.initState();
    // debugPrint('initiated');

    _today = DateTime.utc(_now.year, _now.month, _now.day);

    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      return DateTime.utc(_now.year, _now.month, _now.day - index);
    });
    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // debugPrint('disposed');
  }

  @override
  Widget build(BuildContext context) {
    return BlurBackgroundCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildChartWidget(),
      ),
    );
  }

  Widget _buildChartWidget() {
    final database = Provider.of<Database>(context, listen: false);

    return CustomStreamBuilderWidget<List<Measurement>>(
      stream: database.measurementsStreamThisWeek(),
      hasDataWidget: (context, data) {
        setMaxY(data);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => MeasurementsScreen.show(context),
              child: Column(
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
                        style: kSubtitle1w900Secondary,
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
                  if (data.length < 2)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        S.current.addMasurementDataMessage,
                        style: TextStyles.body2,
                      ),
                    ),
                  if (data.length >= 2) const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.4,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        horizontalInterval: horizontalInterval,
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
                                return '${_daysOfTheWeek[6]}';
                              case 1:
                                return '${_daysOfTheWeek[5]}';
                              case 2:
                                return '${_daysOfTheWeek[4]}';
                              case 3:
                                return '${_daysOfTheWeek[3]}';
                              case 4:
                                return '${_daysOfTheWeek[2]}';
                              case 5:
                                return '${_daysOfTheWeek[1]}';
                              case 6:
                                return '${_daysOfTheWeek[0]}';

                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          margin: 24,
                          // reservedSize: 20,
                          getTextStyles: (value) => kCaption1Grey,
                          getTitles: (value) {
                            final unit = Formatter.unitOfMass(
                              widget.user.unitOfMass,
                            );
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
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: (data.length > 1)
                              ? actualSpots()
                              : _randomSpots(),
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
        );
      },
    );
  }

  List<FlSpot> actualSpots() {
    return List.generate(
      _thisWeekData.length,
      (index) {
        final diff = _today
            .difference(_thisWeekData[index].loggedDate)
            .inDays
            .toDouble();

        return FlSpot(
          flipNumber(diff)!,
          _thisWeekData[index].bodyWeight.toDouble(),
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
