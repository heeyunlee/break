import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/home/progress_tab/daily_progress_summary/daily_summary_numbers_widget.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class SecondPreviewWidgetChild extends StatelessWidget {
  const SecondPreviewWidgetChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size.width / 5,
              child: FittedBox(
                alignment: Alignment.center,
                child: const Text('가슴', style: TextStyles.headline5_w900),
              ),
            ),
            CircularPercentIndicator(
              radius: size.width / 2.4,
              lineWidth: 12,
              percent: 0.9,
              backgroundColor: kPrimaryColor.withOpacity(0.25),
              progressColor: kPrimaryColor,
              animation: true,
              animationDuration: 1000,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            Center(
              child: CircularPercentIndicator(
                radius: size.width / 3,
                lineWidth: 12,
                percent: 0.7,
                backgroundColor: Colors.greenAccent.withOpacity(0.25),
                progressColor: Colors.greenAccent,
                animation: true,
                animationDuration: 1000,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height / 16),
            SizedBox(
              height: size.height / 16,
              child: DailySummaryNumbersWidget(
                title: S.current.liftedWeights,
                tensOfTousands: '1',
                thousands: '2',
                hundreds: '5',
                tens: '9',
                ones: '0',
                unit: 'kg',
              ),
            ),
            SizedBox(
              height: size.height / 16,
              child: DailySummaryNumbersWidget(
                title: S.current.proteins,
                backgroundColor: Colors.greenAccent,
                textStyle: kBodyText1Menlo,
                hundreds: '1',
                tens: '3',
                ones: '0',
                unit: 'g',
              ),
            ),
            SizedBox(height: size.height / 16),
          ],
        ),
      ],
    );
  }
}
