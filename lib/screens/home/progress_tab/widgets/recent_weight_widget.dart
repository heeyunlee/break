import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/progress_tab_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

class RecentWeightWidget extends StatelessWidget {
  final ProgressTabModel model;
  final User user;

  const RecentWeightWidget({Key? key, required this.model, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlurBackgroundCard(
      width: size.width / 2 - 24,
      height: 104,
      borderRadius: 8,
      child: CustomStreamBuilderWidget<List<Measurement>>(
        stream: model.database!.measurementsStream(),
        hasDataWidget: (context, list) {
          final lastMeasurement = list.last;
          final date = DateFormat.MMMEd().format(lastMeasurement.loggedDate);
          final weight = Formatter.weights(lastMeasurement.bodyWeight ?? 0);
          final unit = Formatter.unitOfMass(user.unitOfMass);
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: TextStyles.overline,
                ),
                const SizedBox(height: 8),
                Text(
                  '$weight $unit',
                  style: TextStyles.headline5_menlo_primary,
                ),
                const SizedBox(height: 2),
                Text(
                  '-2.2kg',
                  style: TextStyles.caption1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
