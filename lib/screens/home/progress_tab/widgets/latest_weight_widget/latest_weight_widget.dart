import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

class RecentWeightWidget extends StatelessWidget {
  final List<Measurement> measurements;
  final User user;

  const RecentWeightWidget({
    Key? key,
    required this.measurements,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unit = Formatter.unitOfMass(user.unitOfMass);

    final Measurement? lastMeasurement = measurements.isNotEmpty
        ? measurements.lastWhere((element) => element.bodyWeight != null)
        : null;

    final date = DateFormat.MMMEd().format(
      lastMeasurement?.loggedDate ?? DateTime.now(),
    );

    final weight = (lastMeasurement != null)
        ? Formatter.weights(lastMeasurement.bodyWeight!)
        : '--.-';

    final difference = (user.weightGoal != null && lastMeasurement != null)
        ? user.weightGoal! - lastMeasurement.bodyWeight!
        : null;

    final formattedDif = Formatter.weightsWithDecimal(difference ?? 0);

    return BlurBackgroundCard(
      child: Stack(
        // alignment: Alignment.bottomCenter,
        children: [
          // FractionallySizedBox(
          //   heightFactor: 0.4,
          //   child: Container(color: Colors.amber),
          // ),
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
                Text(S.current.bodyWeight, style: TextStyles.button1),
                const SizedBox(height: 4),
                Text(
                  '$weight $unit',
                  style: TextStyles.headline5_menlo_bold_secondary,
                ),
                const SizedBox(height: 4),
                if (difference != null)
                  Text(
                    S.current.recentWeightWidgetSubtitle('$formattedDif $unit'),
                    style: TextStyles.caption1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
