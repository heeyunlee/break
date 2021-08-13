// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:workout_player/classes/custom_health_data_point.dart';

// class Steps {
//   final List<CustomHealthDataPoint> healthDataPoints;
//   final Timestamp lastUpdateTime;
//   final String ownerId;

//   const Steps({
//     required this.healthDataPoints,
//     required this.lastUpdateTime,
//     required this.ownerId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'healthDataPoints': healthDataPoints.map((e) => e.toJson()).toList(),
//       'lastUpdateTime': lastUpdateTime,
//       'ownerId': ownerId,
//     };
//   }

//   factory Steps.fromMap(Map<String, dynamic> map) {
//     final List<CustomHealthDataPoint> healthDataPoints =
//         List<CustomHealthDataPoint>.from(
//       map['healthDataPoints']
//           .map((e) => CustomHealthDataPoint.fromJson(e))
//           .toList(),
//     );
//     final Timestamp lastUpdateTime = map['lastUpdateTime'];
//     final String ownerId = map['ownerId'];

//     return Steps(
//       healthDataPoints: healthDataPoints,
//       lastUpdateTime: lastUpdateTime,
//       ownerId: ownerId,
//     );
//   }
// }
