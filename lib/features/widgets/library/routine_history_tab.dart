import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/services/database.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/widgets/builders/custom_stream_builder.dart';

// TODO: Fix Here
class RoutineHistoryTab extends StatefulWidget {
  final Routine routine;
  final Database database;

  const RoutineHistoryTab({
    Key? key,
    required this.routine,
    required this.database,
  }) : super(key: key);

  @override
  State<RoutineHistoryTab> createState() => _RoutineHistoryTabState();
}

class _RoutineHistoryTabState extends State<RoutineHistoryTab> {
  int? touchedIndex;
  late double _maxY = 20000;

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];

  @override
  void initState() {
    super.initState();

    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      final now = DateTime.now();
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    _dates = _dates.reversed.toList();

    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );
  }

  void _setData(List<RoutineHistory?> streamData, List<double> relativeYs) {
    Map<DateTime, List<RoutineHistory?>> mapData;
    final List<num> listOfYs = [];

    if (streamData.isNotEmpty) {
      mapData = {
        for (var item in _dates)
          item: streamData.where((e) => e!.workoutDate.toUtc() == item).toList()
      };
      // ignore: avoid_function_literals_in_foreach_calls
      mapData.values.forEach((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          // ignore: avoid_function_literals_in_foreach_calls
          list.forEach((history) {
            sum += history!.totalWeights;
          });
        }

        listOfYs.add(sum);
      });

      final largest = listOfYs.reduce(math.max);

      if (largest == 0) {
        _maxY = 20000;
        // ignore: avoid_function_literals_in_foreach_calls
        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largest / 10000).ceil() * 10000;
        _maxY = roundedLargest.toDouble();
        // ignore: avoid_function_literals_in_foreach_calls
        listOfYs.forEach((element) {
          relativeYs.add(element / _maxY * 10);
        });
      }
    } else {
      mapData = {for (var item in _dates) item: []};

      relativeYs.addAll(_dates.map((e) => 0));

      // for (var a in _dates) {
      //   relativeYs.add(0);
      // }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilder<List<RoutineHistory?>>(
      stream: widget.database.routineHistoriesThisWeekStream2(
        widget.routine.routineId,
      ),
      builder: (context, snapshot) {
        final List<double> relativeYs = [];

        _setData(snapshot, relativeYs);

        final unit = Formatter.unitOfMass(
          widget.routine.initialUnitOfMass,
          widget.routine.unitOfMassEnum,
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Text(S.current.thisWeek, style: TextStyles.body1),
              ),
              Card(
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 8,
                      top: 32,
                    ),
                    child: BarChart(
                      BarChartData(
                        maxY: 10,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final weights =
                                  (rod.toY / 1.05 / 10 * _maxY).round();
                              final formattedWeights =
                                  Formatter.numWithDecimal(weights);

                              return BarTooltipItem(
                                '$formattedWeights $unit',
                                TextStyles.body1Black,
                              );
                            },
                          ),
                          touchCallback: (event, barTouchResponse) {
                            setState(() {
                              if (barTouchResponse?.spot != null &&
                                  event is! FlTapUpEvent) {
                                touchedIndex = barTouchResponse
                                    ?.spot!.touchedBarGroupIndex;
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
                            getTextStyles: (_, __) => TextStyles.body2,
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
                            getTextStyles: (_, __) => TextStyles.caption1Grey,
                            getTitles: (double value) {
                              final toOriginalNumber =
                                  (value / 10 * _maxY).round();
                              final formatted = NumberFormat.compact()
                                  .format(toOriginalNumber);
                              // final unit = Formatter.unitOfMass(
                              //     widget.routine.initialUnitOfMass);

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
                        barGroups: _barGroupsChild(relativeYs),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
    bool isTouched = false,
  }) {
    final theme = Theme.of(context);

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y * 1.05 : y,
          colors: isTouched ? [theme.primaryColorDark] : [theme.primaryColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            // show: _data.isEmpty,
            show: true,
            toY: 10,
            colors: [Colors.grey[800]!],
          ),
        ),
      ],
    );
  }
}
