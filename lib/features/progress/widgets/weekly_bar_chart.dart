import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/providers.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/utils/list_extension.dart';

class WeeklyBarChart extends ConsumerStatefulWidget {
  const WeeklyBarChart({
    required this.color,
    required this.leadingIcon,
    required this.title,
    required this.unit,
    required this.yValues,
    this.isEmpty = false,
    this.elevation = 6,
    this.contentPadding = const EdgeInsets.all(16),
    this.height,
    this.width,
    this.cardMargin,
    this.cardColor,
    this.titleOnTap,
    this.subtitle,
    Key? key,
  })  : assert(yValues.length == 7, 'yValues\' length has to be exactly 7'),
        super(key: key);

  final Color color;
  final IconData leadingIcon;
  final String title;
  final String unit;
  final List<double> yValues;
  final bool isEmpty;
  final double elevation;
  final EdgeInsets contentPadding;
  final double? height;
  final double? width;
  final EdgeInsets? cardMargin;
  final Color? cardColor;
  final VoidCallback? titleOnTap;
  final String? subtitle;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends ConsumerState<WeeklyBarChart> {
  int get maxY {
    final number = widget.yValues.max.ceil();
    if (number % 2 == 1) {
      return number + 1;
    } else {
      return number;
    }
  }

  int? _selectedIndex;

  void _touchCallback(FlTouchEvent event, BarTouchResponse? response) {
    setState(() {
      if (response?.spot != null && event is! FlTapUpEvent) {
        _selectedIndex = response?.spot!.touchedBarGroupIndex;
      } else {
        _selectedIndex = -1;
      }
    });
  }

  BarTooltipItem? _getToolTipItem(_, __, BarChartRodData rod, ___) {
    final backToNormal = rod.toY / 1.05;
    final formatted = Formatter.numWithoutDecimal(backToNormal);

    return BarTooltipItem(
      '$formatted ${widget.unit}',
      TextStyles.body1,
    );
  }

  String _getTitle(double y) {
    if (y == maxY) return '';

    if (y.toString().length > 3) {
      final formatted = NumberFormat.compact().format(y);
      return '$formatted ${widget.unit}';
    }

    return '${y.ceil()} ${widget.unit}';
  }

  TextStyle? _getLeftTitleTextStyle(BuildContext context, double y) {
    return TextStyles.body2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variables = ref.watch(topLevelVariablesProvider);

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Card(
        margin: widget.cardMargin,
        elevation: widget.elevation,
        color: widget.cardColor ?? theme.cardTheme.color,
        child: Padding(
          padding: widget.contentPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: widget.titleOnTap,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.leadingIcon,
                        color: widget.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.title,
                        style: TextStyles.subtitle1W900.copyWith(
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: widget.color,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.subtitle!, style: TextStyles.body2),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    BarChart(
                      BarChartData(
                        maxY: maxY.toDouble(),
                        gridData: FlGridData(
                          // drawVerticalLine: false,
                          show: false,
                          // getDrawingHorizontalLine: (_) => FlLine(
                          //   color: widget.defaultColor.withOpacity(0.5),
                          //   dashArray: [16, 4],
                          // ),
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: _getToolTipItem,
                          ),
                          touchCallback: _touchCallback,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (_, __) => TextStyles.body2,
                            margin: 16,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return variables.thisWeekDaysOfTheWeek[0];
                                case 1:
                                  return variables.thisWeekDaysOfTheWeek[1];
                                case 2:
                                  return variables.thisWeekDaysOfTheWeek[2];
                                case 3:
                                  return variables.thisWeekDaysOfTheWeek[3];
                                case 4:
                                  return variables.thisWeekDaysOfTheWeek[4];
                                case 5:
                                  return variables.thisWeekDaysOfTheWeek[5];
                                case 6:
                                  return variables.thisWeekDaysOfTheWeek[6];
                                default:
                                  return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 64,
                            textAlign: TextAlign.end,
                            getTextStyles: _getLeftTitleTextStyle,
                            getTitles: _getTitle,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildBarGroups(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(
      7,
      (index) => _makeBarChartGroupData(
        x: index,
        y: widget.yValues[index],
        selected: _selectedIndex == index,
        color: widget.isEmpty ? widget.color.withOpacity(0.5) : widget.color,
      ),
    );
  }

  BarChartGroupData _makeBarChartGroupData({
    required int x,
    required double y,
    required Color color,
    bool selected = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: selected ? y * 1.05 : y,
          colors: selected
              ? [Color.alphaBlend(color.withOpacity(0.9), Colors.black)]
              : [color],
          width: 16,
        ),
      ],
    );
  }
}
