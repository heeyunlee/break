import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class DailySummaryCircleWidget extends StatefulWidget {
  @override
  _DailySummaryCircleWidgetState createState() =>
      _DailySummaryCircleWidgetState();
}

class _DailySummaryCircleWidgetState extends State<DailySummaryCircleWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: size.width / 2,
        width: size.width / 2,
        decoration: BoxDecoration(
          // color: Colors.grey,
          shape: BoxShape.circle,
          border: Border.all(width: 8, color: kPrimaryColor.withOpacity(0.5)),
        ),
      ),
    );
  }
}
