import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BodyMeasurement {
  final String bodyMeasurementId;
  final String userId;
  final String username;
  final Timestamp loggedTime;
  final DateTime loggedDate;
  final num bodyWeight;
  final num bodyFat;
  final num skeletalMuscleMass;
  final num bmi;
  final String notes;

  BodyMeasurement({
    @required this.bodyMeasurementId,
    @required this.userId,
    @required this.username,
    @required this.loggedTime,
    @required this.loggedDate,
    @required this.bodyWeight,
    this.bodyFat,
    this.skeletalMuscleMass,
    this.bmi,
    this.notes,
  });

  factory BodyMeasurement.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userId = data['userId'];
    final String username = data['username'];
    final Timestamp loggedTime = data['loggedTime'];
    final DateTime loggedDate = data['loggedDate'].toDate();
    final num bodyWeight = data['bodyWeight'];
    final num bodyFat = data['bodyFat'];
    final num skeletalMuscleMass = data['skeletalMuscleMass'];
    final num bmi = data['bmi'];
    final String notes = data['notes'];

    return BodyMeasurement(
      bodyMeasurementId: documentId,
      userId: userId,
      username: username,
      loggedTime: loggedTime,
      loggedDate: loggedDate,
      bodyWeight: bodyWeight,
      bodyFat: bodyFat,
      skeletalMuscleMass: skeletalMuscleMass,
      bmi: bmi,
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'loggedTime': loggedTime,
      'loggedDate': loggedDate,
      'bodyWeight': bodyWeight,
      'bodyFat': bodyFat,
      'skeletalMuscleMass': skeletalMuscleMass,
      'bmi': bmi,
      'notes': notes,
    };
  }
}
