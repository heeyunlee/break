import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class DailySummaryNumbersWidget extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final Color? backgroundColor;
  final String? ones;
  final String? tens;
  final String? hundreds;
  final String? thousands;
  final String? tensOfTousands;
  final String unit;
  final MainAxisAlignment? mainAxisAlignment;

  const DailySummaryNumbersWidget({
    Key? key,
    required this.title,
    this.textStyle = kBodyText1Menlo,
    this.backgroundColor = kPrimaryColor,
    this.ones = '0',
    this.tens = '0',
    this.hundreds = '0',
    this.thousands,
    this.tensOfTousands,
    this.mainAxisAlignment = MainAxisAlignment.start,
    required this.unit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment!,
      children: [
        Text(title, style: TextStyles.body2),
        const SizedBox(height: 8),
        Row(
          children: [
            if (tensOfTousands != null)
              Container(
                width: 16,
                height: 24,
                margin: EdgeInsets.all(1),
                color: backgroundColor,
                child: Center(child: Text(tensOfTousands!, style: textStyle)),
              ),
            if (thousands != null)
              Container(
                width: 16,
                height: 24,
                margin: EdgeInsets.all(1),
                color: backgroundColor,
                child: Center(child: Text(thousands!, style: textStyle)),
              ),
            if (thousands != null) Text(',', style: kBodyText1Menlo),
            Container(
              width: 16,
              height: 24,
              margin: EdgeInsets.all(1),
              color: backgroundColor,
              child: Center(child: Text(hundreds!, style: textStyle)),
            ),
            Container(
              width: 16,
              height: 24,
              margin: EdgeInsets.all(1),
              color: backgroundColor,
              child: Center(child: Text(tens!, style: textStyle)),
            ),
            Container(
              width: 16,
              height: 24,
              margin: EdgeInsets.all(1),
              color: backgroundColor,
              child: Center(child: Text(ones!, style: textStyle)),
            ),
            const SizedBox(width: 4),
            Text(unit, style: kBodyText1Menlo),
          ],
        ),
      ],
    );
  }
}
