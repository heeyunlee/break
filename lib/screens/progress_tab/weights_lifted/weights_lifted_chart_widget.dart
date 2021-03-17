import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'routine_histories_screen.dart';

class WeightsLiftedChartWidget extends StatefulWidget {
  final Database database;

  const WeightsLiftedChartWidget({
    Key key,
    this.database,
  }) : super(key: key);

  @override
  _WeightsLiftedChartWidgetState createState() =>
      _WeightsLiftedChartWidgetState();
}

class _WeightsLiftedChartWidgetState extends State<WeightsLiftedChartWidget> {
  int touchedIndex;
  DateTime _now;
  DateTime _today;
  DateTime _yesterday;
  DateTime _2daysAgo;
  DateTime _3daysAgo;
  DateTime _4daysAgo;
  DateTime _5daysAgo;
  DateTime _6daysAgo;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _today = DateTime(_now.year, _now.month, _now.day);
    _yesterday = DateTime(_now.year, _now.month, _now.day - 1);
    _2daysAgo = DateTime(_now.year, _now.month, _now.day - 2);
    _3daysAgo = DateTime(_now.year, _now.month, _now.day - 3);
    _4daysAgo = DateTime(_now.year, _now.month, _now.day - 4);
    _5daysAgo = DateTime(_now.year, _now.month, _now.day - 5);
    _6daysAgo = DateTime(_now.year, _now.month, _now.day - 6);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<User>(
        stream: widget.database.userStream(userId: auth.currentUser.uid),
        builder: (context, snapshot) {
          final user = snapshot.data;
          print(user.toMap());

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
                      onTap: () => RoutineHistoriesScreen.show(context),
                      child: Column(
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
                            maxY: 26000,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  final weights =
                                      (rod.y / 1.1).round().toDouble();
                                  final formattedWeights =
                                      Format.weights(weights);
                                  final unit =
                                      Format.unitOfMass(user.unitOfMass);

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
                                          is! FlPanEnd &&
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
                                  final todayE = DateFormat.E().format(_now);
                                  final yesterdayE =
                                      DateFormat.E().format(_yesterday);
                                  final _2daysAgoE =
                                      DateFormat.E().format(_2daysAgo);
                                  final _3daysAgoE =
                                      DateFormat.E().format(_3daysAgo);
                                  final _4daysAgoE =
                                      DateFormat.E().format(_4daysAgo);
                                  final _5daysAgoE =
                                      DateFormat.E().format(_5daysAgo);
                                  final _6daysAgoE =
                                      DateFormat.E().format(_6daysAgo);

                                  switch (value.toInt()) {
                                    case 0:
                                      return '$_6daysAgoE';
                                    case 1:
                                      return '$_5daysAgoE';
                                    case 2:
                                      return '$_4daysAgoE';
                                    case 3:
                                      return '$_3daysAgoE';
                                    case 4:
                                      return '$_2daysAgoE';
                                    case 5:
                                      return '$yesterdayE';
                                    case 6:
                                      return '$todayE';
                                    default:
                                      return '';
                                  }
                                },
                              ),
                              leftTitles: SideTitles(showTitles: false),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: _barGroupsChild(user),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
          y: isTouched ? y + 0.1 * y : y,
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
    var list = <DailyWorkoutHistory>[];
    print('user history is ${user.dailyWorkoutHistories}');
    if (user.dailyWorkoutHistories != null) {
      user.dailyWorkoutHistories.forEach((element) {
        element = DailyWorkoutHistory(
          date: element['date'].toDate(),
          totalWeights: element['totalWeights'],
        );
        list.add(element);
      });
    }
    var weight1 = list.where((element) => element.date == _today);
    var weight2 = list.where((element) => element.date == _yesterday);
    var weight3 = list.where((element) => element.date == _yesterday);
    var weight4 = list.where((element) => element.date == _yesterday);
    var weight5 = list.where((element) => element.date == _yesterday);
    var weight6 = list.where((element) => element.date == _yesterday);
    var weight7 = list.where((element) => element.date == _yesterday);

    return [
      _makeBarChartGroupData(
        x: 0,
        y: (weight7.isEmpty) ? 0 : weight7.first.totalWeights,
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: (weight6.isEmpty) ? 0 : weight6.first.totalWeights,
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
          x: 2,
          y: (weight5.isEmpty) ? 0 : weight5.first.totalWeights,
          isTouched: touchedIndex == 2),
      _makeBarChartGroupData(
        x: 3,
        y: (weight4.isEmpty) ? 0 : weight4.first.totalWeights,
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: (weight3.isEmpty) ? 0 : weight3.first.totalWeights,
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: (weight2.isEmpty) ? 0 : weight2.first.totalWeights,
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: (weight1.isEmpty) ? 0 : weight1.first.totalWeights,
        isTouched: touchedIndex == 6,
      ),
    ];
  }
}
