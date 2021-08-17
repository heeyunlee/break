import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

class RecentSkeletenMuscleMassWidget extends StatelessWidget {
  final List<Measurement> measurements;
  final User user;

  const RecentSkeletenMuscleMassWidget({
    Key? key,
    required this.measurements,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unit = Formatter.unitOfMass(user.unitOfMass, user.unitOfMassEnum);

    final Measurement? lastMeasurement = measurements.isNotEmpty
        ? measurements
            .lastWhereOrNull((element) => element.skeletalMuscleMass != null)
        : null;
    final date = DateFormat.MMMEd().format(
      lastMeasurement?.loggedDate ?? DateTime.now(),
    );
    final skeletenMuscleMass = (lastMeasurement != null)
        ? Formatter.numWithDecimal(lastMeasurement.skeletalMuscleMass ?? 0)
        : '--.-';

    return BlurBackgroundCard(
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
                Text(
                  S.current.skeletalMuscleMass,
                  style: TextStyles.button1,
                ),
                const SizedBox(height: 4),
                Text(
                  '$skeletenMuscleMass $unit',
                  style: TextStyles.headline5_menlo_bold_secondary,
                ),
                // if (difference != null)
                //   Text(
                //     S.current.recentBodyFatWidgetSubtitle(formattedDif),
                //     style: TextStyles.caption1,
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
