import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:collection/collection.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/combined/progress_tab_class.dart';
// import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

import '../../../../view/screens/measurements_screen.dart';

class LatestWeightWidget extends StatelessWidget {
  final ProgressTabClass data;
  final BoxConstraints constraints;

  const LatestWeightWidget({
    Key? key,
    required this.data,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;

    final Measurement? lastDoc = data.measurements.isNotEmpty
        ? data.measurements.lastWhere((element) => element.bodyWeight != null)
        : null;

    // final bool showWidget = data.user.weightGoal != null && lastDoc != null;

    final date = DateFormat.MMMEd().format(
      lastDoc?.loggedDate ?? DateTime.now(),
    );

    final weight = (lastDoc != null)
        ? Formatter.numWithDecimal(lastDoc.bodyWeight)
        : '--.-';

    final unit = Formatter.unitOfMass(
      data.user.unitOfMass,
      data.user.unitOfMassEnum,
    );

    return SizedBox(
      height: constraints.maxHeight / heightFactor,
      width: (constraints.maxWidth - 16) / 2,
      child: BlurBackgroundCard(
        onTap: () => MeasurementsScreen.show(context, user: data.user),
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
                  Text(S.current.bodyWeight, style: TextStyles.button1),
                  Text(
                    '$weight $unit',
                    style: TextStyles.headline5MenloBoldLightBlueAccent,
                  ),
                  // if (showWidget) ..._buildProgressBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // TODO: Refactor
  // List<Widget> _buildProgressBar() {
  //   final unit = Formatter.unitOfMass(
  //     data.user.unitOfMass,
  //     data.user.unitOfMassEnum,
  //   );
  //   final bool goalExists = data.user.weightGoal != null;

  //   final Measurement? lastDoc = data.measurements.lastWhereOrNull(
  //     (element) => element.bodyWeight != null,
  //   );

  //   final Measurement? firstDoc = data.measurements.firstWhereOrNull(
  //     (element) => element.bodyWeight != null,
  //   );

  //   final goalWeight = Formatter.numWithDecimal(data.user.weightGoal);

  //   final startingWeight = Formatter.numWithDecimal(firstDoc?.bodyWeight);

  //   final num? initialWeightToLose = (firstDoc != null && goalExists)
  //       ? firstDoc.bodyWeight! - data.user.weightGoal!
  //       : null;

  //   final num? nowWeightToLose = (lastDoc != null && goalExists)
  //       ? lastDoc.bodyWeight! - data.user.weightGoal!
  //       : null;

  //   final double? diffPercentage =
  //       (initialWeightToLose != null && nowWeightToLose != null)
  //           ? nowWeightToLose / initialWeightToLose
  //           : null;

  //   assert((diffPercentage ?? 0) >= 0);

  //   final double? diffPercentageFormatted = ((diffPercentage ?? 0) > 1)
  //       ? 1
  //       : ((diffPercentage ?? 0) < 0)
  //           ? 0
  //           : diffPercentage;

  //   assert((diffPercentageFormatted ?? 0) >= 0);

  //   return [
  //     const SizedBox(height: 8),
  //     Stack(
  //       children: [
  //         Container(
  //           height: 4,
  //           decoration: BoxDecoration(
  //             color: Colors.white24,
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //         ),
  //         FractionallySizedBox(
  //           widthFactor: diffPercentageFormatted ?? 0.0,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: kSecondaryColor,
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //             height: 4,
  //           ),
  //         ),
  //       ],
  //     ),
  //     const SizedBox(height: 8),
  //     Row(
  //       children: [
  //         Text('$goalWeight $unit', style: TextStyles.caption1),
  //         const Spacer(),
  //         Text('$startingWeight $unit', style: TextStyles.caption1),
  //       ],
  //     ),
  //   ];
  // }
}
