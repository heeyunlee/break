import 'package:json_annotation/json_annotation.dart';

enum CustomPlatformType {
  @JsonValue('IOS')
  IOS,

  @JsonValue('ANDROID')
  ANDROID,
}
