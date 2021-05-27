import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';

import 'daily_summary_numbers_widget.dart';

class DailyProgressSummaryWidget extends StatefulWidget {
  final User user;
  // final double? imageSize;

  const DailyProgressSummaryWidget({
    Key? key,
    required this.user,
    // this.imageSize,
  }) : super(key: key);
  @override
  _DailyProgressSummaryWidgetState createState() =>
      _DailyProgressSummaryWidgetState();
}

class _DailyProgressSummaryWidgetState
    extends State<DailyProgressSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String today = DateFormat.MMMEd().format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(24.0),
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
              Spacer(),
              Text(today, style: kBodyText1),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text('등', style: kHeadline4Bold),
                          CircularPercentIndicator(
                            radius: size.width / 2.7,
                            lineWidth: 12,
                            percent: 0.9,
                            backgroundColor:
                                Colors.greenAccent.withOpacity(0.25),
                            progressColor: Colors.greenAccent,
                            animation: true,
                            animationDuration: 1000,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          CircularPercentIndicator(
                            radius: size.width / 2.2,
                            lineWidth: 12,
                            percent: 0.65,
                            backgroundColor: kPrimaryColor.withOpacity(0.25),
                            progressColor: kPrimaryColor,
                            animation: true,
                            animationDuration: 1000,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DailySummaryNumbersWidget(
                            title: 'Weights Lifted',
                            tensOfTousands: '2',
                            thousands: '2',
                            hundreds: '3',
                            unit: 'lbs',
                          ),
                          const SizedBox(height: 16),
                          DailySummaryNumbersWidget(
                            title: 'Proteins',
                            textStyle: kBodyText1MenloBlack,
                            hundreds: '1',
                            tens: '2',
                            unit: 'g',
                            backgroundColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 96),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/person_lifting.svg',
                    width: size.width / 2.5,
                    height: size.width / 2.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
