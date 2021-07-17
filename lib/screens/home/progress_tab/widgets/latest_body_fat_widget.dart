import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/progress_tab_class.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

import 'measurement/measurements_screen.dart';

class LatestBodyFatWidget extends StatelessWidget {
  final ProgressTabClass data;
  final BoxConstraints constraints;

  const LatestBodyFatWidget({
    Key? key,
    required this.data,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;

    final Measurement? lastDoc = data.measurements.lastWhereOrNull(
      (element) => element.bodyFat != null,
    );

    final bool showWidget =
        data.user.bodyFatPercentageGoal != null && lastDoc != null;

    final date = DateFormat.MMMEd().format(
      lastDoc?.loggedDate ?? DateTime.now(),
    );

    final bodyFat = (lastDoc != null)
        ? Formatter.weightsWithDecimal(lastDoc.bodyFat ?? 0)
        : '--.-';

    return SizedBox(
      height: constraints.maxHeight / heightFactor,
      width: (constraints.maxWidth - 16) / 2,
      child: BlurBackgroundCard(
        onTap: () => MeasurementsScreen.show(context),
        child: Stack(
          children: [
            Positioned(
              right: 16,
              top: 16,
              child: Text(date, style: TextStyles.overline),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showWidget) const SizedBox(height: 8),
                  Text(S.current.bodyFat, style: TextStyles.button1),
                  const SizedBox(height: 4),
                  Text(
                    '$bodyFat %',
                    style: TextStyles.headline5_menlo_bold_secondary,
                  ),
                  if (showWidget) ..._buildProgressBar(data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProgressBar(ProgressTabClass data) {
    final bool goalExists = data.user.bodyFatPercentageGoal != null;

    final Measurement? lastDoc = data.measurements.lastWhereOrNull(
      (element) => element.bodyFat != null,
    );

    final Measurement? firstDoc = data.measurements.firstWhereOrNull(
      (element) => element.bodyFat != null,
    );

    final goalBodyFat = Formatter.percentage(data.user.bodyFatPercentageGoal);

    final startingBodyFat = Formatter.percentage(firstDoc?.bodyFat);

    num? initialWeightToLose = (firstDoc != null && goalExists)
        ? firstDoc.bodyFat! - data.user.bodyFatPercentageGoal!
        : null;

    num? nowWeightToLose = (lastDoc != null && goalExists)
        ? lastDoc.bodyFat! - data.user.bodyFatPercentageGoal!
        : null;

    double? diffPercentage =
        (initialWeightToLose != null && nowWeightToLose != null)
            ? nowWeightToLose / initialWeightToLose
            : null;

    double? diffPercentageFormatted =
        ((diffPercentage ?? 0) > 1) ? 1 : diffPercentage;

    return [
      const SizedBox(height: 8),
      Stack(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          FractionallySizedBox(
            widthFactor: diffPercentageFormatted ?? 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
              height: 4,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Text(goalBodyFat, style: TextStyles.caption1),
          const Spacer(),
          Text(startingBodyFat, style: TextStyles.caption1),
        ],
      ),
    ];
  }
}
