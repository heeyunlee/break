import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/empty_content.dart';

import '../../../constants.dart';
import 'routine_histories_screen.dart';

class WeightsLiftedChartWidget extends StatefulWidget {
  final User user;
  final AuthBase auth;

  const WeightsLiftedChartWidget({
    Key? key,
    required this.user,
    required this.auth,
  }) : super(key: key);

  @override
  _WeightsLiftedChartWidgetState createState() =>
      _WeightsLiftedChartWidgetState();
}

class _WeightsLiftedChartWidgetState extends State<WeightsLiftedChartWidget> {
  int? touchedIndex;
  late double _maxY = 20000;

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];

  void _setData(List<RoutineHistory>? streamData, List<double> relativeYs) {
    Map<DateTime, List<RoutineHistory>> _mapData;
    List<num> listOfYs = [];

    if (streamData != null) {
      _mapData = {
        for (var item in _dates)
          item: streamData.where((e) => e.workoutDate.toUtc() == item).toList()
      };

      _mapData.values.forEach((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          list.forEach((history) {
            sum += history.totalWeights;
          });
        }

        listOfYs.add(sum);
      });
      final largest = listOfYs.reduce(max);

      if (largest == 0) {
        _maxY = 20000;
        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largest / 10000).ceil() * 10000;
        _maxY = roundedLargest.toDouble();
        listOfYs.forEach((element) {
          relativeYs.add(element / _maxY * 10);
        });
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    print('weights lifted init');

    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      var now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    _dates = _dates.reversed.toList();

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
    return Consumer(
      builder: (context, watch, child) {
        List<double> relativeYs = [];

        print('weights lifted widget building...');

        final uid = widget.auth.currentUser!.uid;
        final routineHistoriesStream = watch(rhOfThisWeekStreamProvider(uid));

        return routineHistoriesStream.when(
          loading: () => CircularProgressIndicator(),
          error: (e, stack) {
            logger.e(e);
            return EmptyContent();
          },
          data: (streamData) {
            _setData(streamData, relativeYs);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kCardColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                    color: kPrimaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    S.current.liftedWeights,
                                    style: kSubtitle1w900Primary,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: kPrimaryColor,
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
                                  //         Text(
                                  //           S.current.setWeightsDailyGoal,
                                  //           style: kButtonText2,
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
                            if (streamData!.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  S.current.weightsChartMessage,
                                  style: kBodyText2,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (streamData.isEmpty) const Divider(color: kGrey700),
                      const SizedBox(height: 16),
                      _buildChart(_maxY, relativeYs),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChart(double _maxY, List<double> relativeYs) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 8),
        child: BarChart(
          BarChartData(
            maxY: 10,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final weights = (rod.y / 1.05 / 10 * _maxY).round();
                  final formattedWeights = Format.weights(weights);
                  final unit = Format.unitOfMass(widget.user.unitOfMass);

                  return BarTooltipItem(
                    '$formattedWeights $unit',
                    kBodyText1Black,
                  );
                },
              ),
              touchCallback: (barTouchResponse) {
                setState(() {
                  if (barTouchResponse.spot != null &&
                      barTouchResponse.touchInput is! PointerUpEvent &&
                      barTouchResponse.touchInput is! PointerExitEvent) {
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
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
                getTextStyles: (value) => kBodyText2,
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
                  final toOriginalNumber = (value / 10 * _maxY).round();
                  final formatted =
                      NumberFormat.compact().format(toOriginalNumber);
                  final unit = UnitOfMass.values[widget.user.unitOfMass].label;

                  switch (value.toInt()) {
                    case 0:
                      return '0 $unit';
                    case 5:
                      return '$formatted $unit';
                    case 10:
                      return '$formatted $unit';
                    default:
                      return '';
                  }
                },
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: (widget.user.dailyWorkoutHistories!.isNotEmpty)
                ? _barGroupsChild(relativeYs)
                : randomData(),
          ),
        ),
      ),
    );
  }

  // TODO: Make this better
  List<BarChartGroupData> _barGroupsChild(List<double> relativeYs) {
    return [
      _makeBarChartGroupData(
        x: 0,
        y: relativeYs[0],
        isTouched: touchedIndex == 0,
      ),
      _makeBarChartGroupData(
        x: 1,
        y: relativeYs[1],
        isTouched: touchedIndex == 1,
      ),
      _makeBarChartGroupData(
        x: 2,
        y: relativeYs[2],
        isTouched: touchedIndex == 2,
      ),
      _makeBarChartGroupData(
        x: 3,
        y: relativeYs[3],
        isTouched: touchedIndex == 3,
      ),
      _makeBarChartGroupData(
        x: 4,
        y: relativeYs[4],
        isTouched: touchedIndex == 4,
      ),
      _makeBarChartGroupData(
        x: 5,
        y: relativeYs[5],
        isTouched: touchedIndex == 5,
      ),
      _makeBarChartGroupData(
        x: 6,
        y: relativeYs[6],
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

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y * 1.05 : y,
          colors: isTouched ? [kPrimary700Color] : [kPrimaryColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            // show: _data.isEmpty,
            show: false,
            y: 10,
            colors: [Colors.grey[800]!],
          ),
        ),
      ],
    );
  }
}
