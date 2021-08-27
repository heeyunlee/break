import 'package:json_annotation/json_annotation.dart';

enum CustomHealthDataType {
  @JsonValue('Active Energy Burned')
  activeEnergyBurned,

  @JsonValue('Basal Energy Burned')
  basalEnergyBurned,

  @JsonValue('Blood Glucose')
  bloodGlucose,

  @JsonValue('Blood Oxygen')
  bloodOxygen,

  @JsonValue('Blood Pressure Diastolic')
  bloodPressureDiastolic,

  @JsonValue('Blood Pressure Systolic')
  bloodPressureSystolic,

  @JsonValue('Body Fat Percentage')
  bodyFatPercentage,

  @JsonValue('Body Mass Index')
  bodyMassIndex,

  @JsonValue('Body Temperature')
  bodyTemperature,

  @JsonValue('Heart Rate')
  heartRate,

  @JsonValue('Heart Rate Variability SDNN')
  heartRateVariabilitySdnn,

  @JsonValue('Height')
  height,

  @JsonValue('Resting Heart Rate')
  restingHeartRate,

  @JsonValue('Steps')
  steps,

  @JsonValue('WaistCircumfence')
  waistCircumfence,

  @JsonValue('Walking Heart Rate')
  walkingHeartRate,

  @JsonValue('Weight')
  weight,

  @JsonValue('Distance Walking Running')
  distanceWalkingRunning,

  @JsonValue('Flights Climbed')
  flightsClimbed,

  @JsonValue('Move Minutes')
  moveMinutes,

  @JsonValue('Distance Delta')
  distanceDelta,

  @JsonValue('Mindfulness')
  mindfulness,

  @JsonValue('Water')
  water,

  @JsonValue('Sleep In Bed')
  sleepInBed,

  @JsonValue('Sleep As leep')
  sleepAsleep,

  @JsonValue('Sleep Awake')
  sleepAwake,

  @JsonValue('High Heart Rate Event')
  highHeartRateEvent,

  @JsonValue('Low Heart Rate Event')
  lowHeartRateEvent,

  @JsonValue('Irregular Heart Rate Event')
  irregularHeartRateEvent,

  @JsonValue('Electrodermal Activity')
  electrodermalActivity,
}
