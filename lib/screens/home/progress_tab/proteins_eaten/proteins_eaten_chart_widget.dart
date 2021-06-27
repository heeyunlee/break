import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:intl/intl.dart';
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

class ProteinsEatenChartWidget extends StatefulWidget {
  final AuthBase auth;
  final Database database;

  const ProteinsEatenChartWidget({
    Key? key,
    required this.auth,
    required this.database,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return ProteinsEatenChartWidget(
      auth: auth,
      database: database,
    );
  }

  @override
  _ProteinsEatenChartWidgetState createState() =>
      _ProteinsEatenChartWidgetState();
}

class _ProteinsEatenChartWidgetState extends State<ProteinsEatenChartWidget> {
  int? touchedIndex;
  double _maxY = 150;

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];

  void _setData(List<Nutrition>? streamData, List<double> relativeYs) {
    Map<DateTime, List<Nutrition>> _mapData;
    List<num> listOfYs = [];

    if (streamData != null) {
      _mapData = {
        for (var item in _dates)
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
      final largest = listOfYs.reduce(max);

      if (largest == 0) {
        _maxY = 150;
        listOfYs.forEach((element) {
          relativeYs.add(0);
        });
      } else {
        final roundedLargest = (largest / 10).ceil() * 10;
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
    // setSevenDaysOfHistory();
    // setMaxY();

    return CustomStreamBuilderWidget<List<Nutrition>?>(
      stream: widget.database.thisWeeksNutritionsStream(),
      hasDataWidget: (context, data) {
        List<double> relativeYs = [];
        _setData(data, relativeYs);

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
                if (data!.isEmpty) const Divider(color: kGrey700),
                const SizedBox(height: 16),
                _buildChart(_maxY, relativeYs, data),
              ],
            ),
          ),
        );
      },
    );

    // return Consumer(
    //   builder: (context, watch, child) {
    //     List<double> relativeYs = [];

    //     print('proteins widget building...');

    //     final uid = widget.auth.currentUser!.uid;
    //     final stream = watch(thisWeeksNutritionsStreamProvider(uid));

    //     return stream.when(
    //       loading: () => CircularProgressIndicator(),
    //       error: (e, stack) {
    //         logger.e(e);
    //         return EmptyContent();
    //       },
    //       data: (streamData) {
    //         _setData(streamData, relativeYs);

    //         return BlurBackgroundCard(
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(
    //               vertical: 8,
    //               horizontal: 16,
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: [
    //                 GestureDetector(
    //                   behavior: HitTestBehavior.opaque,
    //                   onTap: () => ProteinEntriesScreen.show(context),
    //                   child: Wrap(
    //                     children: [
    //                       SizedBox(
    //                         height: 48,
    //                         child: Row(
    //                           children: [
    //                             const Icon(
    //                               Icons.restaurant_menu_rounded,
    //                               color: Colors.greenAccent,
    //                               size: 16,
    //                             ),
    //                             const SizedBox(width: 8),
    //                             Text(
    //                               S.current.addProteins,
    //                               style: kSubtitle1w900GreenAc,
    //                             ),
    //                             const Padding(
    //                               padding: EdgeInsets.symmetric(
    //                                 horizontal: 8,
    //                               ),
    //                               child: Icon(
    //                                 Icons.arrow_forward_ios_rounded,
    //                                 color: Colors.greenAccent,
    //                                 size: 16,
    //                               ),
    //                             ),
    //                             const Spacer(),
    //                             // if (widget.user.dailyWeightsGoal == null)
    //                             //   TextButton(
    //                             //     style: TextButton.styleFrom(
    //                             //       padding: EdgeInsets.zero,
    //                             //     ),
    //                             //     onPressed: () {},
    //                             //     child: Row(
    //                             //       children: [
    //                             //         Text(
    //                             //           S.current.setWeightsDailyGoal,
    //                             //           style: kButtonText2,
    //                             //         ),
    //                             //         const SizedBox(width: 4),
    //                             //         const Icon(
    //                             //           Icons.add_rounded,
    //                             //           color: Colors.white,
    //                             //           size: 16,
    //                             //         ),
    //                             //       ],
    //                             //     ),
    //                             //   ),
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(top: 8, bottom: 32),
    //                         child: Text(
    //                           S.current.proteinChartContentText,
    //                           style: kBodyText2,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 AspectRatio(
    //                   aspectRatio: 1.5,
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(left: 16, right: 8),
    //                     child: BarChart(
    //                       BarChartData(
    //                         maxY: 10,
    //                         barTouchData: BarTouchData(
    //                           touchTooltipData: BarTouchTooltipData(
    //                             getTooltipItem:
    //                                 (group, groupIndex, rod, rodIndex) {
    //                               final amount =
    //                                   (rod.y / 1.05 / 10 * _maxY).round();
    //                               final formattedAmount =
    //                                   Formatter.proteins(amount);

    //                               return BarTooltipItem(
    //                                 '$formattedAmount g',
    //                                 kBodyText1Black,
    //                               );
    //                             },
    //                           ),
    //                           touchCallback: (barTouchResponse) {
    //                             setState(() {
    //                               if (barTouchResponse.spot != null &&
    //                                   barTouchResponse.touchInput
    //                                       is! PointerExitEvent &&
    //                                   barTouchResponse.touchInput
    //                                       is! PointerUpEvent) {
    //                                 touchedIndex = barTouchResponse
    //                                     .spot!.touchedBarGroupIndex;
    //                               } else {
    //                                 touchedIndex = -1;
    //                               }
    //                             });
    //                           },
    //                         ),
    //                         titlesData: FlTitlesData(
    //                           show: true,
    //                           bottomTitles: SideTitles(
    //                             showTitles: true,
    //                             getTextStyles: (value) => kBodyText2,
    //                             margin: 16,
    //                             getTitles: (double value) {
    //                               switch (value.toInt()) {
    //                                 case 0:
    //                                   return _daysOfTheWeek[0];
    //                                 case 1:
    //                                   return _daysOfTheWeek[1];
    //                                 case 2:
    //                                   return _daysOfTheWeek[2];
    //                                 case 3:
    //                                   return _daysOfTheWeek[3];
    //                                 case 4:
    //                                   return _daysOfTheWeek[4];
    //                                 case 5:
    //                                   return _daysOfTheWeek[5];
    //                                 case 6:
    //                                   return _daysOfTheWeek[6];
    //                                 default:
    //                                   return '';
    //                               }
    //                             },
    //                           ),
    //                           leftTitles: SideTitles(
    //                             showTitles: true,
    //                             margin: 24,
    //                             reservedSize: 24,
    //                             getTextStyles: (value) => kCaption1Grey,
    //                             getTitles: (double value) {
    //                               final toOriginalNumber =
    //                                   (value / 10 * _maxY).round();

    //                               switch (value.toInt()) {
    //                                 case 0:
    //                                   return '0g';
    //                                 case 5:
    //                                   return '$toOriginalNumber g';
    //                                 case 10:
    //                                   return '$toOriginalNumber g';

    //                                 default:
    //                                   return '';
    //                               }
    //                             },
    //                           ),
    //                         ),
    //                         borderData: FlBorderData(show: false),
    //                         barGroups: (streamData!.isNotEmpty)
    //                             ? _barGroupsChild(relativeYs)
    //                             : randomData(),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }

  Widget _buildChart(
      double maxY, List<double> relativeYs, List<Nutrition> list) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: BarChart(
          BarChartData(
            maxY: 10,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final amount = (rod.y / 1.05 / 10 * _maxY).round();
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
                      barTouchResponse.touchInput is! PointerExitEvent &&
                      barTouchResponse.touchInput is! PointerUpEvent) {
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
                margin: 24,
                reservedSize: 24,
                getTextStyles: (value) => kCaption1Grey,
                getTitles: (double value) {
                  final toOriginalNumber = (value / 10 * _maxY).round();

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
            barGroups:
                (list.isNotEmpty) ? _barGroupsChild(relativeYs) : randomData(),
          ),
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
            // show: _sevenDayHistory.isEmpty,
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
