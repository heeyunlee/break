import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';
import 'package:workout_player/view/widgets/charts/no_data_in_chart_message_widget.dart';

class WeeklyBarChartCardTemplate extends StatelessWidget {
  final ProgressTabClass progressTabClass;
  final BoxConstraints constraints;
  final Color defaultColor;
  final Color touchedColor;
  final ChangeNotifierProviderFamily<dynamic, ProgressTabClass> model;
  final void Function()? onTap;
  final IconData titleIcon;
  final String title;
  final String? subtitle;

  const WeeklyBarChartCardTemplate({
    Key? key,
    required this.progressTabClass,
    required this.constraints,
    required this.defaultColor,
    required this.touchedColor,
    required this.model,
    this.onTap,
    required this.titleIcon,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 2 : 1.5;

    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight / heightFactor,
      child: BlurBackgroundCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          Icon(titleIcon, color: defaultColor, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: TextStyles.subtitle1_w900.copyWith(
                              color: defaultColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: defaultColor,
                              size: 16,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(subtitle!, style: TextStyles.body2),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              /// Chart
              Consumer(
                builder: (context, watch, child) => WeeklyBarChart(
                  defaultColor: defaultColor,
                  touchedColor: touchedColor,
                  model: watch(model(progressTabClass)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyBarChart extends StatefulWidget {
  final dynamic model;
  final Color defaultColor;
  final Color touchedColor;

  const WeeklyBarChart({
    Key? key,
    required this.model,
    required this.defaultColor,
    required this.touchedColor,
  }) : super(key: key);

  @override
  _WeeklyBarChartState createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  @override
  Widget build(BuildContext context) {
    widget.model.init();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 8),
        child: Stack(
          children: [
            BarChart(
              BarChartData(
                maxY: 10,
                gridData: _buildGrid(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        widget.model.getTooltipText(rod.y) as String,
                        TextStyles.body1_black,
                      );
                    },
                  ),
                  touchCallback: widget.model.onTouchCallback as dynamic
                      Function(BarTouchResponse)?,
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
                          return widget.model.daysOfTheWeek[0] as String;
                        case 1:
                          return widget.model.daysOfTheWeek[1] as String;
                        case 2:
                          return widget.model.daysOfTheWeek[2] as String;
                        case 3:
                          return widget.model.daysOfTheWeek[3] as String;
                        case 4:
                          return widget.model.daysOfTheWeek[4] as String;
                        case 5:
                          return widget.model.daysOfTheWeek[5] as String;
                        case 6:
                          return widget.model.daysOfTheWeek[6] as String;
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
                      switch (value.toInt()) {
                        case 0:
                          return widget.model.getSideTiles(value) as String;
                        case 5:
                          return widget.model.getSideTiles(value) as String;
                        case 10:
                          return widget.model.getSideTiles(value) as String;
                        default:
                          return '';
                      }
                    },
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: (widget.model.relativeYs.isNotEmpty as bool)
                    ? _hasData()
                    : randomData(),
              ),
            ),
            if (widget.model.relativeYs.isEmpty as bool)
              NoDataInChartMessageWidget(color: widget.defaultColor),
          ],
        ),
      ),
    );
  }

  FlGridData _buildGrid() {
    return FlGridData(
      horizontalInterval: widget.model.interval as double?,
      drawVerticalLine: false,
      show: widget.model.goalExists as bool?,
      getDrawingHorizontalLine: (_) => FlLine(
        color: widget.defaultColor.withOpacity(0.5),
        dashArray: [16, 4],
      ),
    );
  }

  List<BarChartGroupData> _hasData() {
    return List.generate(
      7,
      (index) => _makeBarChartGroupData(
        x: index,
        y: widget.model.relativeYs[index] as double,
        isTouched: widget.model.touchedIndex == index,
        defaultColor: widget.defaultColor,
        touchedColor: widget.touchedColor,
      ),
    );
  }

  List<BarChartGroupData> randomData() {
    return List.generate(
      7,
      (index) => _makeBarChartGroupData(
        x: index,
        y: widget.model.randomListOfYs[index] as double,
        isTouched: widget.model.touchedIndex == index,
        defaultColor: widget.defaultColor.withOpacity(0.25),
        touchedColor: widget.defaultColor.withOpacity(0.5),
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    double width = 16,
    bool isTouched = false,
    required Color defaultColor,
    required Color touchedColor,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y * 1.05 : y,
          colors: isTouched ? [touchedColor] : [defaultColor],
          width: width,
        ),
      ],
    );
  }
}
