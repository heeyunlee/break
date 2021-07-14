import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/progress_tab_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

class RecentSkeletenMuscleMassWidget extends StatelessWidget {
  final ProgressTabModel model;
  final User user;
  // final double gridHeight;
  // final double gridWidth;

  const RecentSkeletenMuscleMassWidget({
    Key? key,
    required this.model,
    required this.user,
    // required this.gridHeight,
    // required this.gridWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurBackgroundCard(
      // width: gridWidth / 2 - 8,
      // height: gridHeight / 4 - 32,
      vertPadding: 0,
      child: CustomStreamBuilderWidget<List<Measurement>>(
        stream: model.database!.measurementsStream(),
        hasDataWidget: (context, list) {
          final unit = Formatter.unitOfMass(user.unitOfMass);

          final Measurement? lastMeasurement = list.isNotEmpty
              ? list.lastWhereOrNull(
                  (element) => element.skeletalMuscleMass != null)
              : null;
          final date = DateFormat.MMMEd().format(
            lastMeasurement?.loggedDate ?? DateTime.now(),
          );
          final weight = (lastMeasurement != null)
              ? Formatter.weightsWithDecimal(
                  lastMeasurement.skeletalMuscleMass ?? 0)
              : '--.-';

          return Stack(
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
                      '$weight $unit',
                      style: TextStyles.headline5_menlo_bold_secondary,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
