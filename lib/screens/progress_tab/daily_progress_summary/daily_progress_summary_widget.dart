import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/progress_tab/daily_progress_summary/daily_nutrition_widget.dart';

import 'daily_weights_widget.dart';

class DailyProgressSummaryWidget extends StatefulWidget {
  final User user;

  DailyProgressSummaryWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _DailyProgressSummaryWidgetState createState() =>
      _DailyProgressSummaryWidgetState();
}

class _DailyProgressSummaryWidgetState
    extends State<DailyProgressSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final String today = DateFormat.MMMEd().format(DateTime.now());
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.deepPurpleAccent,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.progressTabIntroduction(widget.user.displayName),
                style: kHeadline6,
              ),
              const Spacer(),
              Text(today, style: kBodyText1),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: size.width,
            height: size.height / 3,
            child: Stack(
              children: [
                DailyWeightsWidget(user: widget.user),
                DailyNutritionWidget(user: widget.user),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: SvgPicture.asset(
              'assets/images/person_lifting.svg',
              width: size.width / 2.5,
              height: size.width / 2.5,
            ),
          ),
        ],
      ),
    );
  }
}
