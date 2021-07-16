import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

class WorkoutHistoriesTab extends StatefulWidget {
  final User user;
  final Workout workout;
  final Database database;

  const WorkoutHistoriesTab({
    Key? key,
    required this.user,
    required this.workout,
    required this.database,
  }) : super(key: key);

  @override
  _WorkoutHistoriesTabState createState() => _WorkoutHistoriesTabState();
}

class _WorkoutHistoriesTabState extends State<WorkoutHistoriesTab> {
  int? touchedIndex;
  late double _maxY;

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];

  @override
  void initState() {
    super.initState();

    _maxY = 100;

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

  void _setData(List<WorkoutHistory?> streamData, List<double> relativeYs) {
    Map<DateTime, List<WorkoutHistory?>> _mapData;
    List<num> listOfYs = [];

    if (streamData.isNotEmpty) {
      _mapData = {
        for (var item in _dates)
          item: streamData
              .where((e) => e!.workoutDate?.toDate().toUtc() == item)
              .toList()
      };

      // print('map is $_mapData');

      _mapData.values.forEach((list) {
        if (list.isNotEmpty) {
          // print('workout history exists');

          WorkoutSet? largestSet;

          list.forEach((history) {
            final _largestSest = history!.sets?.reduce((a, b) {
              final maxWeight = math.max<num>(a.weights!, b.weights!);
              final s =
                  history.sets?.where((c) => c.weights! == maxWeight).first;

              return s ?? a;
            });

            largestSet = _largestSest;
          });
          listOfYs.add(largestSet?.weights ?? 0);
        } else {
          // print('workout DOES NOT history exists');
          listOfYs.add(0);
        }
      });
      // print('list of Ys are: $listOfYs');

      final largestY = listOfYs.reduce(math.max);

      if (largestY == 0) {
        _maxY = 100;
        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largestY / 100).ceil() * 100;
        _maxY = roundedLargest.toDouble();
        listOfYs.forEach((element) {
          relativeYs.add(element / _maxY * 10);
        });
      }
    } else {
      _mapData = {for (var item in _dates) item: []};
      for (var _ in _dates) {
        relativeYs.add(0);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('build routine histories Tab');

    return CustomStreamBuilderWidget<List<WorkoutHistory?>>(
      stream: widget.database.workoutHistoriesThisWeekStream(
        widget.workout.workoutId,
      ),
      hasDataWidget: (context, data) {
        List<double> relativeYs = [];

        // print('this many whs: ${snapshot.data!.length}');

        _setData(data, relativeYs);

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
              _buildChartWidget(relativeYs),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartWidget(List<double> relativeYs) {
    return Card(
      color: kCardColor,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    final weights = (rod.y / 1.05 / 10 * _maxY).round();
                    final formattedWeights = Formatter.weights(weights);
                    final unit = Formatter.unitOfMass(widget.user.unitOfMass);

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
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
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
                  getTextStyles: (value) => TextStyles.body2,
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
                  getTextStyles: (_) => TextStyles.caption1_grey,
                  getTitles: (double value) {
                    final toOriginalNumber = (value / 10 * _maxY).round();
                    final formatted =
                        NumberFormat.compact().format(toOriginalNumber);
                    final unit = Formatter.unitOfMass(widget.user.unitOfMass);

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
