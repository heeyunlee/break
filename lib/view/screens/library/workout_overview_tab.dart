import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/styles/text_styles.dart';

class WorkoutOverviewTab extends StatelessWidget {
  final Workout workout;

  const WorkoutOverviewTab({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Intl.getCurrentLocale();
    final String description =
        workout.translatedDescription?[locale]?.toString() ??
            workout.description;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionWidget(description),
          ],
        ),
      ),
    );
  }

  Text _buildDescriptionWidget(String description) {
    if (description.isNotEmpty) {
      return Text(
        description,
        style: TextStyles.body1_w800,
      );
    } else {
      return Text(S.current.addDescription, style: TextStyles.body2_light_grey);
    }
  }
}
