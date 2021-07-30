import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/classes/combined/progress_tab_class.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

import '../weekly_bar_chart.dart';
import 'weekly_carbs_bar_chart_model.dart';

class WeeklyCarbsBarChart extends StatelessWidget {
  final ProgressTabClass progressTabClass;
  final BoxConstraints constraints;

  const WeeklyCarbsBarChart({
    Key? key,
    required this.progressTabClass,
    required this.constraints,
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
              _buildTitle(context),
              const SizedBox(height: 16),

              /// Chart
              Consumer(
                builder: (context, watch, child) => WeeklyBarChart(
                  defaultColor: Colors.lightGreenAccent,
                  touchedColor: Colors.lightGreen,
                  model: watch(
                    weeklyCarbsBarChartModelProvider(progressTabClass),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTap: () => ProteinEntriesScreen.show(context),
      child: Wrap(
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Colors.lightGreenAccent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  S.current.carbs,
                  style: TextStyles.subtitle1_w900_lightGreenAccent,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.lightGreenAccent,
                    size: 16,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'asda asd asda sad s',
              style: TextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }
}
