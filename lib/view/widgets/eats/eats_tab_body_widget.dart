import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class EatsTabBodyWidget extends StatelessWidget {
  const EatsTabBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilder<EatsTabClass>(
      stream: database.eatsTabStream(),
      builder: (context, data) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              backgroundColor: kAppBarColor,
              expandedHeight: size.height * 3 / 4,
              flexibleSpace: EatsTabFlexibleSpaceBar(data: data),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const SizedBox(width: 28),
                      Text(
                        S.current.recentTransactions,
                        style: TextStyles.body1W800,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.current.seeMore,
                            style: TextStyles.button1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.all(16),
                    color: kCardColor,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          kCustomDividerIndent8Heignt1,
                      itemCount: data.recentNutritions.length,
                      itemBuilder: (context, index) {
                        return NutritionsListTile(
                          nutrition: data.recentNutritions[index],
                        );
                      },
                    ),
                  ),
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   margin: const EdgeInsets.all(16),
                  //   color: kCardColor,
                  //   child: SizedBox(
                  //     width: size.width,
                  //     height: size.height / 3,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //         vertical: 8,
                  //         horizontal: 16,
                  //       ),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           GestureDetector(
                  //             behavior: HitTestBehavior.opaque,
                  //             onTap: () => CaloriesEntriesScreen.show(
                  //               context,
                  //               user: data.user,
                  //             ),
                  //             child: Wrap(
                  //               children: [
                  //                 SizedBox(
                  //                   height: 48,
                  //                   child: Row(
                  //                     children: [
                  //                       const Icon(
                  //                         Icons.local_fire_department_rounded,
                  //                         color: Colors.greenAccent,
                  //                         size: 16,
                  //                       ),
                  //                       const SizedBox(width: 8),
                  //                       Text(
                  //                         S.current.consumedCalorie,
                  //                         style:
                  //                             TextStyles.subtitle1W900.copyWith(
                  //                           color: Colors.greenAccent,
                  //                         ),
                  //                       ),
                  //                       const Padding(
                  //                         padding: EdgeInsets.symmetric(
                  //                             horizontal: 8),
                  //                         child: Icon(
                  //                           Icons.arrow_forward_ios_rounded,
                  //                           color: Colors.greenAccent,
                  //                           size: 16,
                  //                         ),
                  //                       ),
                  //                       const Spacer(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           const SizedBox(height: 16),

                  //           /// Chart
                  //           Consumer(
                  //             builder: (context, watch, child) {
                  //               final model =
                  //                   watch(weeklyCaloriesChartModelProvider);

                  //               return Expanded(
                  //                 child: Stack(
                  //                   children: [
                  //                     BarChart(
                  //                       BarChartData(
                  //                         maxY: 10,
                  //                         gridData: _buildGrid(),
                  //                         barTouchData: BarTouchData(
                  //                           touchTooltipData:
                  //                               BarTouchTooltipData(
                  //                             getTooltipItem: (group,
                  //                                 groupIndex, rod, rodIndex) {
                  //                               return BarTooltipItem(
                  //                                 model.getTooltipText(
                  //                                     data.user, rod.y),
                  //                                 TextStyles.body1Black,
                  //                               );
                  //                             },
                  //                           ),
                  //                           touchCallback:
                  //                               model.onTouchCallback,
                  //                         ),
                  //                         titlesData: FlTitlesData(
                  //                           show: true,
                  //                           topTitles:
                  //                               SideTitles(showTitles: false),
                  //                           rightTitles:
                  //                               SideTitles(showTitles: false),
                  //                           bottomTitles: SideTitles(
                  //                             showTitles: true,
                  //                             getTextStyles: (_, __) =>
                  //                                 TextStyles.body2,
                  //                             margin: 16,
                  //                             getTitles: (double value) {
                  //                               switch (value.toInt()) {
                  //                                 case 0:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[0]
                  //                                       as String;
                  //                                 case 1:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[1]
                  //                                       as String;
                  //                                 case 2:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[2]
                  //                                       as String;
                  //                                 case 3:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[3]
                  //                                       as String;
                  //                                 case 4:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[4]
                  //                                       as String;
                  //                                 case 5:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[5]
                  //                                       as String;
                  //                                 case 6:
                  //                                   return widget.model
                  //                                           .daysOfTheWeek[6]
                  //                                       as String;
                  //                                 default:
                  //                                   return '';
                  //                               }
                  //                             },
                  //                           ),
                  //                           leftTitles: SideTitles(
                  //                             showTitles: true,
                  //                             reservedSize: 64,
                  //                             getTextStyles: (_, __) =>
                  //                                 TextStyles.caption1Grey,
                  //                             getTitles: (double value) {
                  //                               switch (value.toInt()) {
                  //                                 case 0:
                  //                                   return widget.model
                  //                                           .getSideTiles(value)
                  //                                       as String;
                  //                                 case 5:
                  //                                   return widget.model
                  //                                           .getSideTiles(value)
                  //                                       as String;
                  //                                 case 10:
                  //                                   return widget.model
                  //                                           .getSideTiles(value)
                  //                                       as String;
                  //                                 default:
                  //                                   return '';
                  //                               }
                  //                             },
                  //                           ),
                  //                         ),
                  //                         borderData: FlBorderData(show: false),
                  //                         barGroups: (widget.model.relativeYs
                  //                                 .isNotEmpty as bool)
                  //                             ? _hasData()
                  //                             : randomData(),
                  //                       ),
                  //                     ),
                  //                     if (widget.model.relativeYs.isEmpty
                  //                         as bool)
                  //                       NoDataInChartMessageWidget(
                  //                           color: widget.defaultColor),
                  //                   ],
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // FlGridData _buildGrid() {
  //   return FlGridData(
  //     horizontalInterval: widget.model.interval as double?,
  //     drawVerticalLine: false,
  //     show: widget.model.goalExists as bool?,
  //     getDrawingHorizontalLine: (_) => FlLine(
  //       color: Colors.greenAccent.withOpacity(0.5),
  //       dashArray: [16, 4],
  //     ),
  //   );
  // }

  // List<BarChartGroupData> _hasData(WeeklyCaloriesChartModel model) {
  //   return List.generate(
  //     7,
  //     (index) => _makeBarChartGroupData(
  //       x: index,
  //       y: model.relativeYs[index],
  //       isTouched: model.touchedIndex == index,
  //       defaultColor: Colors.greenAccent,
  //       touchedColor: Colors.green,
  //     ),
  //   );
  // }

  // List<BarChartGroupData> randomData(WeeklyCaloriesChartModel model) {
  //   return List.generate(
  //     7,
  //     (index) => _makeBarChartGroupData(
  //       x: index,
  //       y: model.randomListOfYs[index],
  //       isTouched: model.touchedIndex == index,
  //       defaultColor: Colors.greenAccent.withOpacity(0.25),
  //       touchedColor: Colors.greenAccent.withOpacity(0.5),
  //     ),
  //   );
  // }

  // BarChartGroupData _makeBarChartGroupData({
  //   required int x,
  //   required double y,
  //   double width = 16,
  //   bool isTouched = false,
  //   required Color defaultColor,
  //   required Color touchedColor,
  // }) {
  //   return BarChartGroupData(
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         y: isTouched ? y * 1.05 : y,
  //         colors: isTouched ? [touchedColor] : [defaultColor],
  //         width: width,
  //       ),
  //     ],
  //   );
  // }
}
