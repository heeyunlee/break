import 'package:json_annotation/json_annotation.dart';

enum CustomPlatformType {
  @JsonValue('iOS')
  ios,

  @JsonValue('Android')
  android,
}
