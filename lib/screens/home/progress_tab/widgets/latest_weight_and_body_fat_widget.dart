import 'package:flutter/material.dart';
import 'package:workout_player/models/progress_tab_class.dart';

import 'latest_weight_widget/latest_weight_widget.dart';
import 'recent_body_fat_percentage_widget.dart';

class LatestWeightAndBodyWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final ProgressTabClass data;

  const LatestWeightAndBodyWidget({
    Key? key,
    required this.constraints,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;

    return SizedBox(
      height: constraints.maxHeight / heightFactor,
      width: constraints.maxWidth,
      child: Row(
        children: [
          SizedBox(
            width: constraints.maxWidth / 2 - 24,
            child: RecentWeightWidget(
              user: data.user,
              measurements: data.measurements,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: constraints.maxWidth / 2 - 24,
            child: RecentBodyFatPercentageWidget(
              user: data.user,
              measurements: data.measurements,
            ),
          ),
        ],
      ),
    );
  }
}
