// import 'package:health/health.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:workout_player/classes/enum/custom_health_data_type.dart';
// import 'package:workout_player/utils/extensions.dart';

// import 'enum/custom_health_data_unit.dart';
// import 'enum/custom_platform_type.dart';

// part 'custom_health_data_point.g.dart';

// @JsonSerializable()
// class CustomHealthDataPoint {
//   final num value;
//   final CustomHealthDataType type;
//   final CustomHealthDataUnit unit;
//   final DateTime dateFrom;
//   final DateTime dateTo;
//   final CustomPlatformType platform;
//   final String deviceId;
//   final String sourceId;
//   final String sourceName;

//   const CustomHealthDataPoint({
//     required this.value,
//     required this.type,
//     required this.unit,
//     required this.dateFrom,
//     required this.dateTo,
//     required this.platform,
//     required this.deviceId,
//     required this.sourceId,
//     required this.sourceName,
//   });

//   factory CustomHealthDataPoint.fromJson(Map<String, dynamic> json) =>
//       _$CustomHealthDataPointFromJson(json);
//   Map<String, dynamic> toJson() => _$CustomHealthDataPointToJson(this);

//   factory CustomHealthDataPoint.fromRawData(HealthDataPoint data) {
//     return CustomHealthDataPoint(
//       value: data.value,
//       type: CustomHealthDataType.values.firstWhere(
//         (element) => enumToString(element) == enumToString(data.type),
//       ),
//       unit: CustomHealthDataUnit.values.firstWhere(
//         (element) => enumToString(element) == enumToString(data.unit),
//       ),
//       dateFrom: data.dateFrom,
//       dateTo: data.dateTo,
//       platform: CustomPlatformType.values.firstWhere(
//         (element) => enumToString(element) == enumToString(data.platform),
//       ),
//       deviceId: data.deviceId,
//       sourceId: data.sourceId,
//       sourceName: data.sourceName,
//     );
//   }
// }
