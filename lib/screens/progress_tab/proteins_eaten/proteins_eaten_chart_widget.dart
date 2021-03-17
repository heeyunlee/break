import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/user.dart';

import '../../../constants.dart';

class ProteinsEatenChartWidget extends StatefulWidget {
  final User user;

  const ProteinsEatenChartWidget({Key key, this.user}) : super(key: key);

  @override
  _ProteinsEatenChartWidgetState createState() =>
      _ProteinsEatenChartWidgetState();
}

class _ProteinsEatenChartWidgetState extends State<ProteinsEatenChartWidget> {
  int touchedIndex;
  DateTime _now;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.heavyImpact();
        },
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restaurant_menu_rounded,
                        color: Colors.brown,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text('Eat Proteins', style: Subtitle1w900Brown),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Getting your protein is as important as working out! Get your daily goal of 150g',
                    style: BodyText2,
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.6,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final amount = (rod.y / 1.1).round().toDouble();
                            final formattedAmount = Format.weights(amount);

                            return BarTooltipItem(
                              '$formattedAmount g',
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
                              touchedIndex =
                                  barTouchResponse.spot.touchedBarGroupIndex;
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
                            final _2daysAgoE = DateFormat.E().format(_2daysAgo);
                            final _3daysAgoE = DateFormat.E().format(_3daysAgo);
                            final _4daysAgoE = DateFormat.E().format(_4daysAgo);
                            final _5daysAgoE = DateFormat.E().format(_5daysAgo);
                            final _6daysAgoE = DateFormat.E().format(_6daysAgo);

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
                        leftTitles: SideTitles(
                          showTitles: false,
                          margin: 16,
                          reservedSize: 24,
                          getTextStyles: (value) => BodyText2Grey,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '0g';
                              case 50:
                                return '50g';
                              case 100:
                                return '100g';
                              case 150:
                                return '150g';
                              default:
                                return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _barGroupsChild(),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          y: isTouched ? y + 0.1 * y : y,
          colors: isTouched ? [Colors.brown[700]] : [Colors.brown],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(show: true, y: 160,
              // colors: [Colors.grey[600]],
              colors: [CardColorLight]),
        ),
      ],
    );
  }

  List<BarChartGroupData> _barGroupsChild() {
    return [
      _makeBarChartGroupData(x: 0, y: 120, isTouched: touchedIndex == 0),
      _makeBarChartGroupData(x: 1, y: 100, isTouched: touchedIndex == 1),
      _makeBarChartGroupData(x: 2, y: 140, isTouched: touchedIndex == 2),
      _makeBarChartGroupData(x: 3, y: 180, isTouched: touchedIndex == 3),
      _makeBarChartGroupData(x: 4, y: 90, isTouched: touchedIndex == 4),
      _makeBarChartGroupData(x: 5, y: 0, isTouched: touchedIndex == 5),
      _makeBarChartGroupData(x: 6, y: 160, isTouched: touchedIndex == 6),
    ];
  }
}
