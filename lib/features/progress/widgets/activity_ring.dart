import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/styles/text_styles.dart';

class ActivityRing extends StatelessWidget {
  const ActivityRing({
    Key? key,
    required this.height,
    required this.width,
    required this.liftedWeights,
    required this.weightGoal,
    required this.consumedProtein,
    required this.proteinGoal,
    required this.unit,
    required this.muscleName,
    this.contentSymmetricPadding = 24,
    this.cardPadding = EdgeInsets.zero,
    this.isSelected = false,
    this.elevation = 0,
    this.onTap,
    this.cardColor,
  }) : super(key: key);

  final double height;
  final double width;
  final double liftedWeights;
  final double weightGoal;
  final double consumedProtein;
  final double proteinGoal;
  final UnitOfMass unit;
  final String muscleName;

  final double contentSymmetricPadding;
  final EdgeInsets cardPadding;
  final bool isSelected;
  final double elevation;
  final VoidCallback? onTap;
  final Color? cardColor;

  double get bigRadius => (width - contentSymmetricPadding * 2 - 16) / 2 - 4;

  double get smallRadius => (width - contentSymmetricPadding * 2 - 16) / 2 - 36;

  double get textWidth => (width - contentSymmetricPadding * 2 - 16) / 2 - 80;

  double get weightPercent {
    final percent = liftedWeights / weightGoal;
    if (percent > 1) return 1;
    return percent;
  }

  double get proteinPercent {
    final percent = consumedProtein / proteinGoal;
    if (percent > 1) return 1;
    return percent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      width: width,
      child: Card(
        color: cardColor ?? theme.cardTheme.color,
        elevation: elevation,
        margin: cardPadding,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: contentSymmetricPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: textWidth,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            muscleName,
                            style: TextStyles.headline5W900,
                          ),
                        ),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: bigRadius,
                      lineWidth: 12,
                      percent: weightPercent,
                      backgroundColor: Colors.redAccent.withOpacity(0.25),
                      progressColor: Colors.redAccent,
                      animation: true,
                      animationDuration: 1000,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    Center(
                      child: CircularPercentIndicator(
                        radius: smallRadius,
                        lineWidth: 12,
                        percent: proteinPercent,
                        backgroundColor: Colors.greenAccent.withOpacity(0.25),
                        progressColor: Colors.greenAccent,
                        animation: true,
                        animationDuration: 1000,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DailySummaryNumbersWidget(
                      title: S.current.liftedWeights,
                      number: liftedWeights.toInt(),
                      unit: unit.label,
                    ),
                    const SizedBox(height: 16),
                    _DailySummaryNumbersWidget(
                      title: S.current.proteins,
                      backgroundColor: Colors.greenAccent,
                      number: consumedProtein.toInt(),
                      unit: unit.gram,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DailySummaryNumbersWidget extends StatelessWidget {
  const _DailySummaryNumbersWidget({
    required this.title,
    required this.number,
    required this.unit,
    this.backgroundColor = Colors.redAccent,
    Key? key,
  }) : super(key: key);

  final String title;
  final int number;
  final String unit;
  final Color? backgroundColor;

  String get numberString => number.toString();
  int get length => numberString.length - 1;
  String get ones => numberString[length];
  String get tens => (length > 0) ? numberString[length - 1] : '0';
  String get hundreds => (length > 1) ? numberString[length - 2] : '0';
  String? get thousands => (length > 2) ? numberString[length - 3] : null;
  String? get tensOfThousands => (length > 3) ? numberString[length - 4] : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.body2),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (tensOfThousands != null) _buildNumber(tensOfThousands!),
            if (thousands != null) _buildNumber(thousands!),
            if (thousands != null) _buildNumber(',', Colors.transparent),
            _buildNumber(hundreds),
            _buildNumber(tens),
            _buildNumber(ones),
            const SizedBox(width: 4),
            Text(unit, style: TextStyles.body1Menlo),
          ],
        ),
      ],
    );
  }

  Widget _buildNumber(String number, [Color? color]) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      color: color ?? backgroundColor,
      child: Center(
        child: Text(number, style: TextStyles.body1Menlo),
      ),
    );
  }
}
