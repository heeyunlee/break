import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import 'measurements_screen.dart';
import 'weekly_measurements_chart.dart';
import 'weely_measurements_chart_model.dart';

class WeeklyMeasurementsCard extends StatelessWidget {
  final Database database;
  final User user;
  final double gridHeight;
  final double gridWidth;

  const WeeklyMeasurementsCard({
    Key? key,
    required this.database,
    required this.user,
    required this.gridHeight,
    required this.gridWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurBackgroundCard(
      width: gridWidth,
      height: gridHeight / 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildChartWidget(context),
      ),
    );
  }

  Widget _buildChartWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => MeasurementsScreen.show(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.line_weight_rounded,
                    color: kSecondaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    S.current.bodyMeasurement,
                    style: kSubtitle1w900Secondary,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: kSecondaryColor,
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
          builder: (context, ref, child) =>
              CustomStreamBuilderWidget<List<Measurement>>(
            stream: database.measurementsStreamThisWeek(),
            hasDataWidget: (context, data) => WeeklyMeasurementsChart(
              model: ref.watch(weeklyMeasurementsChartModelProvider),
              user: user,
              measurements: data,
            ),
          ),
        ),
      ],
    );
  }
}
