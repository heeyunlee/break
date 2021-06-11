import 'dart:math' as math;

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
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.deepPurpleAccent,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          // SizedBox(height: context.size!.height / 10),
          Opacity(
            opacity: math.pow(opacity, 3).toDouble(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width / 3,
                  child: FittedBox(
                    child: Text(
                      S.current.progressTabIntroduction(user.displayName),
                      style: kHeadline6,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: size.width / 4,
                  child: FittedBox(
                    child: Text(
                      S.current.todayIs(today),
                      textAlign: TextAlign.end,
                      style: kBodyText1.copyWith(height: 1.25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: widthFactor,
            // width: widthFactor,
            height: heightFactor / 3,
            // width: size.width,
            // width: context.size!.width,
            // height: context.size!.height / 3,
            // height: size.height / 3,
            child: FittedBox(
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  DailyWeightsWidget(user: user),
                  DailyNutritionWidget(user: user),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: SvgPicture.asset(
              'assets/images/person_lifting.svg',
              // width: context.size!.width / 2.5,
              // height: context.size!.width / 2.5,
              // width: size.width / 2.5,
              // height: size.width / 2.5,
              width: widthFactor / 2.5,
              height: widthFactor / 2.5,
            ),
          ),
        ],
      ),
    );
  }
}
