import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/weekly_progress_chart_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import 'protein_entries_screen.dart';

class WeeklyNutritionChart extends StatefulWidget {
  final AuthBase auth;
  final Database database;
  final User user;
  final WeeklyProgressChartModel model;

  const WeeklyNutritionChart({
    Key? key,
    required this.auth,
    required this.database,
    required this.user,
    required this.model,
  }) : super(key: key);

  static Widget create(BuildContext context, {required User user}) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return Consumer(
      builder: (context, watch, child) => WeeklyNutritionChart(
        auth: auth,
        database: database,
        model: watch(weeklyProgressChartModelProvider),
        user: user,
      ),
    );
  }

  @override
  _WeeklyNutritionChartState createState() => _WeeklyNutritionChartState();
}

class _WeeklyNutritionChartState extends State<WeeklyNutritionChart> {
  int? touchedIndex;

  void _setData(
    List<Nutrition>? streamData,
    List<double> relativeYs,
  ) {
    Map<DateTime, List<Nutrition>> _mapData;
    List<num> listOfYs = [];
    if (streamData != null) {
      _mapData = {
        for (var item in widget.model.dates)
          item: streamData.where((e) => e.loggedDate.toUtc() == item).toList()
      };

      _mapData.values.forEach((list) {
        num sum = 0;

        if (list.isNotEmpty) {
          list.forEach((nutrition) {
            sum += nutrition.proteinAmount;
          });
        }

        listOfYs.add(sum);
      });
      final largest = listOfYs.reduce(math.max);

      if (largest == 0) {
        widget.model.setNutritionMaxY(150);
        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largest / 10).ceil() * 10;

        if (widget.user.dailyProteinGoal != null) {
          if (roundedLargest <= widget.user.dailyProteinGoal!) {
            widget.model.setNutritionMaxY(widget.user.dailyProteinGoal! + 10);
          } else {
            widget.model.setNutritionMaxY(roundedLargest.toDouble());
          }
        } else {
          widget.model.setNutritionMaxY(roundedLargest.toDouble());
        }

        listOfYs.forEach((element) {
          relativeYs.add(element / widget.model.nutritionMaxY * 10);
        });
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
              onTap: () => ProteinEntriesScreen.show(context),
              child: Wrap(
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restaurant_menu_rounded,
                          color: Colors.greenAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.current.addProteins,
                          style: kSubtitle1w900GreenAc,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.greenAccent,
                            size: 16,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: Text(
                      S.current.proteinChartContentText,
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
    //   },
    // );
  }

  Widget _buildChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: CustomStreamBuilderWidget<List<Nutrition>?>(
          stream: widget.database.thisWeeksNutritionsStream(),
          hasDataWidget: (context, data) {
            List<double> _relativeYs = [];

            _setData(data, _relativeYs);

            print('protein goal is ${widget.user.dailyProteinGoal}');
            print('max y is ${widget.model.nutritionMaxY}');

            final _interval = (widget.user.dailyProteinGoal != null)
                ? widget.user.dailyProteinGoal! /
                    widget.model.nutritionMaxY *
                    10
                : 1.00;

            return Stack(
              children: [
                BarChart(
                  BarChartData(
                    maxY: 10,
                    gridData: FlGridData(
                      horizontalInterval: _interval,
                      drawVerticalLine: false,
                      show: widget.user.dailyProteinGoal != null,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.greenAccent.withOpacity(0.5),
                        dashArray: [16, 4],
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final amount =
                              (rod.y / 1.05 / 10 * widget.model.nutritionMaxY)
                                  .round();
                          final formattedAmount = Formatter.proteins(amount);

                          return BarTooltipItem(
                            '$formattedAmount g',
                            kBodyText1Black,
                          );
                        },
                      ),
                      touchCallback: (barTouchResponse) {
                        setState(() {
                          if (barTouchResponse.spot != null &&
                              barTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              barTouchResponse.touchInput is! PointerUpEvent) {
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
                        margin: 24,
                        reservedSize: 24,
                        getTextStyles: (value) => kCaption1Grey,
                        getTitles: (double value) {
                          final toOriginalNumber =
                              (value / 10 * widget.model.nutritionMaxY).round();

                          switch (value.toInt()) {
                            case 0:
                              return '0g';
                            case 5:
                              return '$toOriginalNumber g';
                            case 10:
                              return '$toOriginalNumber g';

                            default:
                              return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: (data!.isNotEmpty)
                        ? _barGroupsChild(_relativeYs)
                        : randomData(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
          y: isTouched ? y + 0.05 * y : y,
          colors: isTouched ? [Colors.green] : [Colors.greenAccent],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
            y: 10,
            colors: [kCardColorLight],
          ),
        ),
      ],
    );
  }

  // TODO: Polish code here
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
      _makeBarChartGroupData(x: 0, y: 7, isTouched: touchedIndex == 0),
      _makeBarChartGroupData(x: 1, y: 6, isTouched: touchedIndex == 1),
      _makeBarChartGroupData(x: 2, y: 8.9, isTouched: touchedIndex == 2),
      _makeBarChartGroupData(x: 3, y: 8, isTouched: touchedIndex == 3),
      _makeBarChartGroupData(x: 4, y: 6.8, isTouched: touchedIndex == 4),
      _makeBarChartGroupData(x: 5, y: 10, isTouched: touchedIndex == 5),
      _makeBarChartGroupData(x: 6, y: 9, isTouched: touchedIndex == 6),
    ];
  }
}
