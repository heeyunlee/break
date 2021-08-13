// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'custom_health_data_point.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// CustomHealthDataPoint _$CustomHealthDataPointFromJson(
//     Map<String, dynamic> json) {
//   return CustomHealthDataPoint(
//     value: json['value'] as num,
//     type: _$enumDecode(_$CustomHealthDataTypeEnumMap, json['type']),
//     unit: _$enumDecode(_$CustomHealthDataUnitEnumMap, json['unit']),
//     dateFrom: DateTime.parse(json['dateFrom'] as String),
//     dateTo: DateTime.parse(json['dateTo'] as String),
//     platform: _$enumDecode(_$CustomPlatformTypeEnumMap, json['platform']),
//     deviceId: json['deviceId'] as String,
//     sourceId: json['sourceId'] as String,
//     sourceName: json['sourceName'] as String,
//   );
// }

// Map<String, dynamic> _$CustomHealthDataPointToJson(
//         CustomHealthDataPoint instance) =>
//     <String, dynamic>{
//       'value': instance.value,
//       'type': _$CustomHealthDataTypeEnumMap[instance.type],
//       'unit': _$CustomHealthDataUnitEnumMap[instance.unit],
//       'dateFrom': instance.dateFrom.toIso8601String(),
//       'dateTo': instance.dateTo.toIso8601String(),
//       'platform': _$CustomPlatformTypeEnumMap[instance.platform],
//       'deviceId': instance.deviceId,
//       'sourceId': instance.sourceId,
//       'sourceName': instance.sourceName,
//     };

// K _$enumDecode<K, V>(
//   Map<K, V> enumValues,
//   Object? source, {
//   K? unknownValue,
// }) {
//   if (source == null) {
//     throw ArgumentError(
//       'A value must be provided. Supported values: '
//       '${enumValues.values.join(', ')}',
//     );
//   }

//   return enumValues.entries.singleWhere(
//     (e) => e.value == source,
//     orElse: () {
//       if (unknownValue == null) {
//         throw ArgumentError(
//           '`$source` is not one of the supported values: '
//           '${enumValues.values.join(', ')}',
//         );
//       }
//       return MapEntry(unknownValue, enumValues.values.first);
//     },
//   ).key;
// }

// const _$CustomHealthDataTypeEnumMap = {
//   CustomHealthDataType.ACTIVE_ENERGY_BURNED: 'ACTIVE_ENERGY_BURNED',
//   CustomHealthDataType.BASAL_ENERGY_BURNED: 'BASAL_ENERGY_BURNED',
//   CustomHealthDataType.BLOOD_GLUCOSE: 'BLOOD_GLUCOSE',
//   CustomHealthDataType.BLOOD_OXYGEN: 'BLOOD_OXYGEN',
//   CustomHealthDataType.BLOOD_PRESSURE_DIASTOLIC: 'BLOOD_PRESSURE_DIASTOLIC',
//   CustomHealthDataType.BLOOD_PRESSURE_SYSTOLIC: 'BLOOD_PRESSURE_SYSTOLIC',
//   CustomHealthDataType.BODY_FAT_PERCENTAGE: 'BODY_FAT_PERCENTAGE',
//   CustomHealthDataType.BODY_MASS_INDEX: 'BODY_MASS_INDEX',
//   CustomHealthDataType.BODY_TEMPERATURE: 'BODY_TEMPERATURE',
//   CustomHealthDataType.HEART_RATE: 'HEART_RATE',
//   CustomHealthDataType.HEART_RATE_VARIABILITY_SDNN:
//       'HEART_RATE_VARIABILITY_SDNN',
//   CustomHealthDataType.HEIGHT: 'HEIGHT',
//   CustomHealthDataType.RESTING_HEART_RATE: 'RESTING_HEART_RATE',
//   CustomHealthDataType.STEPS: 'STEPS',
//   CustomHealthDataType.WAIST_CIRCUMFERENCE: 'WAIST_CIRCUMFERENCE',
//   CustomHealthDataType.WALKING_HEART_RATE: 'WALKING_HEART_RATE',
//   CustomHealthDataType.WEIGHT: 'WEIGHT',
//   CustomHealthDataType.DISTANCE_WALKING_RUNNING: 'DISTANCE_WALKING_RUNNING',
//   CustomHealthDataType.FLIGHTS_CLIMBED: 'FLIGHTS_CLIMBED',
//   CustomHealthDataType.MOVE_MINUTES: 'MOVE_MINUTES',
//   CustomHealthDataType.DISTANCE_DELTA: 'DISTANCE_DELTA',
//   CustomHealthDataType.MINDFULNESS: 'MINDFULNESS',
//   CustomHealthDataType.WATER: 'WATER',
//   CustomHealthDataType.SLEEP_IN_BED: 'SLEEP_IN_BED',
//   CustomHealthDataType.SLEEP_ASLEEP: 'SLEEP_ASLEEP',
//   CustomHealthDataType.SLEEP_AWAKE: 'SLEEP_AWAKE',
//   CustomHealthDataType.HIGH_HEART_RATE_EVENT: 'HIGH_HEART_RATE_EVENT',
//   CustomHealthDataType.LOW_HEART_RATE_EVENT: 'LOW_HEART_RATE_EVENT',
//   CustomHealthDataType.IRREGULAR_HEART_RATE_EVENT: 'IRREGULAR_HEART_RATE_EVENT',
//   CustomHealthDataType.ELECTRODERMAL_ACTIVITY: 'ELECTRODERMAL_ACTIVITY',
// };

// const _$CustomHealthDataUnitEnumMap = {
//   CustomHealthDataUnit.BEATS_PER_MINUTE: 'BEATS_PER_MINUTE',
//   CustomHealthDataUnit.CALORIES: 'CALORIES',
//   CustomHealthDataUnit.COUNT: 'COUNT',
//   CustomHealthDataUnit.DEGREE_CELSIUS: 'DEGREE_CELSIUS',
//   CustomHealthDataUnit.KILOGRAMS: 'KILOGRAMS',
//   CustomHealthDataUnit.METERS: 'METERS',
//   CustomHealthDataUnit.MILLIGRAM_PER_DECILITER: 'MILLIGRAM_PER_DECILITER',
//   CustomHealthDataUnit.MILLIMETER_OF_MERCURY: 'MILLIMETER_OF_MERCURY',
//   CustomHealthDataUnit.MILLISECONDS: 'MILLISECONDS',
//   CustomHealthDataUnit.MINUTES: 'MINUTES',
//   CustomHealthDataUnit.NO_UNIT: 'NO_UNIT',
//   CustomHealthDataUnit.PERCENTAGE: 'PERCENTAGE',
//   CustomHealthDataUnit.SIEMENS: 'SIEMENS',
//   CustomHealthDataUnit.UNKNOWN_UNIT: 'UNKNOWN_UNIT',
//   CustomHealthDataUnit.LITER: 'LITER',
// };

// const _$CustomPlatformTypeEnumMap = {
//   CustomPlatformType.IOS: 'IOS',
//   CustomPlatformType.ANDROID: 'ANDROID',
// };
