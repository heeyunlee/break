import 'package:fl_chart/fl_chart.dart';
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

  List<DateTime> _dates;
  List<String> _daysOfTheWeek;

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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => RoutineHistoriesScreen.show(context),
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                              const Spacer(),
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
                        if (widget.user.dailyWorkoutHistories.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Start your workout wow and see the Progress!',
                              style: BodyText2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // const Divider(color: Grey700),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BarChart(
                        BarChartData(
                          maxY: 25000,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                final weights =
                                    (rod.y / 1.05).round().toDouble();
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
                                    barTouchResponse.touchInput is! FlPanEnd &&
                                    barTouchResponse.touchInput
                                        is! FlLongPressEnd) {
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
                            leftTitles: SideTitles(showTitles: false),
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
          y: isTouched ? y + 0.05 * y : y,
          colors: isTouched ? [Primary700Color] : [PrimaryColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 25000,
            colors: [Colors.grey[800]],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _barGroupsChild(User user) {
    // ignore: omit_local_variable_types
    List<DailyWorkoutHistory> historiesFromFirebase =
        user.dailyWorkoutHistories;

    var sevenDayHistory = List<DailyWorkoutHistory>.generate(7, (index) {
      if (historiesFromFirebase.isNotEmpty) {
        var matchingHistory = historiesFromFirebase
            .where((element) => element.date.toUtc() == _dates[index]);
        // ignore: omit_local_variable_types
        double weights =
            (matchingHistory.isEmpty) ? 0 : matchingHistory.first.totalWeights;

        return DailyWorkoutHistory(
          date: _dates[index],
          totalWeights: weights,
        );
      }
      return null;
    });
    sevenDayHistory = sevenDayHistory.reversed.toList();

    return [
      _makeBarChartGroupData(
        x: 0,
        y: sevenDayHistory[0].totalWeights,
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: sevenDayHistory[1].totalWeights,
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: sevenDayHistory[2].totalWeights,
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: sevenDayHistory[3].totalWeights,
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: sevenDayHistory[4].totalWeights,
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: sevenDayHistory[5].totalWeights,
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: sevenDayHistory[6].totalWeights,
        isTouched: touchedIndex == 6,
      ),
    ];
  }

  List<BarChartGroupData> randomData() {
    return [
      _makeBarChartGroupData(
        x: 0,
        y: 12000,
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: 13400,
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: 15500,
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: 14000,
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: 18000,
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: 12000,
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: 19240,
        isTouched: touchedIndex == 6,
      ),
    ];
  }
}
