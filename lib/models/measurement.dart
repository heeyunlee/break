import 'package:cloud_firestore/cloud_firestore.dart';

class Measurement {
  final String measurementId;
  final String userId;
  final String username;
  final Timestamp loggedTime;
  final DateTime loggedDate;
  final num bodyWeight;
  final num? bodyFat; // Nullable
  final num? skeletalMuscleMass; // Nullable
  final num? bmi; // Nullable
  final String? notes; // Nullables

  const Measurement({
    required this.measurementId,
    required this.userId,
    required this.username,
    required this.loggedTime,
    required this.loggedDate,
    required this.bodyWeight,
    this.bodyFat,
    this.skeletalMuscleMass,
    this.bmi,
    this.notes,
  });

  factory Measurement.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String userId = data['userId'];
      final String username = data['username'];
      final Timestamp loggedTime = data['loggedTime'];
      final DateTime loggedDate = data['loggedDate'].toDate();
      final num bodyWeight = data['bodyWeight'];
      final num? bodyFat = data['bodyFat'];
      final num? skeletalMuscleMass = data['skeletalMuscleMass'];
      final num? bmi = data['bmi'];
      final String? notes = data['notes'];

      return Measurement(
        measurementId: documentId,
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
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
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
