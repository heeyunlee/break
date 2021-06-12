import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/progress_tab/daily_progress_summary/daily_nutrition_widget.dart';

import 'daily_weights_widget.dart';

class DailyProgressSummaryWidget extends StatelessWidget {
  final User user;
  final double widthFactor;
  final double heightFactor;
  final double opacity;

  DailyProgressSummaryWidget({
    Key? key,
    required this.user,
    required this.widthFactor,
    required this.heightFactor,
    required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat.MMMEd().format(DateTime.now());

    return Container(
      padding: EdgeInsets.all(widthFactor / 20),
      width: widthFactor,
      height: heightFactor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heightFactor / 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: widthFactor / 3,
                child: FittedBox(
                  child: Text(
                    S.current.progressTabIntroduction(user.displayName),
                    style: kHeadline6.copyWith(fontSize: widthFactor / 20),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: widthFactor / 4,
                child: FittedBox(
                  child: Text(
                    S.current.todayIs(today),
                    textAlign: TextAlign.end,
                    style: kBodyText1.copyWith(
                      height: 1.25,
                      fontSize: widthFactor / 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightFactor / 20),
          SizedBox(
            width: widthFactor,
            height: heightFactor / 3,
            child: FittedBox(
              child: Stack(
                children: [
                  DailyWeightsWidget(user: user),
                  DailyNutritionWidget(user: user),
                ],
              ),
            ),
          ),
          SizedBox(height: heightFactor / 15),
          Center(
            child: SvgPicture.asset(
              'assets/images/person_lifting.svg',
              width: widthFactor / 2.5,
              height: widthFactor / 2.5,
            ),
          ),
        ],
      ),
    );
  }
}
