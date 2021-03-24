import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'routine_histories_screen.dart';

class WeightsLiftedChartWidget extends StatefulWidget {
  final Database database;
  final User user;

  const WeightsLiftedChartWidget({
    Key key,
    this.database,
    this.user,
  }) : super(key: key);

  @override
  _WeightsLiftedChartWidgetState createState() =>
      _WeightsLiftedChartWidgetState();
}

class _WeightsLiftedChartWidgetState extends State<WeightsLiftedChartWidget> {
  int touchedIndex;
  double maxY = 20000;

  List<DateTime> _dates;
  List<String> _daysOfTheWeek;

  List<DailyWorkoutHistory> _historiesFromFirebase;
  List<DailyWorkoutHistory> _sevenDayHistory;

  List<double> relativeNumber = [];

  void setSevenDaysHistory() {
    /// GETTING LAST & DAYS OF HISTORY
    _historiesFromFirebase = widget.user.dailyWorkoutHistories;

    if (_historiesFromFirebase.isNotEmpty) {
      var sevenDayHistory = List<DailyWorkoutHistory>.generate(7, (index) {
        var matchingHistory = _historiesFromFirebase
            .where((element) => element.date.toUtc() == _dates[index]);
        // ignore: omit_local_variable_types
        double weights =
            (matchingHistory.isEmpty) ? 0 : matchingHistory.first.totalWeights;

        return DailyWorkoutHistory(
          date: _dates[index],
          totalWeights: weights,
        );
      });
      _sevenDayHistory = sevenDayHistory.reversed.toList();
      print(_sevenDayHistory);
    }

    /// GETTING LAST & DAYS OF HISTORY
  }

  @override
  void initState() {
    super.initState();
    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      var now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );

    print(_dates);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setSevenDaysHistory();

    ///   SET MAX Y
    if (widget.user.dailyWorkoutHistories.isEmpty) {
      maxY = 20000;
    } else {
      final largest =
          _sevenDayHistory.map<double>((e) => e.totalWeights).reduce(max);

      if (largest == 0) {
        maxY = 20000;
        _sevenDayHistory.forEach((element) {
          relativeNumber.add(0);
        });
      } else {
        final roundedLargest = (largest / 10000).ceil() * 10000;
        maxY = roundedLargest.toDouble();
        _sevenDayHistory.forEach((element) {
          relativeNumber.add(element.totalWeights / maxY * 10);
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: CardColor,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => RoutineHistoriesScreen.show(context),
                    child: Wrap(
                      children: [
                        SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fitness_center_rounded,
                                color: PrimaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Lift Weights',
                                style: Subtitle1w900Primary,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: PrimaryColor,
                                  size: 16,
                                ),
                              ),
                              const Spacer(),
                              // if (widget.user.dailyWeightsGoal == null)
                              //   TextButton(
                              //     style: TextButton.styleFrom(
                              //       padding: EdgeInsets.zero,
                              //     ),
                              //     onPressed: () =>
                              //         SetDailyWeightsGoalScreen.show(context),
                              //     child: Row(
                              //       children: [
                              //         const Text(
                              //           'SET DAILY GOAL',
                              //           style: ButtonText2,
                              //         ),
                              //         const SizedBox(width: 4),
                              //         const Icon(
                              //           Icons.add_rounded,
                              //           color: Colors.white,
                              //           size: 16,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                        if (widget.user.dailyWorkoutHistories.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Start working out now and see your progress!',
                              style: BodyText2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.user.dailyWorkoutHistories.isEmpty)
                    const Divider(color: Grey700),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BarChart(
                        BarChartData(
                          maxY: 10,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                final weights =
                                    (rod.y / 1.05 / 10 * maxY).round();
                                final formattedWeights =
                                    Format.weights(weights);
                                final unit =
                                    Format.unitOfMass(widget.user.unitOfMass);

                                return BarTooltipItem(
                                  '$formattedWeights $unit',
                                  BodyText1Black,
                                );
                              },
                            ),
                            touchCallback: (barTouchResponse) {
                              setState(() {
                                if (barTouchResponse.spot != null &&
                                    barTouchResponse.touchInput
                                        is! PointerUpEvent &&
                                    barTouchResponse.touchInput
                                        is! PointerExitEvent) {
                                  touchedIndex = barTouchResponse
                                      .spot.touchedBarGroupIndex;
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
                              getTextStyles: (value) => BodyText2,
                              margin: 16,
                              getTitles: (double value) {
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
                              getTextStyles: (valie) => Caption1Grey,
                              getTitles: (double value) {
                                final toOriginalNumber =
                                    (value / 10 * maxY).round();
                                final formatted = NumberFormat.compact()
                                    .format(toOriginalNumber);

                                switch (value.toInt()) {
                                  case 0:
                                    return '0';
                                  case 5:
                                    return '$formatted';
                                  case 10:
                                    return '$formatted';
                                  default:
                                    return '';
                                }
                              },
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups:
                              (widget.user.dailyWorkoutHistories.isNotEmpty)
                                  ? _barGroupsChild(widget.user)
                                  : randomData(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    int x,
    double y,
    double width = 16,
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y * 1.05 : y,
          colors: isTouched ? [Primary700Color] : [PrimaryColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 10,
            colors: [Colors.grey[800]],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _barGroupsChild(User user) {
    return [
      _makeBarChartGroupData(
        x: 0,
        // y: _sevenDayHistory[0].totalWeights,
        y: relativeNumber[0],
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        // y: _sevenDayHistory[1].totalWeights,
        y: relativeNumber[1],
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        // y: _sevenDayHistory[2].totalWeights,
        y: relativeNumber[2],
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        // y: _sevenDayHistory[3].totalWeights,
        y: relativeNumber[3],
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        // y: _sevenDayHistory[4].totalWeights,
        y: relativeNumber[4],
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        // y: _sevenDayHistory[5].totalWeights,
        y: relativeNumber[5],
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        // y: _sevenDayHistory[6].totalWeights,
        y: relativeNumber[6],
        isTouched: touchedIndex == 6,
      ),
    ];
  }

  List<BarChartGroupData> randomData() {
    return [
      _makeBarChartGroupData(
        x: 0,
        y: 5,
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
        y: 0,
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
}