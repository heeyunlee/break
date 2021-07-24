import 'package:json_annotation/json_annotation.dart';

enum CustomHealthDataUnit {
  @JsonValue('BEATS_PER_MINUTE')
  BEATS_PER_MINUTE,

  @JsonValue('CALORIES')
  CALORIES,

  @JsonValue('COUNT')
  COUNT,

  @JsonValue('DEGREE_CELSIUS')
  DEGREE_CELSIUS,

  @JsonValue('KILOGRAMS')
  KILOGRAMS,

  @JsonValue('METERS')
  METERS,

  @JsonValue('MILLIGRAM_PER_DECILITER')
  MILLIGRAM_PER_DECILITER,

  @JsonValue('MILLIMETER_OF_MERCURY')
  MILLIMETER_OF_MERCURY,

  @JsonValue('MILLISECONDS')
  MILLISECONDS,

  @JsonValue('MINUTES')
  MINUTES,

  @JsonValue('NO_UNIT')
  NO_UNIT,

  @JsonValue('PERCENTAGE')
  PERCENTAGE,

  @JsonValue('SIEMENS')
  SIEMENS,

  @JsonValue('UNKNOWN_UNIT')
  UNKNOWN_UNIT,

  @JsonValue('LITER')
  LITER,
}
