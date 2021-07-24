import 'package:flutter/material.dart';
import 'package:workout_player/classes/custom_health_data_point.dart';
import 'package:workout_player/classes/steps.dart';
import 'package:workout_player/styles/text_styles.dart';

class StepsWidget extends StatelessWidget {
  final Steps? steps;

  const StepsWidget({
    Key? key,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    print(now);
    print(today);

    // final _dates = List<DateTime>.generate(7, (index) {
    //   return DateTime.utc(now.year, now.month, now.day - index);
    // });

    num totalSteps = 0;
    List<CustomHealthDataPoint>? todaysData = steps?.healthDataPoints
        .where((element) => element.dateFrom.isAfter(today))
        .toList()
        .reversed
        .toList();

    print('first is ${todaysData?.first.toJson()}');
    print('first is ${todaysData?[1].toJson()}');
    print('first is ${todaysData?[2].toJson()}');
    print('last is ${todaysData?.last.toJson()}');
    print('length is ${todaysData?.length}');

    todaysData?.forEach((e) => print(e.value));
    todaysData?.forEach((e) => totalSteps += e.value);

    return Container(
      width: double.maxFinite,
      height: 200,
      child: Center(
          child:
              Text('total steps today : $totalSteps', style: TextStyles.body1)),
    );
  }
}
