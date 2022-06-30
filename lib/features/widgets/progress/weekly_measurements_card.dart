import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/screens/measurements_screen.dart';
import 'package:workout_player/features/widgets/cards/blur_background_card.dart';
import 'package:workout_player/view_models/weekly_measurements_chart_model.dart';

import 'weekly_measurements_chart.dart';

class WeeklyMeasurementsCard extends StatelessWidget {
  final ProgressTabClass data;
  final BoxConstraints constraints;

  const WeeklyMeasurementsCard({
    Key? key,
    required this.data,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => MeasurementsScreen.show(context, user: data.user),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.line_weight_rounded,
                          color: Colors.lightBlueAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.current.bodyMeasurement,
                          style: TextStyles.subtitle1W900LightBlueAccent,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.lightBlueAccent,
                            size: 16,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        S.current.addMasurementDataMessage,
                        style: TextStyles.body2,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) => WeeklyMeasurementsChart(
                  model: ref.watch(weeklyMeasurementsChartModelProvider),
                  user: data.user,
                  measurements: data.measurements,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
