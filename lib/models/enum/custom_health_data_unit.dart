import 'package:json_annotation/json_annotation.dart';

enum CustomHealthDataUnit {
  @JsonValue('Beats Per Minute')
  beatsPerMinute,

  @JsonValue('Calories')
  calories,

  @JsonValue('Count')
  count,

  @JsonValue('Degree Celsius')
  degreeCelsius,

  @JsonValue('Kilograms')
  kilograms,

  @JsonValue('Meters')
  meters,

  @JsonValue('Milligram Per Deciliter')
  milligramPerDeciliter,

  @JsonValue('Millimeter Of Mercury')
  millimeterOfMercury,

  @JsonValue('Milliseconds')
  milliseconds,

  @JsonValue('Minutes')
  minutes,

  @JsonValue('No Unit')
  noUnit,

  @JsonValue('Percentage')
  percentage,

  @JsonValue('Siemens')
  siemens,

  @JsonValue('Unkown Unit')
  unkownUnit,

  @JsonValue('Liter')
  liter,
}
