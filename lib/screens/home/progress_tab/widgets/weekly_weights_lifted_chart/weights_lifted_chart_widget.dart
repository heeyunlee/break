import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:intl/intl.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../../weekly_progress_chart_model.dart';
import 'routine_histories_screen.dart';

class WeightsLiftedChartWidget extends StatefulWidget {
  final AuthBase auth;
  final Database database;
  final User user;
  final WeeklyProgressChartModel model;

  const WeightsLiftedChartWidget({
    Key? key,
    required this.auth,
    required this.database,
    required this.user,
    required this.model,
  }) : super(key: key);

  static Widget create(
    BuildContext context, {
    required User user,
  }) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return Consumer(
      builder: (context, ref, child) => WeightsLiftedChartWidget(
        auth: auth,
        database: database,
        user: user,
        model: ref.watch(weeklyProgressChartModelProvider),
      ),
    );
  }

  @override
  _WeightsLiftedChartWidgetState createState() =>
      _WeightsLiftedChartWidgetState();
}

class _WeightsLiftedChartWidgetState extends State<WeightsLiftedChartWidget> {
  int? touchedIndex;

  void _setData(List<RoutineHistory?> streamData, List<double> relativeYs) {
    Map<DateTime, List<RoutineHistory?>> _mapData;
    List<num> listOfYs = [];

    if (streamData.isNotEmpty) {
      _mapData = {
        for (var item in widget.model.dates)
          item: streamData.where((e) => e!.workoutDate.toUtc() == item).toList()
      };
      _mapData.values.forEach((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          list.forEach((history) {
            sum += history!.totalWeights;
          });
        }

        listOfYs.add(sum);
      });

      final largest = listOfYs.reduce(math.max);

      if (largest == 0) {
        // _maxY = 20000;
        widget.model.setWeightsChartMaxY(20000);

        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largest / 1000).ceil() * 1000;

        if (widget.user.dailyWeightsGoal != null) {
          if (roundedLargest <= widget.user.dailyWeightsGoal!) {
            widget.model
                .setWeightsChartMaxY(widget.user.dailyWeightsGoal! + 1000);
          } else {
            widget.model.setWeightsChartMaxY(roundedLargest.toDouble());
          }
        } else {
          widget.model.setWeightsChartMaxY(roundedLargest.toDouble());
        }

        listOfYs.forEach((element) {
          relativeYs.add(element / widget.model.weightsChartMaxY * 10);
        });
      }
    } else {
      _mapData = {for (var item in widget.model.dates) item: []};
      for (var _ in widget.model.dates) {
        relativeYs.add(0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.model.setDaysOfTheWeek();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlurBackgroundCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      S.current.weightsChartMessage,
                      style: TextStyles.body2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return CustomStreamBuilderWidget<List<RoutineHistory?>>(
      stream: widget.database.routineHistoriesThisWeekStream(),
      hasDataWidget: (context, data) {
        List<double> relativeYs = [];
        _setData(data, relativeYs);

        final _interval = (widget.user.dailyWeightsGoal != null)
            ? widget.user.dailyWeightsGoal! / widget.model.weightsChartMaxY * 10
            : 1.00;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 8),
            child: BarChart(
              BarChartData(
                maxY: 10,
                gridData: FlGridData(
                  horizontalInterval: _interval,
                  drawVerticalLine: false,
                  show: widget.user.dailyWeightsGoal != null,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: kPrimaryColor.withOpacity(0.5),
                    dashArray: [16, 4],
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final weights =
                          (rod.y / 1.05 / 10 * widget.model.weightsChartMaxY)
                              .round();
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
                    margin: 28,
                    getTextStyles: (_) => TextStyles.caption1_grey,
                    getTitles: (double value) {
                      final toOriginalNumber =
                          (value / 10 * widget.model.weightsChartMaxY).round();
                      final formatted =
                          NumberFormat.compact().format(toOriginalNumber);
                      final unit = Formatter.unitOfMass(widget.user.unitOfMass);

                      // final unit = UnitOfMass.values[widget.user.unitOfMass].label;

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
                barGroups: (data.isNotEmpty)
                    ? _barGroupsChild(relativeYs)
                    : randomData(),
              ),
            ),
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

  List<BarChartGroupData> randomData() {
    return [
      _makeBarChartGroupData(
        x: 0,
        y: 8,
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
        y: 2,
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
