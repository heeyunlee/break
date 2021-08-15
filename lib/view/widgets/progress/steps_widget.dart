// import 'package:flutter/material.dart';
// import 'package:workout_player/models/custom_health_data_point.dart';
// import 'package:workout_player/models/steps.dart';
// import 'package:workout_player/styles/text_styles.dart';

// class StepsWidget extends StatelessWidget {
//   final Steps? steps;

//   const StepsWidget({
//     Key? key,
//     required this.steps,
//   }) : super(key: key);

//   num calculate(BuildContext context) {
//     num totalSteps = 0;

//     if (steps != null) {
//       DateTime now = DateTime.now();
//       DateTime today = DateTime(now.year, now.month, now.day);

//       print(now);
//       print(today);

//       List<CustomHealthDataPoint>? todaysData = steps?.healthDataPoints
//           .where((element) => element.dateFrom.isAfter(today))
//           .toList()
//           .reversed
//           .toList();

//       print('first is ${todaysData?.first.toJson()}');
//       print('first is ${todaysData?[1].toJson()}');
//       print('first is ${todaysData?[2].toJson()}');
//       print('last is ${todaysData?.last.toJson()}');
//       print('length is ${todaysData?.length}');

//       todaysData?.forEach((e) => print(e.value));
//       todaysData?.forEach((e) => totalSteps += e.value);
//     }
//     return totalSteps;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.maxFinite,
//       height: 200,
//       child: Center(
//         child: Text('total steps today : ${calculate(context)}',
//             style: TextStyles.body1),
//       ),
//     );
//   }
// }
