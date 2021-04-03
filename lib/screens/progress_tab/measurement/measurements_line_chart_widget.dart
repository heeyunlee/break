import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'measurements_screen.dart';

class MeasurementsLineChartWidget extends StatefulWidget {
  final User user;

  const MeasurementsLineChartWidget({Key key, this.user}) : super(key: key);

  @override
  _MeasurementsLineChartWidgetState createState() =>
      _MeasurementsLineChartWidgetState();
}

class _MeasurementsLineChartWidgetState
    extends State<MeasurementsLineChartWidget> {
  List<Color> gradientColors = [
    SecondaryColor,
    SecondaryColor.withOpacity(0.95),
  ];

  double maxY = 80;
  double minY = 60;

  final DateTime _now = DateTime.now();
  DateTime _today;
  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  List<Measurement> _thisWeekData = [];

  //  SET MAX Y
  Future<void> setMaxY(List<Measurement> measurements) async {
    if (measurements.isEmpty || measurements.length < 2) {
      maxY = 80;
      minY = 70;
    } else {
      print('date is $_dates');
      print('measre ${measurements[0].loggedDate.toUtc()}');
      // final now = DateTime.now().toUtc();
      // _thisWeekData = measurements
      //     .where((element) => _now.difference(element.loggedDate).inDays < 7)
      //     .toList();
      // var sd = [];
      // for (var i = 0; i < _dates.length; i++) {
      //   var m =
      //       measurements.firstWhere((e) => e.loggedDate.toUtc() == _dates[i]);
      //   sd.add(m);
      // }
      // _thisWeekData = sd;

      _dates.forEach((date) {
        var measurement = measurements.firstWhere(
          (element) => element.loggedDate.toUtc() == date,
        );
        _thisWeekData.add(measurement);
      });

      final largest =
          measurements.map<double>((e) => e.bodyWeight.toDouble()).reduce(max);
      final lowest =
          measurements.map<double>((e) => e.bodyWeight.toDouble()).reduce(min);

      final roundedLargest = (largest / 10).ceil() * 10;
      final roundedLowest = lowest ~/ 10 * 10;
      maxY = roundedLargest.toDouble();
      minY = roundedLowest.toDouble();
      print('max Y is $maxY');
      print('min Y is $minY');
    }
  }

  // ignore: missing_return
  double flipNumber(double number) {
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
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // _now = DateTime.now();
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => MeasurementsScreen.show(context),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.line_weight_rounded,
                          color: SecondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.current.bodyMeasurement,
                          style: Subtitle1w900Secondary,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: SecondaryColor,
                            size: 16,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // const Divider(color: Grey700),
              const SizedBox(height: 16),
              _buildChartWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartWidget() {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return AspectRatio(
      aspectRatio: 1.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<Measurement>>(
          stream: database.measurementsStream(auth.currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              setMaxY(snapshot.data);

              return LineChart(
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
                      getTextStyles: (value) => BodyText2,
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
                      margin: 12,
                      getTextStyles: (value) => Caption1Grey,
                      getTitles: (value) {
                        final unit = Format.unitOfMass(
                          widget.user.unitOfMass,
                        );

                        if (value == maxY) {
                          return '${maxY.toInt()} $unit';
                        } else if (value == maxY - 5) {
                          return '${(maxY - 5).toInt()} $unit';
                        } else if (value == maxY - 10) {
                          return '${(maxY - 10).toInt()} $unit';
                        }
                        return '';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: (snapshot.data.length > 1)
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
              );
            } else if (snapshot.hasError) {
              return Container();
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
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
          flipNumber(diff),
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
